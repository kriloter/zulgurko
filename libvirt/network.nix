{
  network.description = "netX";

  postgres1 =
    { config, lib, pkgs, ...}:
    {
      imports = [
        
      ];

      nix.gc.automatic = true;
      nix.gc.dates = "03:15";

      
      # XXX: create a module from this
      boot.kernel.sysctl."kernel.shmmax" = 520581120;
      boot.kernel.sysctl."kernel.shmall" = 254190;

      networking.firewall.enable = true;
      networking.firewall.allowedTCPPorts = [ 5432 ];


            services.postgresql = {
              enable = true;
            # shared_buffers to 25% of the memory in your system.
              extraConfig = ''
               #listen_addresses = '0.0.0.0'
                shared_buffers = 256MB
                temp_buffers = 16MB
                work_mem = 8MB
                max_connections = 25
                max_stack_depth = 2MB
                effective_cache_size = 512MB
                wal_buffers = 8MB
              '';
              package = pkgs.postgresql96;
            };
          };
 
 web1 = 
    { config, lib, pkgs, ...}: let
      helloyes = import /home/kriloter/haskell/helloyes/default.nix { inherit pkgs; };
    in 
    {
      imports = [
        ./webusers.nix        
      ];

      environment.systemPackages = with pkgs; [
      vim
      lftp
      screen
      wget
#      zlib
#      haskellPackages.zlib
      helloyes
      ];
      
      nix.gc.automatic = true;
      nix.gc.dates = "03:15";


      networking.firewall.enable = false;
      networking.firewall.allowedTCPPorts = [ 80 443 20 21 ];
      networking.firewall.connectionTrackingModules = [ "ftp" ];
      networking.firewall.autoLoadConntrackHelpers = true;


/*
      security.acme.certs."bazar.kriloter.com" = {
        webroot = "/var/www/kriloter.com/bazar";
        email = "kriloter@kriloter.com";
      };
*/


      services.nginx = {
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        appendHttpConfig = "server_names_hash_bucket_size 64;";
        enable = true;


        virtualHosts  = {

          "webmail.zulgur.com" = {
             globalRedirect = "webmail.ybaca.net";
          };
           "webmail.kriloter.com" = {
             globalRedirect = "webmail.ybaca.net";
          };

          "zulgur.com" = {
             serverAliases = [ "www.zulgur.com" ];
             forceSSL = true;
             enableACME = true;
             root = "/var/www/zulgur.com/main";
             locations."~ \.php$".extraConfig = ''
               fastcgi_pass 127.0.0.1:9000;
               fastcgi_index index.php;
             '';
          };


          "nixos.zulgur.com" = {
             default = true;
             forceSSL = true;
             enableACME = true;
             locations."/" = {
               proxyPass = "http://127.0.0.1:3000";
             };
          };

          "kriloter.com" = {
             serverAliases = [ "www.kriloter.com" ];
             forceSSL = true;
             enableACME = true;
             root = "/var/www/kriloter.com/main";
             locations."~ \.php$".extraConfig = ''
               fastcgi_pass 127.0.0.1:9000;
               fastcgi_index index.php;
             '';
          };	

          "skladka.kriloter.com" = {
             forceSSL = true;
             enableACME = true;
             root = "/var/www/kriloter.com/skladka";
             locations."/".index = "index.php";
             locations."~ \.php$".extraConfig = ''
               fastcgi_pass 127.0.0.1:9000;
               fastcgi_index index.php;
             '';
          };

          "wiki.zulgur.com" = {
             forceSSL = true;
             enableACME = true;
             root = "/var/www/zulgur.com/wiki";
             locations."/".index = "doku.php";
             locations."~ /(data/|conf/|bin/|inc/|install.php)".extraConfig = ''
               deny all;
             '';
             locations."/".extraConfig = ''
               try_files $uri $uri/ @wiki;
             '';
             locations."@wiki".extraConfig = ''
               # rewrites "doku.php/" out of the URLs if you set the userewrite setting to .htaccess in dokuwiki config page
               rewrite ^/_media/(.*) /lib/exe/fetch.php?media=$1 last;
               rewrite ^/_detail/(.*) /lib/exe/detail.php?media=$1 last;
               rewrite ^/_export/([^/]+)/(.*) /doku.php?do=export_$1&id=$2 last;
               rewrite ^/(.*) /doku.php?id=$1&$args last;
             '';
             locations."~ \.php$".extraConfig = ''
               fastcgi_pass 127.0.0.1:9000;
               fastcgi_index doku.php;
#               include fastcgi_params;
#               fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
#               fastcgi_param REDIRECT_STATUS 200;
#               fastcgi_pass unix:/var/run/php-fpm.sock;
             '';
          };


          "sunworld.kriloter.com" = {
             forceSSL = true;
             enableACME = true;
             root = "/var/www/kriloter.com/sunworld";
             locations."~ \.php$".extraConfig = ''
               fastcgi_pass 127.0.0.1:9000;
               fastcgi_index index.php;
             '';
          };

        };
      };

      security.acme.certs = {
        "kriloter.com".email = "kriloter@kriloter.com";
        "skladka.kriloter.com".email = "kriloter@kriloter.com";
        "zulgur.com".email = "kriloter@kriloter.com";
        "nixos.zulgur.com".email = "kriloter@kriloter.com";
#        "wiki.zulgur.com".email = "kriloter@kriloter.com";
        "sunworld.kriloter.com".email = "kriloter@kriloter.com";
      };

      systemd.services.helloyes =
        { description = "helloyes Webserver";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig =
            { ExecStart = "${helloyes}/bin/helloyes";
            };
         };

      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
      };
/*
      services.vsftpd = {
        enable = true;
        localUsers = true;
        chrootlocalUser = true;
        writeEnable = true;
        extraConfig = "allow_writeable_chroot=YES";
      };
*/

      services.phpfpm.poolConfigs.mypool = ''
      listen = 127.0.0.1:9000
      user = nginx
      group = nginx
      pm = dynamic
      pm.max_children = 5
      pm.start_servers = 2 
      pm.min_spare_servers = 1 
      pm.max_spare_servers = 3
      pm.max_requests = 500
      '';
    };

}
