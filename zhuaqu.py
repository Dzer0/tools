# coding:utf-8
# author:Dzer0
# Version:Python2.7.10
# 思路:读取cAdvisor中的内容，并保存到mongodb中。
import urllib2,json
# 为笃定ip地址
ip = '120.26.99.13:4194'
# url_base 为获取宿主机的基本信息 cpu、内存、硬盘、网络
url_base = 'http://' + ip + '/api/v1.0/containers/'
# 通过urllib2访问获取数据
host_info = json.loads(urllib2.urlopen(url_base).read())
#timestamp = host_info['stats'][0]['timestamp']
for i in host_info['stats'][0]['filesystem']:
    device_name = i['device']
    usage = i['usage']/1000/1000/1000.00
    capacity = i['capacity']/1000/1000/1000.00
    #print device_name, usage, capacity
memory_total = host_info['spec']['memory']['limit']/1000/1000/1000.00
memory_usage = host_info['stats'][0]['memory']['cache']/1000/1000/1000.00
#print memory['cache'],memory['working_set'],memory['usage']
cpu_total = host_info['stats'][0]['cpu']['usage']['total']
cpu_system = host_info['stats'][0]['cpu']['usage']['system']
cpu_user = host_info['stats'][0]['cpu']['usage']['user']
print cpu_total,cpu_user,cpu_system