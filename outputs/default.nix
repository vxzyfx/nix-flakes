{
  self,
  nixpkgs,
  ...
}@inputs:
let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib; };
  myvars = import ../vars { inherit lib mylib; };
  genSpecialArgs =
    system: hostname:
    let
      isLinux = lib.strings.hasSuffix "linux" system;
      isDarwin = lib.strings.hasSuffix "darwin" system;
      onlyLinuxOptionalAttrs = attr: lib.optionalAttrs isLinux attr;
      onlyDarwinOptionalAttrs = attr: lib.optionalAttrs isDarwin attr;
      onlyLinuxOptionals = list: lib.optionals isLinux list;
      onlyDarwinOptionals = list: lib.optionals isDarwin list;
      vars = myvars.${hostname} or { } // {
        inherit
          isLinux
          isDarwin
          hostname
          onlyLinuxOptionalAttrs
          onlyDarwinOptionalAttrs
          onlyLinuxOptionals
          onlyDarwinOptionals
          ;
      };
    in
    inputs
    // {
      inherit mylib myvars vars;
    };
  args = {
    inherit
      inputs
      lib
      mylib
      myvars
      genSpecialArgs
      ;
  };
  nixos = lib.attrsets.filterAttrs (n: v: lib.strings.hasSuffix "linux" v.system) myvars;
  darwin = lib.attrsets.filterAttrs (n: v: lib.strings.hasSuffix "darwin" v.system) myvars;
  darwinConfigurations = lib.attrsets.mapAttrs (
    hostname: v:
    mylib.darwinSystem (
      args
      // {
        inherit hostname;
        system = v.system;
      }
    )
  ) darwin;
  nixosConfigurations = lib.attrsets.mapAttrs (
    hostname: v:
    mylib.nixosSystem (
      args
      // {
        inherit hostname;
        system = v.system;
      }
    )
  ) nixos;
  supportedSystems = lib.unique (lib.attrValues (lib.mapAttrs (name: value: value.system) myvars));
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  hookCheck = forAllSystems (system: {
    pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = ../.;
      hooks = {
        nixfmt-rfc-style.enable = true;
      };
    };
  });
  mergeCheck = set1: set2: lib.mergeAttrsWithFunc (s1: s2: s1 // s2) set1 set2;
in
{
  inherit nixosConfigurations darwinConfigurations;
  checks = mergeCheck hookCheck { };
  devShells = forAllSystems (system: {
    git-hook = nixpkgs.legacyPackages.${system}.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
    };
  });
}
