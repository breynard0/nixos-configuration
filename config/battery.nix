{ ... }:

{
  services.upower.enable = true;

  # thermald is deliberately absent: it refuses to start on this ThinkPad
  # ("dytc_lapmode present: Thermald can't run on this platform") because
  # Lenovo's DYTC firmware owns thermal management. It exited at every boot.

  services.tlp = {
    enable = true;
    settings = {
      # intel_pstate in active mode offers only performance/powersave.
      # The previous value here was "schedutil", which the kernel rejects --
      # leaving the AC governor silently stuck on the battery setting.
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

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
