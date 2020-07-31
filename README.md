# zfsync - simple bash script for ZFS dataset snapshots and backup

## Current functionality:
- make periodic recursive snapshots of source dataset (sheduled via crontab)
- incremental replication/backup to a local zfs dataset

## Roadmap:
- automatic removal of snapshots and retention policy
- replicate to remote host

## Files
*zfsync.sh* is the script itself

*crontab* is an example of crontab setup for sceduling regular snapshots and backups

[test.md](test.md)
