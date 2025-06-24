# ---------------------- #
# MY-NIXOS CONFIGURATION #
# ---------------------- #

# Configuration, library and more #
{ config, lib, pkgs, ... }:

{
  imports = [
    # Hardware #
    ./hardware-configuration.nix
  ];

  # Kernel #
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader #
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot.enable = false;
  };

  # Network #
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Timezone #
  time.timeZone = "Europe/Istanbul";

  # Internationalisation #
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "tr_TR.UTF-8";
      LC_IDENTIFICATION = "tr_TR.UTF-8";
      LC_MEASUREMENT = "tr_TR.UTF-8";
      LC_MONETARY = "tr_TR.UTF-8";
      LC_NAME = "tr_TR.UTF-8";
      LC_NUMERIC = "tr_TR.UTF-8";
      LC_PAPER = "tr_TR.UTF-8";
      LC_TELEPHONE = "tr_TR.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # X11 #
  services.xserver.enable = true;

  # Desktop #
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Keymap X11 #
  services.xserver.xkb.layout = "tr";

  # Keymap in console #
  console.keyMap = "trq";

  # Printing #
  # services.printing.enable = true;

  # Packages managements #
  services.flatpak.enable = true;

  # Bluetooth #
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Sound #
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Touchpad #
  services.libinput.enable = true;

  # Cachix #
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # OpenGL #
  hardware.opengl = {
  enable = true;
  driSupport = true;
  driSupport32Bit = true;
  };

  # Wayland Electron #
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Shell #
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh bash ];
  environment.shellAliases = {
    nixrb = "sudo nixos-rebuild switch";
    nixconf = "sudo nano /etc/nixos/configuration.nix";
    nixup = "sudo nixos-rebuild switch --upgrade";
    nixclean = "sudo nix-collect-garbage";
  };

  # User account #
  users.users.hasan = {
    isNormalUser = true;
    description = "Hasan";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "flatpak" ];
    packages = with pkgs; [ ];
  };

  # Unfree packages #
  nixpkgs.config.allowUnfree = true;

  # Browser #
  programs.firefox.enable = true;

  # Gnome #
  environment.gnome.excludePackages = with pkgs; [
    atomix baobab epiphany evince geary gnome-backgrounds gnome-boxes
    gnome-clocks gnome-connections gnome-contacts gnome-font-viewer
    gnome-logs gnome-maps gnome-software gnome-system-monitor
    gnome-text-editor gnome-tour gnome-weather hitori iagno
    simple-scan tali yelp
  ];

  # All packages #
  environment.systemPackages = with pkgs; [
    # Tuis #
    alsa-utils curl eza fastfetch fzf gcc_multi git jq libgcc
    nitch nix-search-cli nix-zsh-completions oh-my-zsh python314
    wget zsh zsh-autosuggestions zsh-syntax-highlighting zsh-z zoxide

    # Apps #
    bottles discord gimp libreoffice-qt6-fresh librecad lutris
    gnome-tweaks steam thunderbird

    # Fonts #
    nerd-fonts.caskaydia-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];

  # System version #
  system.stateVersion = "25.11";
}
