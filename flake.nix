{
  description = "MindWM Client";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    godot.url = "github:mindwm/godot4-nix";
    godot.inputs.nixpkgs.follows = "nixpkgs";
    godot-cpp.url = "github:omgbebebe/godot-cpp";
    gdextension_xorg.url = "github:mindwm/gdextension-xorg";
    gdextension_xorg.inputs.nixpkgs.follows = "nixpkgs";
    gdextension_xorg.inputs.godot-cpp.follows = "godot-cpp";
    gdextension_dbus.url = "github:mindwm/gdextension-dbus";
    gdextension_dbus.inputs.nixpkgs.follows = "nixpkgs";
    gdextension_dbus.inputs.godot-cpp.follows = "godot-cpp";
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
