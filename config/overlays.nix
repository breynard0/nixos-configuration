{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.claude-code.overlays.default

    # msitools 0.106 builds, but its Bats suite fails on this nixpkgs revision.
    # LTspice needs msiextract from the resulting package.
    (_final: prev: {
      msitools = prev.msitools.overrideAttrs (_old: {
        doCheck = false;
      });
    })
  ];
}
