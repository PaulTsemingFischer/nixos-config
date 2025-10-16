{
  config,
  lib,
  pkgs,
  ...
}: {
  # NVIDIA Configuration
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required for most Wayland compositors
    modesetting.enable = true;

    # Enable power management (important for laptops)
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern NVIDIA GPUs (Turing or newer)
    powerManagement.finegrained = true;

    # Use the open source kernel module (for newer cards like RTX 4060)
    # If you experience issues, set this to false for proprietary drivers
    open = false;

    # Enable the NVIDIA settings menu
    nvidiaSettings = true;

    # Optionally, select the driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # NVIDIA Optimus PRIME configuration
    prime = {
      # Make sure to use the correct Bus ID values for your system!
      # Find them with: lspci | grep -E "VGA|3D"
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";

      # Option 1: Offload mode (recommended for laptops)
      # Intel for display, NVIDIA on-demand for specific apps
      offload = {
        enable = true;
        enableOffloadCmd = true; # Provides nvidia-offload command
      };

      # Option 2: Sync mode (NVIDIA always on)
      # Uncomment if you want NVIDIA to always be active
      # sync.enable = true;

      # Option 3: Reverse sync (NVIDIA renders, Intel displays)
      # Uncomment for external monitors connected to Intel graphics
      # reverseSync.enable = true;
    };
  };

  # Blacklist nouveau (open-source NVIDIA driver)
  boot.blacklistedKernelModules = ["nouveau"];
}
