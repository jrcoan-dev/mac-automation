#!/bin/bash

### 1. Configuration

USER_NAME="jasonmini" # ← change to your macOS short username
MOUNT_POINT="/Volumes/jasonmini-xt/jasonmini/tmpfsMnt"
PLIST_FILE="/Library/LaunchDaemons/com.user.mounttmpfs.plist"
PLIST_LABEL="com.user.mounttmpfs"
TMPFS_SIZE="2G"

### 2. Create the mount point with correct permissions

if ! sudo mkdir -p "$MOUNT_POINT"; then
  echo "❌ Failed to create mount point directory."
  exit 1
fi

if ! sudo chown "$USER_NAME:staff" "$MOUNT_POINT"; then
  echo "❌ Failed to set ownership on mount point."
  exit 1
fi

### 3. Create the LaunchDaemon plist

sudo tee "$PLIST_FILE" > /dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>${PLIST_LABEL}</string>

    <key>ProgramArguments</key>
    <array>
      <string>/bin/sh</string>
      <string>-c</string>
      <string>
        /sbin/mount_tmpfs -s ${TMPFS_SIZE} ${MOUNT_POINT} && chown ${USER_NAME}:staff ${MOUNT_POINT}
      </string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>UserName</key>
    <string>root</string>

    <key>GroupName</key>
    <string>staff</string>
  </dict>
</plist>
EOF

### 4. Set proper permissions for the plist

if ! sudo chmod 644 "$PLIST_FILE"; then
  echo "❌ Failed to set permissions on plist."
  exit 1
fi

### 5. Unload any existing daemon (ignore errors if not loaded)

sudo launchctl bootout system "$PLIST_FILE" 2>/dev/null

### 6. Load the LaunchDaemon and check success

if sudo launchctl bootstrap system "$PLIST_FILE"; then
  echo "✅ tmpfs LaunchDaemon created and loaded."
  echo "Mounted tmpfs will appear at: $MOUNT_POINT"
else
  echo "❌ Failed to load LaunchDaemon. Check plist syntax or permissions."
  exit 1
fi
