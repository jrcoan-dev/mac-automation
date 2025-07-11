#!/bin/bash

### 1. Configuration

USER_NAME="jasonmini" # ← change to your macOS short username
MOUNT_POINT="/Users/$USER_NAME/tmpfsMnt"
PLIST_FILE="/Library/LaunchDaemons/com.user.mounttmpfs.plist"

### 2. Unload the LaunchDaemon

echo "🔧 Unloading LaunchDaemon (if loaded)..."
if sudo launchctl bootout system "$PLIST_FILE"; then
  echo "✅ LaunchDaemon unloaded."
else
  echo "ℹ️ LaunchDaemon not loaded or already unloaded."
fi

### 3. Delete the plist file

if sudo rm -f "$PLIST_FILE"; then
  echo "✅ LaunchDaemon plist removed."
else
  echo "❌ Failed to remove plist. Check permissions."
  exit 1
fi

### 4. Unmount the tmpfs if mounted

if mount | grep -q "$MOUNT_POINT"; then
  echo "🔧 Unmounting tmpfs..."
  if sudo umount "$MOUNT_POINT"; then
    echo "✅ tmpfs unmounted."
  else
    echo "❌ Failed to unmount tmpfs. Check usage or permissions."
    exit 1
  fi
else
  echo "ℹ️ tmpfs not mounted."
fi

### 5. Remove the mount point directory

if sudo rmdir "$MOUNT_POINT"; then
  echo "✅ Mount point directory removed."
else
  echo "ℹ️ Mount point directory does not exist or is not empty."
fi

echo "🎉 Cleanup complete."
