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

  boot.kernel.sysctl."net.ipv6.conf.wlp1s0.disable_ipv6" = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  console.keyMap = "uk";

  environment.systemPackages = with pkgs; [
    bat
    gh
    git
    google-chrome
    tldr
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        eamodio.gitlens
        hashicorp.terraform
        ms-azuretools.vscode-docker
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-vscode.powershell
        ms-vscode-remote.remote-ssh
        redhat.ansible
        redhat.vscode-xml
        redhat.vscode-yaml
        yzhang.markdown-all-in-one
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "prettify-json";
          publisher = "mohsen1";
          version = "0.0.3";
          sha256 = "sha256-lvds+lFDzt1s6RikhrnAKJipRHU+Dk85ZO49d1sA8uo=";
        }
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
    enableIPv6  = false;
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
    displayManager.lightdm = {
      enable = true;
      greeters = {
        slick.enable = false;
        gtk.enable = true;
      };
    };
    videoDrivers = [ "displaylink" "modesetting" ];
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
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
      guake
      joplin-desktop
      terminator
      thunderbird
    ];
  };

  virtualisation.docker.enable = true;

  ##### home-manager

  home-manager.users.james = { 
    home.stateVersion = "24.05";
    
    programs.git = {
        enable = true;
        userName = "James Kelly";
        userEmail = "jamesdkelly88@outlook.com";
        extraConfig = {
          credential.helper = "store";
        };
    };

    xsession.numlock.enable = true;
  };

  system.stateVersion = "24.05";
}
