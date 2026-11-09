{
  pkgs,
  lib,
  ...
}:

# Pi coding agent (npm: @earendil-works/pi-coding-agent), built with Nix.
#
# - The `pi` binary comes from buildNpmPackage with a committed lockfile
#   (home/pi-harness/package-lock.json), so Pi and its dependencies are pinned.
# - Pi "packages" (extensions, skills) are declared below and written to
#   ~/.pi/agent/settings.json on each switch. Pi installs them at startup into
#   the directory set by NPM_CONFIG_PREFIX (a writable location outside the Nix
#   store), so they still need network access on first run.
# - Extensions import @earendil-works/* (the Pi host API). NODE_PATH points them
#   at the modules shipped with this build, since the host is in the Nix store.
#
# To update Pi: bump `version`, the tarball `hash`, regenerate
# home/pi-harness/package-lock.json (npm install --package-lock-only
# --legacy-peer-deps), and rebuild to refresh `npmDepsHash`.
let
  version = "1.5.0";

  pi_harness = pkgs.buildNpmPackage {
    pname = "pi-coding-agent";
    inherit version;
    nodejs = pkgs.nodejs_22;

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
      hash = "sha512-xNDZ5kqowO6Z03FS2gwAkPEGk1ssxVcYKQ6qZId84mFEvwACvvyc2l0vAMOS+c5zvxLRMLBE9r4y44IGYkMJaQ==";
    };

    # The npm tarball ships without a lockfile; use the committed one.
    postPatch = ''
      cp ${./pi-harness/package-lock.json} package-lock.json
    '';

    npmFlags = [ "--legacy-peer-deps" ];
    npmDepsHash = "sha256-HdoYRZVvAVWdfRiwPnRaLwj4X+7bJraD+ZV/5atinuo=";
    dontNpmBuild = true;

    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/pi \
        --prefix PATH : ${
          lib.makeBinPath [
            pkgs.nodejs_22
            pkgs.git
          ]
        } \
        --prefix NODE_PATH : "$out/lib/node_modules" \
        --set PI_SKIP_VERSION_CHECK 1 \
        --run 'export NPM_CONFIG_PREFIX="''${NPM_CONFIG_PREFIX:-$HOME/.pi/agent/npm}"'
    '';

    meta = {
      description = "Minimal terminal coding agent (Pi)";
      homepage = "https://pi.dev";
      license = lib.licenses.mit;
      mainProgram = "pi";
    };
  };

  # Packages Pi loads at startup. Pinned versions are not changed by `pi update`.
  pi_packages = [
    "npm:pi-web-access@0.47.0" # web search, URL fetching, PDF/YouTube extraction
    "npm:@gotgenes/pi-permission-system@42.0.0" # permission gates for tool calls
    "npm:cc-safety-net@2.7.7" # blocks destructive shell commands and secret-file access
    "npm:pi-lens@4.4.10" # lint, type and format feedback after edits
    "npm:pi-subagents@0.87.0" # delegate work to sub-agents and scripted workflows
  ];
in
{
  home.packages = [ pi_harness ];

  # Merge only the keys this module owns into settings.json. Pi also writes
  # this file (`/settings`, `pi install`), so it stays a regular file.
  home.activation.piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="$HOME/.pi/agent/settings.json"
    mkdir -p "$(dirname "$settings")"
    [ -f "$settings" ] || echo '{}' > "$settings"
    tmp="$(mktemp)"
    ${pkgs.jq}/bin/jq --argjson packages '${builtins.toJSON pi_packages}' \
      '.packages = $packages' "$settings" > "$tmp" && mv "$tmp" "$settings"
  '';
}
