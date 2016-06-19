# coding:utf-8
# author:Dzer0
# Version:Python2.7.10
# 思路: 监控web的俩种状态 1、GET 通过获取网页的某个页面内的值是否为预设值的值,来判断是否正常；2、POST通过提交json数据 判断返回内容是否为预设值来判断是否正常。
import time # 时间
import urllib2 # URL操作
#from datetime import * # 时间
from datetime import datetime
import smtplib  # 发送邮件 
from email.mime.text import MIMEText  # 设置邮件头

# 以下为配置信息
mailto_list=["23442435@qq.com"]  # 接收邮件列表
mail_host="smtp.163.com"  #设置服务器
mail_user="*********"    #用户名
mail_pass="******"   #口令 
mail_postfix="163.com"  #发件箱的后缀

def send_mail(to_list,sub,content):  #to_list：收件人；sub：主题；content：邮件内容
    '''
        使用方法:
        if send_mail(mailto_list,"这是一段测试内容","现在是test内容"):   #这是一段测试内容为标题，test内容 为邮件内容
            print "发送成功"  
        else:  
            print "发送失败"
    '''
    me='茂邦项目监控系统'+"<"+mail_user+"@"+mail_postfix+">"   #这里的茂邦项目监控系统可以任意设置，收到信后，将按照设置显示
    msg = MIMEText(content,_subtype='html',_charset='utf-8')    #创建一个实例，这里设置为html格式邮件
    msg['Subject'] = sub    #设置主题
    msg['From'] = me  
    msg['To'] = ";".join(to_list)  
    try:  
        s = smtplib.SMTP()  
        s.connect(mail_host,25)  #连接smtp服务器
        s.login(mail_user,mail_pass)  #登陆服务器
        s.sendmail(me, to_list, msg.as_string())  #发送邮件
        s.close()  
        return True  
    except Exception, e:  
        print str(e)  
        return False  

def jiance(shuju): # a为项目名称 b为访问方法(GET,POST) c为访问地址 D鉴定的值 ee为post提交的参数
    a = shuju[1].encode('utf8')
    b = shuju[2].encode('utf8')
    c = shuju[3].encode('utf8')
    d = shuju[4].encode('utf8')
    ee = shuju[5]
    # print a,b,c,d,ee # 测试时打开
    logs = open('./logs.txt', 'a+')
    logs.writelines(['\n', str(datetime.now()), '----',a, '    开始检测'])
    logs.close()
    print(str(datetime.now()) + '----' + a + '    开始检测')
#    while 1:下方代码全部右移四格
    count = 0 # 计数
    error_count = 0 # 错误计数
    error_neirong = '' # 错误信息
    while count<3:
        time.sleep(5)
        if b == 'GET':
            try:
                status = urllib2.urlopen(c,timeout=5)
                httpcode = status.code
                context = status.read()
                if httpcode == 200 and d in context:
                    print(a + '正常运行')
                    logs = open('./logs.txt','a')
                    logs.writelines(['\n',str(datetime.now()),'----',str(a),'    正常运行'])
                    logs.close()
                    count +=3
                else:
                    if httpcode ==200:
                        print(a + '不匹配')
                        error_count += 1
                        error_neirong = '错误代码:' + str(d) + '不匹配'
                        logs = open('./logs.txt','a')
                        logs.writelines(['\n', str(datetime.now()), '----', str(a), '    出现故障',str(error_count),'次    错误代码:',str(d),'不匹配'])
                        logs.close()
                    else:
                        print(a + '其他错误,已预防为主')
                        error_count +=1
                        error_neirong = '错误代码:' + str(httpcode)
                        logs = open('./logs.txt','a')
                        logs.writelines(['\n', str(datetime.now()), '----', str(a), '    出现故障',str(error_count),'次    错误代码:',str(httpcode)])
                        logs.close()
            except Exception, e:
                error_count += 1
                error_neirong = '错误代码:' + str(e)
                logs = open('./logs.txt','a')
                logs.writelines(['\n',str(datetime.now()),'----',str(a),'    出现故障',str(error_count),'次    错误代码:',str(e)])
                logs.close()
            if error_count >=3: #判断错误次数超过3次自动发送邮件
                print(mailto_list,str(a),error_neirong)
                logs = open('./logs.txt','a')
                logs.writelines(['\n','错误次数已达到',str(error_count),'    已发送邮件提醒'])
                logs.close()
                send_mail(mailto_list,a+'出现故障', error_neirong)
                error_count = 0
                count +=3
        elif b == 'POST':
            print('POST方法提交')
            try:
                req = urllib2.Request(c, ee)
                response =urllib2.urlopen(req)
                context = response.read()
              #  print(context) # POST提交后获取的数据
                if d in context:
                    print(a + '正常运行')
                    logs = open('./logs.txt','a')
                    logs.writelines(['\n',str(datetime.now()),'----',str(a),'    正常运行'])
                    logs.close()
                    count += 3
                else:
                    print(a + '不匹配')
                    error_count += 1
                    error_neirong = '错误代码:' + str(d) + '不匹配'
                    logs = open('./logs.txt','a')
                    logs.writelines(['\n',str(datetime.now()),'----',str(a),'    出现故障',str(error_count),'次    错误代码:',str(e),'不匹配'])
                    logs.close()
            except Exception, e:
                error_count += 1
                error_neirong = '错误代码:' + str(e)
                logs = open('./logs.txt','a')
                logs.writelines(['\n',str(datetime.now()),'----',str(a),'    出现故障',str(error_count),'次    错误代码:',str(e)])
                logs.close()
            if error_count >=3: #判断错误次数超过3次自动发送邮件
                print(mailto_list,a,error_neirong)
                logs = open('./logs.txt','a')
                logs.writelines(['\n','错误次数已达到',str(error_count),'    已发送邮件提醒'])
                logs.close()
                send_mail(mailto_list,a +'出现故障', error_neirong)
                count +=3
                error_count = 0
        else:
            print('PORT')


if __name__ == '__main__':
    #send_mail(['23442435@qq.com'],'\xe7\xac\xac\xe4\xb8\x89\xe6\x96\xb9\xe5\xbc\x80\xe6\x94\xbe\xe5\xb9\xb3\xe5\x8f\xb01.0', '\xe9\x94\x99\xe8\xaf\xaf\xe4\xbb\xa3\xe7\xa0\x81urlopen error [Errno 60] Operation timed out')
    pass

