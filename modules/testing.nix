{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jmeter
    k6
    hey
    vegeta
    wrk
  ];
}
