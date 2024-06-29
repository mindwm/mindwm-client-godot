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
    gdextension_dbus_nodes.url = "github:omgbebebe/gdextension-dbus-nodes";
    gdextension_dbus_nodes.inputs.nixpkgs.follows = "nixpkgs";
    gdextension_dbus_nodes.inputs.godot-cpp.follows = "godot-cpp";
    gdextension_unixsock.url = "github:omgbebebe/gdextension-unix-socket";
    gdextension_unixsock.inputs.nixpkgs.follows = "nixpkgs";
    gdextension_unixsock.inputs.godot-cpp.follows = "godot-cpp";
  };

  outputs = inputs@{ flake-parts, ... }:
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
            godot_editor = inputs.godot.packages.${system}.editor;
            godot_template_debug = inputs.godot.packages.${system}.template_debug;
            godot_template_release = inputs.godot.packages.${system}.template_release;
            default = release;
          };
        
          devshells.default = {
            env = [
              { name = "HTTP_PORT"; value = "8080"; }
            ];
            commands = [
            { help = "update all";
              name = "update";
              command = "update-gdexts && update-templates";
            }
            { help = "update gdextensions";
              name = "update-gdexts";
              command = ''
                mkdir -p ./addons \
                && cp -fasv ${config.packages.debug}/addons/* ./addons/ \
                && chmod -R u+w ./addons
              '';
            }
            { help = "update templates";
              name = "update-templates";
              command = ''
                mkdir -p ./templates \
                && cp -fasv ${config.packages.godot_template_debug}/bin/* ./templates/ \
                && chmod -R u+w ./templates
                cp -fasv ${config.packages.godot_template_release}/bin/* ./templates/ \
                && chmod -R u+w ./templates
              '';
            }
            { help = "start Godot editor";
              name = "godot";
              command = "${config.packages.godot_editor}/bin/godot.linuxbsd.editor.x86_64 -e $PWD/project.godot";
            }
            ];
            packages = [
              config.packages.debug
              (pkgs.python3.withPackages (ps: [ps.networkx]))
            ];
          };
        };
      flake = {
      };
    };
}
