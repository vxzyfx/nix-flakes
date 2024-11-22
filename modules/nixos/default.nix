{mylib, vars, ...}: {
  imports = vars.onlyLinuxOptionals (mylib.scanPaths ./.);
}
