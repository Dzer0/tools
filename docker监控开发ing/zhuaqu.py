# coding:utf-8
# author:Dzer0
# Version:Python2.7.10
# 思路:1、读取cAdvisor中的docker信息
#     2、将数据保存到mongodb中

import urllib2,json
from pymongodb import insert_mongodb_data
# 获取宿主机相关信息
def get_machine(url):
	'''
		获取宿主机的所有信息磁盘、cpu、内存等等等
	'''
	info = json.loads(urllib2.urlopen(url).read())
	cpu_total = info['cpu_frequency_khz']
	memory_total  = info['topology'][0]['memory']
	return {'cpu_total':cpu_total,'memory_total':memory_total}
# 获取磁盘使用信息
def get_disk_info(url):
    '''
        通过 cAdvisor获取磁盘信息
    '''
    disk = []
    # 通过urllib2访问获取数据
    info = json.loads(urllib2.urlopen(url).read())
    #timestamp = host_info['stats'][0]['timestamp']
    for i in info['stats'][0]['filesystem']:
        device_name = i['device']
        usage = i['usage']/1000/1000/1000.00
        capacity = i['capacity']/1000/1000/1000.00
        disk_info = {}
        disk_info['device_name'] = device_name
        disk_info['usage'] = usage
        disk_info['capacity'] = capacity
        disk.append(disk_info)
        #print device_name, usage, capacity
    return disk
# 获取所有容器
def get_containers(url):
    info = json.loads(urllib2.urlopen(url).read())
    #print info
    list_containers = []
    for i  in info['subcontainers']:
        list_containers.append(url_base_disk + i['name'])
    return list_containers
    #list_containers =  get_containers(url_containers)
#print list_containers
# 获取单个容器内所有信息
def get_containers_info(url):

    '''
        # a = get_containers_info('http://120.26.99.13:4194/api/v1.0/containers/docker/ed3ff139938c0812d82dc44cdc4a5e1cefffbb45a38b925832d5b8fe41f0023a')
    '''
    dzero = [] # 保存获取的系统信息
    info_dzero = [] # 保存实时系统性能数据
    info = json.loads(urllib2.urlopen(url).read())
    containers_id = info['aliases'][1]
    image = info['spec']['image']
    try:
        container_name = info['spec']['labels']['io.kubernetes.container.name']
        svc_pod_name = info['spec']['labels']['io.kubernetes.pod.name']
        restartCount = info['spec']['labels']['io.kubernetes.container.restartCount']
    except Exception, e:
        container_name = info['aliases'][0]
        svc_pod_name = ''
        restartCount = '0'
    creation_time = info['spec']['creation_time']
    dzero.append({'containers_id':containers_id,'image':image,'container_name':container_name + '_' + svc_pod_name,'restartCount':restartCount,'creation_time':creation_time})
    #cpu_usage = info['stats'][0]['cpu']['usage']['total']/(get_machine(url_machine)['cpu_total']*1000000.00) # 不知道为啥 要多加6个零才是正确的cpu占用比，坐等以后查询检查问题
    i = 0
    # print len(info['stats'])
    while i < len(info['stats']):
        cpu_usage = info['stats'][i]['cpu']['usage']['total']/1000/1000/1000/1000/10.00 # cpu的百分比？？ ###针对系统top命令对比  除以1000/1000/1000/1000/10 最后结果为系统cpu占用率。不知道原理后期检查
        memory_usage = info['stats'][i]['memory']['usage']/1024/1024.00 # 以M为单位
        timestamp = info['stats'][i]['timestamp']
        info_dzero.append({'timestamp':timestamp, 'containers_id':containers_id,'container_name':container_name + '_' + svc_pod_name,'cpu_usage':cpu_usage,'memory_usage':memory_usage})
        i += 1
    return info_dzero

if __name__ == '__main__':
    # ip地址
    ip = '120.26.99.13'
    port = '4194'
    # 获取宿主机的信息url，获取宿主的 cpu和内存
    url_machine = 'http://' + ip + ':' + port + '/api/v1.0/machine'
    # 获取磁盘的url
    url_base_disk = 'http://' + ip + ':' + port + '/api/v1.0/containers'
    # 获取所有容器的url
    url_containers = url_base_disk + '/docker/'
    containers_list = get_containers(url_containers)
    savepost = []
    #x = get_containers_info('http://120.26.99.13:4194/api/v1.0/containers/docker/ef52a843f21fef082f966ebd8ca7915776288153e7b60e7f941c3aace08e1623')
    #print x

    for i in containers_list:
        x = get_containers_info(i)
        savepost = savepost + x
        #print x[1]['container_name']+"-------CPU:" + str(x[1]['cpu_usage'])+'------mem:'+ str(x[1]['memory_usage']) + '-----id:' +x[1]['containers_id']
    a = insert_mongodb_data('120.26.129.95',10086,'mintor','2599','mintor','containers_info',savepost)
    print a
