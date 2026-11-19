{ ... }:
{
  # Compressed cache in front of /swapfile; cold pages are written back to
  # disk instead of filling the pool.
  boot.zswap.enable = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 67108864;
    "kernel.split_lock_mitigate" = 0;
  };

  boot.kernel.sysfs.kernel.mm = {
    transparent_hugepage.defrag = "defer";
    lru_gen.min_ttl_ms = 1000;
  };

  boot.kernelParams = [ "preempt=full" ];

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [ "--autopower" ];
  };

  systemd.oomd.enableUserSlices = true;

  environment.etc."xdg/systemd/user/org.gnome.Shell@.service.d/no-swap.conf".text = ''
    [Service]
    MemorySwapMax=0
  '';

  # "none" ignores I/O priorities, so idle-class jobs would not yield.
  hardware.block.scheduler."nvme[0-9]*n[0-9]*" = "mq-deadline";

  nix.settings = {
    max-jobs = 4;
    cores = 4;
    download-buffer-size = 536870912;
  };
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  systemd.services.nix-daemon.serviceConfig.MemoryHigh = "12G";

  services.journald.extraConfig = ''
    SystemMaxUse=1G
  '';
  systemd.coredump.settings.Coredump.MaxUse = "500M";
}
