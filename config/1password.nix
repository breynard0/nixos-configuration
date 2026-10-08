{ ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "breynard" ];
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      helium
    '';
    mode = "0755";
  };
}
