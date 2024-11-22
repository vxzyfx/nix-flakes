{mylib, systemModules, ...}: {
  imports = mylib.scanPaths ./.;
}
