# 运维工具脚本
## 删除了刚刚同步错的内容
## 记录自己的运维平台编写过程，与使用的内容
### 2016-9-8 思路： 
 - 读取cAdvisor的api获取docker的信息（已完成）
 - 安装mongodb数据库，使用json格式存docker信息（未处理）
 - 使用django 读取mongodb数据 生成表格 在前端显示（未处理）

### 2016-9-9 添加了代码程序
 - 还在完成9-8日的第一点
 - 9月8日的第一点还未完成，但是思路已经很清晰下面说下思路
 
 	· 通过http://url:port/api/v1.0/machine 获取宿主机的信息

 	· 通过http://url:port/api/v1.0/containers/docker/containers_id获取容器性能使用情况

### 2016-9-10
 - 增加了异常处理，获取信息完成
 - 安装mongodb数据库
 - 增加了pymongodb.py，作用是写入数据到mongodb中；但是现在有一个问题，是，无法传递mongodb的中“集合”这个参数。囧😳。还在找解决方法