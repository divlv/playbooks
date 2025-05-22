#!/bin/bash
#
# Azure VM added data disk setup script
# disk_setup.sh — detect data disk, partition/format if needed, mount at "/data", update /etc/fstab
#

# Exit immediately on error, treat unset variables as errors, and make pipelines fail if any element fails:
set -euo pipefail

echo "1) Determine the disk backing '/'..."
ROOT_PART=$(df --output=source / | tail -n1)
ROOT_DISK_NAME=$(lsblk -nr -o PKNAME "$ROOT_PART")
ROOT_DISK="/dev/${ROOT_DISK_NAME}"
echo "   '/' is on $ROOT_PART → root disk is $ROOT_DISK"

echo "2) Find the first available non-root disk (TYPE=='disk')..."
DATA_DISK=""
while read -r name type; do
  dev="/dev/${name}"
  [[ "$type" != "disk" ]] && continue
  [[ "$dev" == "$ROOT_DISK" ]] && continue
  DATA_DISK="$dev"
  break
done < <(lsblk -dn -o NAME,TYPE)

if [[ -z "$DATA_DISK" ]]; then
  echo "Error: no secondary disk found!" >&2
  exit 1
fi
echo "   Selected data disk: $DATA_DISK"

echo "3) Check for existing partitions on $DATA_DISK..."
# If any partition exists, skip partitioning; else create a new one.
if ! lsblk -nr -o NAME,TYPE "$DATA_DISK" | awk '$2=="part"{exit 0} END{exit 1}'; then
  echo "   No partitions found — creating GPT label and single ext4 partition..."
  parted -s "$DATA_DISK" mklabel gpt
  parted -s "$DATA_DISK" mkpart primary ext4 0% 100%
  sleep 1  # wait for kernel to register the new partition
  # Determine partition name (NVMe ends with digit, needs 'p1')
  if [[ "$DATA_DISK" =~ [0-9]$ ]]; then
    PART="${DATA_DISK}p1"
  else
    PART="${DATA_DISK}1"
  fi
  echo "   Formatting $PART as ext4..."
  mkfs.ext4 -F "$PART"
else
  # Find the first partition of the disk
  if [[ "$DATA_DISK" =~ [0-9]$ ]]; then
    PART="${DATA_DISK}p1"
  else
    PART="${DATA_DISK}1"
  fi
  echo "   Existing partition detected: $PART — skipping format."
fi

echo "4) Create mount point /data if not exists..."
mkdir -p /data

echo "5) Retrieve UUID of $PART and update /etc/fstab..."
UUID=$(blkid -s UUID -o value "$PART")
FSTAB_LINE="UUID=${UUID}   /data   ext4   defaults,nofail   0   2"

if ! grep -q "UUID=${UUID}" /etc/fstab; then
  echo "   Adding to /etc/fstab:"
  echo "     $FSTAB_LINE"
  echo "$FSTAB_LINE" >> /etc/fstab
else
  echo "   /etc/fstab already contains entry for $PART."
fi

echo "6) Mount all entries from /etc/fstab..."
mount -a

echo "Done! /data is now mounted:"
df -h /data
