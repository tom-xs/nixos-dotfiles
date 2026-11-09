{ pkgs, ... }:

# Orca IDE (https://github.com/stablyai/orca) packaged from its GitHub release.
# To update: change `version` and `hash` below. Get the hash with:
#   nix store prefetch-file --hash-type sha256 <url>
let
  version = "1.4.254";
  orca-ide = pkgs.appimageTools.wrapType2 {
    pname = "orca-ide";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
      hash = "sha256-PH9bBqFSurfe+keW9H8zCuJFl0Mt1/AqyqBSSH2A8RY=";
    };
  };
in
{
  home.packages = [ orca-ide ];
}
