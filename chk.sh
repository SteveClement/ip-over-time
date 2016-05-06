#!/usr/bin/env bash

links -dump http://localhost.lu/rem.php > /dev/null

if [ $? = 0 ]
 then
  echo "Internet Detected :=)"
  links -dump http://localhost.lu/rem.php |head -1 |tr -d \ > now.ip
  echo >> now.ip
 else
  echo "No Internetz"
  exit 1
fi

touch ip.hist current.ip

os_used=`uname`

#if [ ${os_used} == 'Darwin' ] || [ ${os_used} == 'FreeBSD' ]; then
#        hr_time_cmd="date -r"
#else
#        hr_time_cmd="date -d @"
#fi

epoch_time=`date +%s`

last_change=$(date -d @`tail -1 ip.hist |cut -f 2 -d\ ` +"%Y-%m-%d %H:%M:%S")
diff -u current.ip now.ip > /dev/null
if [ $? == 0 ]; then
        echo "IP Address has not changed since: ${last_change}"
else
        echo "Updated IP Address detected"
        current_ip=`cat now.ip`
        last_ip=`tail -1 ip.hist |cut -f1 -d\ `
        echo $current_ip $epoch_time >> ip.hist
        cat now.ip > current.ip
        now_change=$(date -d @`tail -1 ip.hist |cut -f 2 -d\ ` +"%Y-%m-%d %H:%M:%S")
        #echo "Office IP Change from ${last_ip} to: ${current_ip} at ${now_change}" | mail -s "homeMer IP change" -aFrom:no-reply@localhost.lu spam@localhost.lu
        echo "Office IP Change from ${last_ip} to: ${current_ip} at ${now_change}" | mail -s "homeMer IP change" localuser
fi
