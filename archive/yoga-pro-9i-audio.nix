{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Lenovo Yoga Pro 9i (16IMH9) Audio Fix
  # This laptop has a quad-speaker setup (2 woofers + 2 tweeters) with Realtek ALC287 codec
  # The SOF driver needs proper configuration to enable all speakers

  # Enable firmware
  hardware.enableRedistributableFirmware = true;

  # Force SOF driver - no model needed, we'll handle it in UCM/WirePlumber
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=3
  '';

  # PipeWire configuration
  services.pipewire.wireplumber.configPackages = [
    # UCM configuration for Lenovo Yoga Pro 9i
    (pkgs.writeTextDir "share/alsa/ucm2/conf.d/sof-hda-dsp/LENOVO-83DN-YogaPro916IMH9-INVALID.conf" ''
      Syntax 4

      Comment "Lenovo Yoga Pro 9i 16IMH9 (83DN)"

      If.cfg-dmics {
        Condition {
          Type String
          Haystack "$${CardComponents}"
          Needle "cfg-dmics:4"
        }
        True.Define.MicComponents "cfg-dmics:4"
      }

      Define {
        BassSpeakerAmplifier "codec:0,0x17"
        SpeakerAmplifier "codec:0,0x14"
      }

      Include.card-init.File "/codecs/hda/init.conf"
      Include.components-codecs.File "/lib/card/components-codecs.conf"

      If.components {
        Condition {
          Type String
          Haystack "$${CardComponents}"
          Needle "HDA:10ec0287"
        }
        True {
          Include.codec-file.File "/codecs/hda/realtek-alc287.conf"
        }
      }

      Include.card-common.File "/sof-hda-dsp/sof-hda-dsp.conf"
    '')

    # HiFi configuration
    (pkgs.writeTextDir "share/alsa/ucm2/sof-hda-dsp/LENOVO-83DN-YogaPro916IMH9-INVALID/HiFi.conf" ''
      Define {
        SpeakerMasterElem "Master"
        SpeakerPCM "hw:$${CardId},0"
        HeadphonesMasterElem "Headphone"
        DigitalMicPCM "hw:$${CardId},6"
        HeadsetMicPCM "hw:$${CardId},0"
      }

      Include.hdmi.File "/sof-hda-dsp/hdmi.conf"

      If.cfg-mh {
        Condition {
          Type String
          Empty "$${var:MonoHeadsetMic}"
        }
        False {
          Include.hdmi.File "/platforms/sof-soundwire/headset-config.conf"
        }
      }

      SectionDevice."Speaker" {
        Comment "Speaker"
        
        EnableSequence [
          cset "name='Speaker Switch' on"
          cset "name='Bass Speaker Switch' on"
          cset "name='Headphone Switch' off"
          cset "name='DAC1 Playback Volume' 87"
          cset "name='DAC2 Playback Volume' 87"
        ]

        DisableSequence [
        ]

        Value {
          PlaybackPriority 100
          PlaybackPCM "hw:$${CardId},0"
          PlaybackMixerElem "$${SpeakerMasterElem}"
          PlaybackMasterElem "$${SpeakerMasterElem}"
        }
      }

      SectionDevice."Headphones" {
        Comment "Headphones"

        EnableSequence [
          cset "name='Headphone Switch' on"
          cset "name='Speaker Switch' off"
          cset "name='Bass Speaker Switch' off"
        ]

        DisableSequence [
          cset "name='Headphone Switch' off"
        ]

        Value {
          PlaybackPriority 200
          PlaybackPCM "hw:$${CardId},0"
          PlaybackMixerElem "$${HeadphonesMasterElem}"
          JackControl "Headphone Jack"
        }
      }
    '')

    # WirePlumber configuration to force UCM and proper routing
    (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-lenovo-yoga-speakers.conf" ''
      monitor.alsa.rules = [
        {
          matches = [
            {
              device.name = "~alsa_card.*sof-hda-dsp.*"
            }
          ]
          actions = {
            update-props = {
              api.alsa.use-ucm = true
              api.alsa.soft-mixer = false
              device.profile-set = "sof-hda-dsp.conf"
            }
          }
        }
        {
          matches = [
            {
              node.name = "~alsa_output.*sof.*Speaker.*"
            }
          ]
          actions = {
            update-props = {
              audio.format = "S16LE"
              audio.rate = 48000
              api.alsa.period-size = 1024
              api.alsa.headroom = 384
              session.suspend-timeout-seconds = 0
              resample.quality = 4
            }
          }
        }
      ]
    '')
  ];

  # Install audio debugging tools
  environment.systemPackages = with pkgs; [
    alsa-utils
    alsa-tools # includes hda-verb
    pavucontrol
    helvum
  ];

  # Systemd service to unmute hardware amplifiers on boot
  systemd.services.yoga-audio-fix = {
    description = "Lenovo Yoga Pro 9i Audio Fix - Unmute Hardware Amplifiers";
    after = [
      "sound.target"
      "alsa-restore.service"
    ];
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.alsa-tools
      pkgs.alsa-utils
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "yoga-audio-unmute" ''
        # Wait for audio device to be ready
        sleep 2

        # Enable TAS smart amplifier firmware loading (CRITICAL!)
        ${pkgs.alsa-utils}/bin/amixer -c 0 cset numid=3 on

        # Unmute node 0x14 (main speakers) - SET_AMP_GAIN_MUTE output, unmute both channels
        ${pkgs.alsa-tools}/bin/hda-verb /dev/snd/hwC0D0 0x14 SET_AMP_GAIN_MUTE 0xb000
        ${pkgs.alsa-tools}/bin/hda-verb /dev/snd/hwC0D0 0x14 SET_AMP_GAIN_MUTE 0xb080

        # Unmute node 0x17 (bass speakers) - SET_AMP_GAIN_MUTE output, unmute both channels  
        ${pkgs.alsa-tools}/bin/hda-verb /dev/snd/hwC0D0 0x17 SET_AMP_GAIN_MUTE 0xb000
        ${pkgs.alsa-tools}/bin/hda-verb /dev/snd/hwC0D0 0x17 SET_AMP_GAIN_MUTE 0xb080

        # Ensure ALSA switches are on
        ${pkgs.alsa-utils}/bin/amixer -c 0 sset 'Speaker' on
        ${pkgs.alsa-utils}/bin/amixer -c 0 sset 'Bass Speaker' on
      '';
    };
  };
}
