#!/bin/bash
_ARCH=$(uname -m)
if [ $_ARCH = "aarch64" ]; then
wget -O /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64'
else
wget -O /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
fi
dpkg -i /tmp/vscode.deb
rm -f /tmp/vscode.deb
