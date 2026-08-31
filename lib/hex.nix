{ lib }:

# Small pure-Nix helper to convert #RRGGBB hex colors (as used by the
# Everforest palettes) into the comma-separated "R,G,B" format that
# Konsole colorscheme files expect. Kept allocation-free so it can run
# at evaluation time without importing extra packages.
let
  hexDigit = c: {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
  }.${c} or (throw "Invalid hex digit: ${c}");

  byte = s: hexDigit (builtins.substring 0 1 s) * 16 + hexDigit (builtins.substring 1 1 s);

  hexToRgb =
    hex:
    let
      h = lib.removePrefix "#" hex;
      r = byte (builtins.substring 0 2 h);
      g = byte (builtins.substring 2 2 h);
      b = byte (builtins.substring 4 2 h);
    in
    "${toString r},${toString g},${toString b}";
in
{
  inherit hexToRgb;
}
