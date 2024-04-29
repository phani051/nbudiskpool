
# Gets table output with Master, DP name and %full 
/usr/openv/netbackup/local/scripts/dpstatus >~/dpout

# Get's DP status from remote master and append to the dump file
ssh -o StrictHostKeyChecking=no olph437.bodc.att.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout

#Move header to different file
cat /home/pr0488/dpout | head -n 1 >~/dpstatus

#rest of the entries are sorted as per the DP %full
cat /home/pr0488/dpout | sed -n '1!p' | sort -n -r -k 3 >>~/dpstatus

#Below command will be dumping data to html file in required format
cat ~/dpstatus | {
  cat
  echo
} | /home/pr0488/tabulatev2.sh -d " " -t "NBU DP Status" -h "Disk Pool Status" >~/dpstatus.html

#End part of the html file which is responsible for coloring as per %full
echo '<script>
      $("td:nth-child(3)").each(function () {
        if (parseInt($(this).text()) >= 85) {
          $(this).addClass("add_red");
        } else if (parseInt($(this).text()) >= 75) {
          $(this).addClass("add_yellow");
        } else if (parseInt($(this).text()) >= 0) {
          $(this).addClass("add_green");
        }
      });
    </script></html>' >>~/dpstatus.html

#Wait for the above process to complete
sleep 30s

# Mail to the team
echo "Kindly refer the attachment for the Diskpool status(PureDiska and StoreOnce) from flpd633 and olph437 taken at $(date)" | mail -r "p.reddy8@dxc.com" -s "NBU Diskpool status" -a /home/pr0488/dpstatus.html -c a.komuravelli@dxc.com,srujana.kommu@dxc.com,p.reddy8@dxc.com swaroop.prakash@dxc.com
#echo "Kindly refer the attachment for the Diskpool status(PureDiska and StoreOnce) from flpd633 and olph437 taken at $(date)" | mail -r "p.reddy8@dxc.com" -s "NBU Diskpool status" -a /home/pr0488/dpstatus.html   p.reddy8@dxc.com
