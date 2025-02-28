{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-kernelsu-builder.url = "github:xddxdd/nix-kernelsu-builder";
  };
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nix-kernelsu-builder.flakeModules.default
      ];
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        {
          kernelsu = {
            # Add your own kernel definition here
            my-kernel = {
              arch = "arm64";
              anyKernelVariant = "kernelsu";
              clangVersion = "latest";

              kernelSU.enable = false;
              susfs.enable = false;

              kernelDefconfigs = [
                "gki_defconfig"
              ];
              kernelImageName = "Image";
              kernelSrc = ./.;
            };
          };
        };
    };
}
