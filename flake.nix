{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        sqlite
        protobuf
      ];

      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.sqlite ];

      shellHook = ''
        export PATH="''${PUB_CACHE:-$HOME/.pub-cache}/bin:$PATH"
        if ! command -v protoc-gen-dart &>/dev/null; then
          echo "Installing protoc-gen-dart..."
          dart pub global activate protoc_plugin
        fi
      '';
    };
  };
}
