{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  hostname = "lt16";
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  console.keyMap = "uk";

  environment.systemPackages = with pkgs; [
    gh
    git
    google-chrome
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        eamodio.gitlens
      ];
    })
  ];

  hardware.pulseaudio.enable = false;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  networking = {
    firewall.enable = true;
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    hostName = "${hostname}";
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  security.rtkit.enable = true;

  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  services.xserver = {
    enable = true;
    desktopManager.cinnamon.enable = true;
    displayManager.lightdm.enable = true;
    xkb = {
      layout = "gb";
      variant = "";
    };
  };

  time.timeZone = "Europe/London";

  users.users.ansible = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users.james = {
    isNormalUser = true;
    description = "James Kelly";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      guake
      joplin-desktop
      terminator
      thunderbird
    ];
  };

  home-manager.users.james = { 
    home.stateVersion = "24.05";
    
    programs.git = {
        enable = true;
        userName = "James Kelly";
        userEmail = "jamesdkelly88@outlook.com";
    };
  };

  system.stateVersion = "24.05";
}
