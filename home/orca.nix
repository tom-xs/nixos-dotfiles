{ pkgs, ... }:

# Orca IDE (https://orca.dev) packaged from a local AppImage.
# The vendor URL is not recorded here, so the file is supplied through the
# Nix store instead. Add it once per machine before building:
#
#   nix-store --add-fixed sha256 ~/Downloads/orca-linux.AppImage
#
# To update Orca, download the new AppImage, change `version` and `hash`
# below, then repeat the command above with the new file.
let
  orca-ide = pkgs.appimageTools.wrapType2 {
    pname = "orca-ide";
    version = "1.4.254";
    src = pkgs.requireFile {
      name = "orca-linux.AppImage";
      hash = "sha256-PH9bBqFSurfe+keW9H8zCuJFl0Mt1/AqyqBSSH2A8RY=";
      message = ''
        Orca AppImage not found in the Nix store. Run:
          nix-store --add-fixed sha256 ~/Downloads/orca-linux.AppImage
      '';
    };
  };
in
{
  home.packages = [ orca-ide ];
}
