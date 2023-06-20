{
  description = "development flake for activate-linux-wl";

  inputs = {
    nixpkgs.url = "github:nixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      devShells."x86_64-linux".default = pkgs.mkShell rec {
        packages = with pkgs; [
          gnumake
          clang
          man-pages
        ];

        buildInputs = with pkgs; [
          wayland
          wayland-protocols
        ];
      };
    };
}
