{ ... }:

{
  # Offer an Xorg desktop alongside GNOME in GDM's session chooser.
  # After first enabling Xorg, reboot or restart display-manager from a TTY.
  # GDM is not restarted by nixos-rebuild and otherwise retains its old Xorg
  # arguments and session search paths from before XFCE was installed.
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
}
