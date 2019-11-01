# zfsync
Bash script for ZFS datases sync and snapshots

##Current functionality:
- make periodic snapshots of source dataset (sheduled via crontab)
- replicate to a local zfs dataset

## Roadmap:
- automatic removal of snapshots and retention policy
- backup to remote host

## Files
*zfsync.sh* is the script itself
*crontab* is an example of crontab setup for sceduling regular snapshots and backups
