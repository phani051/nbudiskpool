/usr/openv/netbackup/local/scripts/dpstatus >~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no olph437.bodc.att.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no tlph101.dadc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no clph444.sldc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no clph657.sldc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no tlph102.dadc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no tsprd540.edc.cingular.net ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no clph587.sldc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no tsprd653.dadc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no csprd246.sldc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no csprd370.sldc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no fsprd448.ffdc.sbc.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no alph332.aldc.att.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
ssh -t -t -i ~/pr0488 -o StrictHostKeyChecking=no asprd559.aldc.att.com ""/usr/openv/netbackup/local/scripts/dpstatus"" >>~/dpout
sed -i 's/\(No disk volumes found!\)//' ~/dpout
sed -i '/^\s*$/d' ~/dpout

cat /home/pr0488/dpout | head -n 1 >~/dpstatus
cat /home/pr0488/dpout | sed -n '1!p' | sort -n -r -k 3 >>~/dpstatus
cat ~/dpstatus | {
  cat
  echo
} | /home/pr0488/tabulatev2.sh -d "," -t "NBU DP Status" -h "Disk Pool Status" >~/dpstatus.html

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

sleep 30s
echo "Kindly refer the attachment for the Diskpool status(PureDisk and StoreOnce) from NetBackup taken at $(date)" | mail -r "p.reddy8@dxc.com" -s "NBU Diskpool status" -a /home/pr0488/dpstatus.html -c p.reddy8@dxc.com,swaroop.prakash@dxc.com ATT_DXC_BUILD-EBR@dxc.com
#echo "Kindly refer the attachment for the Diskpool status(PureDiska and StoreOnce) from NetBackup taken at $(date)" | mail -r "p.reddy8@dxc.com" -s "NBU Diskpool status" -a /home/pr0488/dpstatus.html   p.reddy8@dxc.com
