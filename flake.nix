{
  description = "Nexus Sentinel - Hybrid Modular OS by ghgb1931-sketch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "aarch64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      name = "nexus-core-shell";

      # أضفنا fastfetch هنا كأداة أصلية خفيفة في النظام
      buildInputs = with pkgs; [
        git
        neovim
        wget
        htop
        python3
        python3Packages.pip
        gcc
        cargo
        rustc
        fastfetch 
      ];

      shellHook = ''
        echo "======================================================="
        echo "🚀 Welcome to Nexus Sentinel Hybrid OS Core"
        echo "👤 Developer: ghgb1931-sketch"
        echo "⚙️  Architecture: ${system} (Optimized for ARM/Mobile)"
        echo "🧠 Dynamic Resource Allocation: [TURBO MODE ACTIVE]"
        echo "======================================================="
        
        # تشغيل الأداة تلقائياً مع إقلاع النظام لعرض العظمة!
        fastfetch
      '';
    };
  };
}
