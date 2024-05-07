# shellcheck disable=SC1017
touch /home/pr0488/sts
rm -f /home/pr0488/sts
#sudo /usr/openv/netbackup/bin/admincmd/nbdevquery -liststs | awk '{print $3}' | sort | uniq > /home/pr0488/sts
echo hp-StoreOnceCatalyst >/home/pr0488/sts
echo PureDisk >>/home/pr0488/sts
touch /home/pr0488/diskpool
rm -f /home/pr0488/diskpool

while read p; do
  sudo /usr/openv/netbackup/bin/admincmd/nbdevquery -listdv -stype $p >>/home/pr0488/diskpool
done </home/pr0488/sts

awk -v hostname="$(hostname)" '
        {
            DISKPOOL=$2
                        TOTALSPAC=$6
                        AVAILPACE=$7
                        USEDSPAC=($6-$7)*100
                        USED=($6-$7)
                        DISK_LIST[DISKPOOL]+=USEDSPAC/TOTALSPAC
                        MASTER_LIST[DISKPOOL]+=MASTER
                                                TOTAL_SPACE[DISKPOOL] += (TOTALSPAC/1024)
                                                USED_SPACE[DISKPOOL] += (USED/1024)
                                                AVAIL_SPACE[DISKPOOL] += (AVAILPACE/1024)
        }
        END {
                printf ("%20s%40s%27s%20s%20s%20s\n", "Master,","DiskPool,", "%Full,", "Total Capacity(TB),", "Used Capacity(TB),", "Available Capacity(TB)" )
                for (DSK in DISK_LIST)
                        printf ("%20s%0s%40s%0s%27.2f%0s%20.2f%0s%20.2f%0s%20.2f\n", hostname,"," ,DSK, ",", DISK_LIST[DSK],",", TOTAL_SPACE[DSK],",", USED_SPACE[DSK],",", AVAIL_SPACE[DSK])
        }' </home/pr0488/diskpool
