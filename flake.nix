{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-kernelsu-builder.url = "github:cything/ksu-builder";
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
              kernelConfig = ''
                CONFIG_PID_NS=y
                CONFIG_IPC_NS=y
                CONFIG_CGROUP_DEVICE=y
                CONFIG_BRIDGE_NETFILTER=y
                CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
                CONFIG_NETFILTER_XT_MATCH_IPVS=y
                CONFIG_POSIX_MQUEUE=y
                CONFIG_VXLAN=y
                CONFIG_BRIDGE_VLAN_FILTERING=y
                CONFIG_IPVLAN=y
                CONFIG_MACVLAN=y
                CONFIG_BTRFS_FS_POSIX_ACL=y
              '';
            };
          };
        };
    };
}
