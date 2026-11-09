# Node.js toolchain used by the Pi harness. Bump the version here only;
# home/shell.nix and hosts reference this relative directory.
let
  version = "node-v22.23.2-linux-x64";
in
{
  inherit version;
  relBinDir = ".local/share/pi-node/${version}/bin";
}
