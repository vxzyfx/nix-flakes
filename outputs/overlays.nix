final: prev: 
let
  callPackage = pname: prev.callPackage ./packages/${pname}.nix {}; 
in
{
  macism = callPackage "macism";
}
