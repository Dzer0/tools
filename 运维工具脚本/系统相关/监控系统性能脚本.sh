echo $$ > /var/run/show_status.log
sleep 600  && kill -9 `cat /var/run/show_status.log` &
while true;
do
sleep 2
cpu_us=`vmstat | awk '{print $13}' | sed -n '$p'`
cpu_sy=`vmstat | awk '{print $14}' | sed -n '$p'`
cpu_id=`vmstat | awk '{print $15}' | sed -n '$p'`
cpu_wa=`vmstat | awk '{print $16}' | sed -n '$p'`   #等待I/0完成
Cpu_sum=$(($cpu_us+$cpu_sy))
#echo $Cpu_sum
Date=`date +%F" "%H:%M`
Num=`netstat -nat |grep 1.5:8001 | wc -l`
UseMem=`free -m | grep Mem: | awk '{print $3}'`
echo '时间:' "$Date" '       8001连接数:' "$Num" '      内存使用:' "$UseMem" '     CPU使用率:' "$Cpu_sum" 
echo '时间:' "$Date" '       8001连接数:' "$Num" '      内存使用:' "$UseMem" '     CPU使用率:' "$Cpu_sum" >>./mintor_logs
#ls -l
done;
