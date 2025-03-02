{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-kernelsu-builder.url = "github:cything/ksu-builder";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://cything.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "cything.cachix.org-1:xqW1W5NNL+wrM9wfSELb0MLj/harD2ZyB4HbdaMyvPI="
    ];
    builders-use-substitutes = true;
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
            default = {
              arch = "arm64";
              anyKernelVariant = "kernelsu";
              clangVersion = "latest";

              # we already do this ourself
              kernelSU.enable = false;
              susfs.enable = false;

              kernelDefconfigs = [
                "gki_defconfig"
              ];
              kernelImageName = "Image";
              kernelSrc = ./.;
              oemBootImg = ./assets/oem-boot.img;
            };
          };
        };
    };
}
