{
  description = "Nexus Sentinel - Hybrid Modular OS by ghgb1931-sketch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "aarch64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    
    # 🧠 مكعب الـ Alpha Frame: بيئة بايثون معزولة ومجهزة
    alphaPython = pkgs.python3.withPackages (ps: with ps; [
      numpy
      scipy
      sympy
      networkx
      requests
      aiohttp
    ]);
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      name = "nexus-core-shell";

      buildInputs = with pkgs; [
        git
        neovim
        wget
        htop
        gcc
        cargo
        rustc
        fastfetch
        alphaPython # حقن مكعب الذكاء الاصطناعي هنا
      ];

      shellHook = ''
        echo "======================================================="
        echo "🚀 Welcome to Nexus Sentinel Hybrid OS Core"
        echo "👤 Developer: ghgb1931-sketch"
        echo "🧠 Active Cube: [ALPHA FRAME - AI & MATH INITIALIZED]"
        echo "======================================================="
      '';
    };
  };
}
