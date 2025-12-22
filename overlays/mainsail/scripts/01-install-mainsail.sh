#!/bin/bash
#
# Mainsail Installation Script
# Downloads and installs Mainsail web UI to the target rootfs
#

ROOT_DIR="$(realpath "$(dirname "$0")/../../..")"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <rootfs-dir>"
  exit 1
fi

set -eo pipefail

TARGET_DIR="$ROOT_DIR/tmp"

VERSION=v2.16.1
URL=https://github.com/mainsail-crew/mainsail/releases/download/$VERSION/mainsail.zip
SHA256=542615d979fe2e49ce10499e58692d6b6a597a541f2632797780c4ed2a089a22
FILENAME=mainsail-$VERSION.zip

if [[ ! -f "$TARGET_DIR/$FILENAME" ]]; then
  echo ">> Downloading $FILENAME..."
  wget -O "$TARGET_DIR/$FILENAME" "$URL"
fi

echo ">> Verifying $FILENAME checksum..."
echo "$SHA256  $TARGET_DIR/$FILENAME" | sha256sum --check --status

echo ">> Extracting $FILENAME..."
rm -rf "$TARGET_DIR/mainsail-$VERSION"
unzip -o "$TARGET_DIR/$FILENAME" -d "$TARGET_DIR/mainsail-$VERSION"

echo ">> Installing $FILENAME to target rootfs..."
rm -rf "$1/home/lava/mainsail"
cp -r "$TARGET_DIR/mainsail-$VERSION" "$1/home/lava/mainsail"

echo ">> Setting ownership..."
chown -R 1000:1000 "$1/home/lava/mainsail"

echo ">> Mainsail $VERSION installed successfully."
