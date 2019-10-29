
#!/bin/bash
# This script will make snapshot ZFS dataset (SOURCE) 
# and send in incrementally to backup ZFS dataset
# EXAMPLE RUN: $./zfsync tank/source backup/destination
SRC=$1
DST=$2

# CREATE NEW SNAPSHOT OF SOURCE FILESYSTEM
CURRENT_TIME=$(date +%Y-%m-%d-%H%M%S)
echo "MAKING SNAPSHOT:"
echo "zfs snapshot -r "$SRC@$CURRENT_TIME
zfs snapshot -r $SRC@$CURRENT_TIME
echo ""

# DETERMINE LATES SNAPSHOT AVAILABLE AT SOURCE AND DESTINATION
DST_LATEST=$(zfs list -t snapshot -o name $DST | tail -n 1)
SRC_LATEST=$(zfs list -t snapshot -o name $SRC | tail -n 1)
DST_LATEST_DATE=${DST_LATEST#*"@"}

# SEND INCREMENTAL SNAPSHOT TO BACKUP POOL
SNAP1=$SRC$"@"${DST_LATEST#*"@"}
SNAP2=$SRC_LATEST
echo "SENDING INCREMENTL SNAPSHOT:"
echo "zfs send -R -i "$SNAP1" " $SNAP2" | pv | zfs receive -F "$DST
zfs send -R -i $SNAP1  $SNAP2 | pv | zfs receive -F $DST



