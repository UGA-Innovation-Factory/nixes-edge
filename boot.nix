{ config, pkgs, lib, ... }:
{
  # Bootloader configuration for systemd-boot (UEFI systems)
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Set up GRUB 2 with GA-AIM logo as splash image
  boot.loader.grub = {
    enable = true;
    device = "nodev"; # for EFI systems, set to your specific device, or use "nodev" for UEFI-only systems
    efiSupport = true;
    gfxmodeEfi = "auto";
    gfxpayloadEfi = "keep";
    configurationLimit = 5;
  };
  
  # Boot silently
  boot.kernelParams = [ "quiet" "rd.systemd.show_status=false"]; # Ensure a quiet boot
  boot.consoleLogLevel = 0;

  # Set up locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Specify Nix specific options
  system.stateVersion = "24.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable SSH for remote access
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}

