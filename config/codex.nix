{ inputs, pkgs, ... }:

let
  codex = inputs.codex.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [
    (codex.overrideAttrs (old: {
      cargoDeps = pkgs.rustPlatform.importCargoLock {
        lockFile = "${old.src}/Cargo.lock";
        outputHashes = {
          "appcontainer_common-0.8.0" = "sha256-XUkT2R+RYk9WIqgKnmIAagNW4xOTyp4bWHmQL1iznHw=";
          "crossterm-0.29.0" = "sha256-ewiWWQPEU1lSUHzmZTiO5yes5luIaQ9TrvCNnTWhxpE=";
          "h3-0.0.8" = "sha256-fgE0AMj5d4iattTC/yQwnACV8uEu+KR7wD29xfEm8M0=";
          "nucleo-0.5.0" = "sha256-Hm4SxtTSBrcWpXrtSqeO0TACbUxq3gizg1zD/6Yw/sI=";
          "nucleo-matcher-0.3.1" = "sha256-Hm4SxtTSBrcWpXrtSqeO0TACbUxq3gizg1zD/6Yw/sI=";
          "runfiles-0.1.0" = "sha256-uJpVLcQh8wWZA3GPv9D8Nt43EOirajfDJ7eq/FB+tek=";
          "tokio-tungstenite-0.28.0" = "sha256-hJAkvWxDjB9A9GqansahWhTmj/ekcelslLUTtwqI7lw=";
          "tungstenite-0.27.0" = "sha256-AN5wql2X2yJnQ7lnDxpljNw0Jua40GtmT+w3wjER010=";
        };
      };
    }))
  ];
}
