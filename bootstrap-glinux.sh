#!/usr/bin/env bash
#
# Install gLinux specific packages and configuration.
#

# Required for using Bazel build servers
sudo apt install google-cloud-cli

# Configure mouse
cat <<EOF > /etc/udev/hwdb.d/70-evoluent-verticalmouse4.hwdb
# Evoluent 4 Mouse Button Mappings
# b0003v1A7Cp019* should work to capture both Left and Right mice. Left: b0003v1A7Cp0192 & Right: b0003v1A7Cp0191
evdev:input:b0003v1A7Cp019*
ID_INPUT_KEY=1
KEYBOARD_KEY_90001=btn_left     # left click
KEYBOARD_KEY_90002=btn_right    # right click
KEYBOARD_KEY_90003=btn_middle   # middle click
KEYBOARD_KEY_90004=btn_forward  # top thumb button
KEYBOARD_KEY_90005=btn_middle   # scroll click
KEYBOARD_KEY_90006=btn_back     # bottom thumb button
EOF

# Install stow packages
stow -v -t ${HOME} input-remapper
