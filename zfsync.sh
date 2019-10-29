
#!/bin/bash
# This script will make snapshot ZFS dataset (SOURCE) 
# and send in incrementally to backup ZFS dataset
# EXAMPLE RUN: $./zfsync tank/source backup/destination
SRC=$1
DST=$2

# CREATE NEW SNAPSHOT OF SOURCE FILESYSTEM
CURRENT_TIME=$(date +%Y-%m-%d-%H%M)
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



###### NOTES ######
# Delete snapshots recursively
# zfs list -t snapshot -o name -S creation | grep ^tank@Auto | tail -n +16 | xargs -n 1 zfs destroy -vr
# https://serverfault.com/questions/340837/how-to-delete-all-but-last-n-zfs-snapshots
# 
# Even better - destoroy a range of snapshots
# zfs destroy tank@snap1%snap200 # snap1 is older than snap200 
# zfs destroy tank@2019-10-28-120800%2019-10-29-184402

