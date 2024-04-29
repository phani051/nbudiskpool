touch /home/pr0488/sts
rm -f /home/pr0488/sts


#sudo /usr/openv/netbackup/bin/admincmd/nbdevquery -liststs | awk '{print $3}' | sort | uniq > /home/pr0488/sts
#Get only PureDisk and StoreOnce
echo hp-StoreOnceCatalyst >/home/pr0488/sts
echo PureDisk >>/home/pr0488/sts
touch /home/pr0488/diskpool
rm -f /home/pr0488/diskpool

#Dump details of PureDisk and StoreOnce disk pools
while read p; do
  sudo /usr/openv/netbackup/bin/admincmd/nbdevquery -listdv -stype $p >>/home/pr0488/diskpool
done </home/pr0488/sts

# Create a awk array with Master name, DP name and %Full

awk -v hostname="$(hostname)" '
        {
            DISKPOOL=$2
			TOTALSPAC=$6
			AVAILPACE=$7
			USEDSPAC=($6-$7)*100
			DISK_LIST[DISKPOOL]+=USEDSPAC/TOTALSPAC
			MASTER_LIST[DISKPOOL]+=MASTER
        }
        END {
			printf ("%20s%40s%27s\n", "Master","DiskPool", "Full" )
       		for (DSK in DISK_LIST)
                        printf ("%20s%40s%27.2f\n", hostname ,DSK, DISK_LIST[DSK] )
       		
        }' </home/pr0488/diskpool
