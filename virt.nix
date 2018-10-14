{ config, lib, pkgs, ... }:

#  include from configuration.nix, change networking.nat.externalIP

let
  nixopsRepo = pkgs.fetchFromGitHub {
    owner = "vpsfreecz";
    repo = "nixops";
    rev = "668a0f9de10c04dbb7df8c1e4f2be7b064834432";
    sha256 = "05ahx1snrddb715r1pdbjk1ywfqa829c6wys9icawxygh2ngspki";
  };
  bridgeName = "br0";
in
{
  nix.buildCores = 8;
  
  virtualisation.libvirtd.enable = true;
  users.extraUsers.kriloter.extraGroups = [ "libvirtd" ];
  networking.firewall.checkReversePath = false;
  networking.interfaces.venet0.useDHCP = false;
  
  networking.nat = {
    enable = true;
    internalInterfaces = [ "${bridgeName}" ];
    externalInterface = "venet0";
    # Your external IP here
    externalIP = "37.205.14.80";
    forwardPorts = [
      { destination = "192.168.122.105:80"; sourcePort = 80;}
      { destination = "192.168.122.105:443"; sourcePort = 443;}
      { destination = "192.168.122.105:22"; sourcePort = 6666;}
      { destination = "192.168.122.105:20"; sourcePort = 20;}
      { destination = "192.168.122.105:21"; sourcePort = 21;}
    ];
  };
  
  # libvirt uses 192.168.122.0
  networking.bridges."${bridgeName}".interfaces = [];
  networking.interfaces."${bridgeName}".ipv4.addresses = [
    { address = "192.168.122.1"; prefixLength = 24; }
  ];
  
  services.dhcpd4 = {
    enable = true;
    interfaces = [ "${bridgeName}" ];
    extraConfig = ''
      option routers 192.168.122.1;
      option broadcast-address 192.168.122.255;
      option subnet-mask 255.255.255.0;
  
      option domain-name-servers 37.205.9.100, 37.205.10.88, 1.1.1.1;
  
      #default-lease-time -1;
      #max-lease-time -1;
  
      subnet 192.168.122.0 netmask 255.255.255.0 {
        range 192.168.122.100 192.168.122.200;
      }
    '';
  };

  nixpkgs.overlays = [
    (self: super:
      {
        nixops = (import "${nixopsRepo}/release.nix" {}).build.x86_64-linux;
      }
    )
  ];

}
