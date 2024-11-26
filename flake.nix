{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      packageJson = builtins.fromJSON (builtins.readFile ./package.json);
    in
    {
      packages.${system}.default = pkgs.buildNpmPackage {
        name = packageJson.name;
        version = packageJson.version;
        src = pkgs.lib.cleanSource ./.;
        buildInputs = [ pkgs.nodejs ];
        npmDepsHash = "sha256-eyqBeOcbb1S9vqGTVtB1bymZRbfkM2zuG4xXkTGNF7M=";

        installPhase = ''
          mkdir -p $out/bin

          cp -r node_modules $out/
          cp package*.json $out/
          cp index.js $out/

          echo "#!${pkgs.nodejs}/bin/node $out/index.js" > $out/bin/${packageJson.name}
          chmod +x $out/bin/${packageJson.name}
        '';
      };
    };
}

