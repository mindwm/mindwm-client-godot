{ lib
, pkgs
, stdenv
, scons
, xorg
, withPlatform ? "linux"
, gdexts
, withTarget ? "template_release"
}:

stdenv.mkDerivation {
  name = "mindwm-client-godot";
  src = ./.;

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  outputs = [ "out" ];

  configurePhase = ''
  '';

  installPhase = lib.attrsets.foldlAttrs (acc: n: v: 
    ''
    ${acc}
    ext_name="${lib.removePrefix "gdextension_" n}"
    install -m 644 -D ${v.release}/*.gdextension -t $out/addons/$ext_name/
    install -D ${v.release}/bin/*.so -t $out/addons/$ext_name/bin/
    install -D ${v.debug}/bin/*.so -t $out/addons/$ext_name/bin/
    '') "" gdexts;

  meta = with lib; {
    homepage = "https://github.com/mindwm/mindwm-client-godot";
    description = "A MindWM client application";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ omgbebebe ];
  };
}
