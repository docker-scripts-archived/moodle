#!/bin/bash -x
### mount /tmp on RAM for better performance

sed -i /etc/fstab \
    -e '/appended by installation scripts/,$ d'

cat <<_EOF >> /etc/fstab
##### appended by installation scripts
tmpfs	 /dev/shm                 tmpfs    defaults,noexec,nosuid               0    0
devpts	 /dev/pts                 devpts   rw,noexec,nosuid,gid=5,mode=620      0    0
tmpfs    /host/data/cache         tmpfs    defaults,noatime,mode=1777,nosuid    0    0
tmpfs    /host/data/localcache    tmpfs    defaults,noatime,mode=1777,nosuid    0    0
_EOF

mount -a
