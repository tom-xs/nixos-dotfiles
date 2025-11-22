{ config, lib, pkgs, ... }:
{

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  hardware.nvidia = {

    prime = {
      sync.enable = true;
    		intelBusId = "PCI:0:2:0";
    		nvidiaBusId = "PCI:1:0:0";
    };

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
