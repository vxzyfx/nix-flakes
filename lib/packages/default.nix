{ lib, pkgs, ... }:
{
  im-select = pkgs.callPackage ./im-select.nix { };
}
