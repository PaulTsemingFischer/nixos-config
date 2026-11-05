# Windows Hello-style face unlock (Howdy), driving this laptop's IR camera.
# Laptop-only: penglpc has no IR camera, which is why this lives under
# hosts/penglaptop/ rather than in nixos/.
#
# Hardware notes (gathered on this machine, kernel 6.18):
#   The "Integrated Camera" (USB 174f:11ad, Syntek) exposes two UVC interfaces.
#   Interface :1.0 is the normal RGB camera -> /dev/video0 (+ video1 metadata).
#   Interface :1.2 is the IR camera        -> /dev/video2 (+ video3 metadata),
#   streaming GREY/Y800 at 640x360@20. It's a plain uvcvideo device, not an
#   Intel IPU6/MIPI sensor, so Howdy can talk to it directly with no
#   out-of-tree camera stack.
#
# ONE-TIME MANUAL SETUP after the first rebuild (see the comments below):
#   1. sudo linux-enable-ir-emitter configure
#   2. sudo howdy -U pengl add
#   3. sudo howdy -U pengl test
{ ... }:
{
  services.howdy = {
    enable = true;

    # The module's default is "required", which makes a face match an *extra*
    # factor on top of the password rather than a replacement for it.
    # "sufficient" is what gives Windows Hello-like behaviour: a match
    # satisfies PAM on its own, and a miss falls through to the password
    # prompt. This applies to every PAM service (gdm, the GNOME lock screen,
    # sudo, polkit, ...) via security.pam.howdy.enable; sshd is covered by
    # Howdy's own abort_if_ssh, which defaults to true.
    control = "sufficient";

    # Without this, pam_howdy scans silently while GDM is unable to draw its
    # password field yet -- you get several seconds of blank grey greeter with
    # no hint that a camera is waiting on you, which is how the first login
    # after a reboot "failed": the scan timed out because nobody knew to look
    # at the lens. This makes PAM announce the attempt instead.
    #
    # Note the fix is NOT a longer video.timeout: pam_howdy sits ahead of
    # pam_unix in the stack, so the whole timeout elapses before the password
    # field becomes usable. Raising it lengthens exactly the dead period that
    # caused the confusion. core.workaround ("input"/"native") is what allows
    # face and password entry concurrently, but upstream flags "native" as
    # possibly unstable, so it's not worth risking on the login path.
    settings.core.detection_notice = true;

    settings.video = {
      # Addressed through the by-id symlink instead of /dev/video2: the
      # videoN numbering is only stable by probe order, and getting it wrong
      # points Howdy at the RGB camera (which the IR emitter never lights).
      # Falls back to "/dev/video2" if the symlink ever stops resolving --
      # check with `realpath /dev/v4l/by-id/*-video-index0`.
      device_path = "/dev/v4l/by-id/usb-_Integrated_Camera_200901010001-video-index0";

      # dark_threshold is the maximum tolerated percentage of *dark pixels*
      # in a frame, not a brightness floor, and the test is `darkness >
      # dark_threshold` -- so raising it makes Howdy more tolerant, which is
      # the opposite of what the name suggests.
      #
      # 60 (the default) rejects every frame on this camera. The emitter works,
      # but it only modestly lights the subject while the background stays
      # black, and this metric is whole-frame: measured via compare.py (the
      # script pam_howdy actually runs) the post-CLAHE darkness averages ~77%,
      # so authentication failed with "image too dark" (exit 13) even though
      # the face itself was perfectly visible.
      #
      # Do NOT trust `howdy test` to validate this -- its on-screen
      # SCAN/DARK FRAME label disagrees with compare.py and showed frames
      # passing while real auth was rejecting all of them. Verify with:
      #   cd <howdy>/lib/howdy && sudo <python> compare.py pengl
      dark_threshold = 90;
    };
  };

  # This camera's IR emitter does not switch on just because the stream was
  # opened: capturing from /dev/video2 as-is yields near-black frames (average
  # luma well under 1/255), so Howdy would be matching against darkness.
  # linux-enable-ir-emitter brute-forces the camera's UVC extension-unit
  # controls to find the one that fires the emitter, then re-applies it at boot
  # and after every resume.
  #
  # The discovered control is runtime state in
  # /var/lib/linux-enable-ir-emitter, not something this file can declare, so
  # it needs `sudo linux-enable-ir-emitter configure` once. Until that's run
  # the unit just fails harmlessly on every boot.
  services.linux-enable-ir-emitter = {
    enable = true;
    device = "video2";
  };
}
