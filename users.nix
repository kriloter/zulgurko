{ config, ... }:
{

  users.extraUsers.kriloter = {
    description = "kriloter";
    isNormalUser = true;
    createHome = true;
    #home = "/home/kriloter";
    #group = "users";
    extraGroups = [ "wheel" ];
    uid = 1001;
    #hashedPassword = "";
  };


}
