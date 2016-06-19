# coding:utf-8
# Author:Dzer0
# 操作数据库
import time # 时间
import MySQLdb
from jiankong import send_mail, jiance
'''
独立使用

while 1:
    try:
        c = MySQLdb.connect('localhost','root','','jiankong',3306,charset='utf8')
        cursor = c.cursor()
        count = cursor.execute('select * from project')
        print('共有%s条信息' % count)
        # 获取所有记录
        print('获取所有记录')
        result = cursor.fetchmany(count)
        for i in result:
            #print i[3]
            jiance(i)
            print('NEXT')
            #print(i[1].encode('utf8'),i[2].encode('utf8'),i[3].encode('utf8'),i[4].encode('utf8'),i[5])
            #jiance()
            #jiance(i[1].encode('utf8'),i[2].encode('utf8'),i[3].encode('utf8'),i[4].encode('utf8'),i[5])
        c.commit()
        cursor.close()
        c.close()
        time.sleep(20)
    except MySQLdb.Error, e:  
             print 'Mysql 报错了, %d: %s' % (e.args[0], e.args[1])
'''
def conMysql():
    c = MySQLdb.connect('localhost','root','','jiankong',3306,charset='utf8')
    cursor = c.cursor()
    count = cursor.execute('select * from project')
    print('共有%s条信息' % count)
    # 获取所有记录
    print('获取所有记录')
    result = cursor.fetchmany(count)
    c.commit()
    cursor.close()
    c.close()
    return result

if __name__ == '__main__':
    while 1:
        a = conMysql()
        for i in a:
            jiance(i)
        time.sleep(30*60)