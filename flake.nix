{
  description = "MindWM Client";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    godot.url = "github:mindwm/godot4-nix";
    gdextension_xorg.url = "github:mindwm/gdextension-xorg";
    gdextension_dbus.url = "github:mindwm/gdextension-dbus";
  };

  outputs = inputs@{ flake-parts, gdextension_xorg, gdextension_dbus, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devshell.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          gdexts = pkgs.lib.attrsets.concatMapAttrs (name: value:
            {
              ${name} = value.packages.${system};
            }) (pkgs.lib.attrsets.filterAttrs (n: v: pkgs.lib.strings.hasPrefix "gdextension_" n) inputs);
        in {
          packages = rec {
            release = pkgs.callPackage ./package.nix { inherit gdexts; withTarget = "template_release"; };
            debug = pkgs.callPackage ./package.nix { inherit gdexts; withTarget = "template_debug"; };
            godot = inputs.godot.packages.${system}.default;
            default = release;
          };
        
          devshells.default = {
            env = [
              { name = "HTTP_PORT"; value = "8080"; }
            ];
            commands = [
            { help = "update gdextensions";
              name = "update";
              command = "mkdir -p ./addons && cp -fasv ${config.packages.debug}/addons/* ./addons/";
            }
            { help = "start Godot editor";
              name = "godot";
              command = "${config.packages.godot}/bin/godot4 -e $PWD/project.godot";
            }
            ];
            packages = [
              config.packages.debug
              config.packages.godot
            ];
          };
        };
      flake = {
      };
    };
}
