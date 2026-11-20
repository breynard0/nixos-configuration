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

    # Every pick snapshots the whole stage into a GPU texture. Upstream leaves
    # freeing it to the garbage collector, which let gnome-shell reach 28 GiB.
    (_final: prev: {
      gnomeExtensions = prev.gnomeExtensions // {
        color-picker = prev.gnomeExtensions.color-picker.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ../pkgs/color-picker-release-snapshot.patch ];
        });
      };
    })
  ];
}
