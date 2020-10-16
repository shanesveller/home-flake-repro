{ ... }:

{
  imports = [ ./emacs.nix ];
  nixpkgs.config.allowUnfree = true;
}
