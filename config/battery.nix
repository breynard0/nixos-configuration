{ ... }:

{
  services.upower.enable = true;

  # thermald is deliberately absent: it refuses to start on this ThinkPad
  # ("dytc_lapmode present: Thermald can't run on this platform") because
  # Lenovo's DYTC firmware owns thermal management. It exited at every boot.

  # Charge thresholds are left to UPower so GNOME Settings' "Preserve Battery
  # Health" switch owns them; this only makes the switch start out on.
  systemd.tmpfiles.rules = [
    "f /var/lib/upower/charging-threshold-status 0644 root root - 1"
  ];

  services.tlp = {
    enable = true;
    # Power-profile switcher in Quick Settings.
    pd.enable = true;
    settings = {
      # intel_pstate in active mode offers only performance/powersave, and
      # "performance" pins the energy preference at maximum on every core.
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_SAV = 0;

      CPU_BOOST_ON_SAV = 0;
      CPU_MAX_PERF_ON_SAV = 60;

      RUNTIME_PM_ON_AC = "auto";

      # The firmware profile sets PL1/PL2 and fan behaviour, and outweighs the
      # governor. Measured: sustained all-core load peaks at 71C against a 100C
      # limit with zero throttle events, so "performance" on AC is not a
      # thermal risk on this chassis.
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
    };
  };
}
