{ ... }:

{
  imports = [ ./emacs.nix ];
  home.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;
}
