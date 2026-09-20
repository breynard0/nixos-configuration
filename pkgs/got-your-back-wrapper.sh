#!/bin/sh

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/gyb"
mkdir -p "$config_dir"

exec @libexec@ --config-folder "$config_dir" "$@"
