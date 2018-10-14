{ config, ... }:
{

  users.extraGroups = {
    web = { gid = 1001; };
  };


  users.extraUsers.xixo = {
    description = "xixo";
    isNormalUser = true;
    createHome = false;
    home = "/var/www/kriloter.com/sunworld";
#    group = "users";
#    extraGroups = [ "wheel" ];
    uid = 1001;
    hashedPassword = "$6$vXVPeVvalAxuf.n$aKNVA.zx1wWHFmYFZs1UeAlbsIKLfKxnDsVQ3NVVQpKEH.oLoKlgUuPkhN9xnlIsyTKSEJE2N0M0XDoSO41zA0";

  };
  users.extraUsers.jureq = {
    description = "jureq";
    isNormalUser = true;
    createHome = false;
    home = "/var/www/kriloter.com/jureq";
#    group = "users";
#    extraGroups = [ "wheel" ];
    uid = 1002;
    hashedPassword = "$6$U/GLdsniYC2rIn$ikQ.YEivtjRg0Krl4CXevjEl/c1qeigv.AMuy6Nf9bW8w3dqUalSswXTjL57QpfiCRZ3NTs8G2PTdOenEFbR./";
  };

  users.extraUsers.webmaster = {
    description = "webmaster";
    isNormalUser = true;
    createHome = false;
    home = "/var";
#    group = "users";
    extraGroups = [ "web" ];
    uid = 1003;
    hashedPassword = "$6$VWY759ar$eOjhhkiDlkZyOi6mDDSnA1g9twfqV.brDGwHqIGBSLrsQnt6BJ063Tc6l20RviHuwzhT5i.AtezyneL1c2PtW/";
  };



}
