{ config, pkgs, ... }:
{
  imports = [
          <nixpkgs/nixos/modules/profiles/minimal.nix>
          <nixpkgs/nixos/modules/virtualisation/container-config.nix>
          <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
          ./build.nix
          ./networking.nix
	  ./users.nix
          ./virt.nix
  ];

  environment.systemPackages = with pkgs; [
    nvi
    screen
    vim
    mkpasswd
    lftp
    git
    nixops
    wget
    openssl
#    stack
    libguestfs
  ];

  nix.useSandbox = true;
#  boot.enableContainers = true;
#  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
#  users.extraUsers.root.openssh.authorizedKeys.keys =
#    [ "..." ];
#  services.openssh.extraConfig = ''
#    ServerAliveInterval 60
#  '';

  services.resolved.enable = false;
  networking.nameservers = [ "172.18.2.10" "172.18.2.11" "208.67.222.222" "208.67.220.220" ];

  networking.firewall.enable = true;
#  networking.firewall.allowedTCPPorts = [ 80 443 ];
#  networking.firewall.connectionTrackingModules = [ "ftp" ];
#  networking.firewall.autoLoadConntrackHelpers = true;

  services.fail2ban.enable = true;
  services.fail2ban.jails.ssh-iptables = "enabled = true";

  documentation.enable = true;
  services.nixosManual.enable = true;

  time.timeZone = "Europe/Bratislava";
  system.stateVersion = "18.09";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

}
