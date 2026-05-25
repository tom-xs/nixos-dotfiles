{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    
    open = true;
    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

}