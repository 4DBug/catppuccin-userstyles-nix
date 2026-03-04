{
  lib,
  stdenv,
  fetchFromGitHub,
  stylus-storage-gen,
  userstylesOptions ? { },
}:
let
  userstylesOptionsFile = builtins.toFile "catppuccin-userstyles-options" (
    builtins.toJSON userstylesOptions
  );
in
stdenv.mkDerivation {
  pname = "catppuccin-stylus-storage";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "4DBug";
    repo = "catppuccin-userstyles";
    rev = "f563162295c5272a010e39fe897332cb058ce482";
    hash = "sha256-lftRs+pfcOrqHDtDWX/Vd/CQvDJguCRxlhI/aIkIB/k=";
  };

  nativeBuildInputs = [
    stylus-storage-gen
  ];

  buildPhase = ''
    mkdir -p $out/share ./deno_cache
    DENO_DIR=$PWD/deno_cache stylus-storage-gen "$src/styles" "${userstylesOptionsFile}"
    cp storage.js $out/share/
  '';

  meta = {
    description = "Soothing pastel userstyles";
    homepage = "https://github.com/catppuccin/userstyles";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.all;
  };
}
