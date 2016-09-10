# coding:utf-8
# author:Dzer0
# Version:Python2.7.10
# 操作mongodb数据库，制作操作mongodb数据库操作的api.

from pymongo import MongoClient
def insert_mongodb_data(ip,port,user,pwd,databsename,collections,datas):
    '''
        ip : 表示mongodb数据库地址
        port : 端口
        user : 用户名
        pwd : 密码
        databsename : 数据库名
        collections : 集合名（类似于表名）
        datas : 要插入的数据 注:json格式{ 'aaa':123,'bbb':456,'ccc':789 }
    '''
    client = MongoClient('120.26.129.95',10086) # 建立数据库连接
    db = client[databsename] # 切换数据库
    a = db.authenticate(user,pwd) # 登录数据库
    if a == True: # 判断是否登录成功
        db.collection_names() # 显示所有集合
        coll = db.containers_info # 选择集合   ####坑坑坑 不知道为啥不能引用？？艹
        print coll
        try:
            coll.insert(datas)
        except Exception, e:
            return e        
        return 'Insert Success !!!'
    else:
        return 'Login faild'

if __name__ == '__main__':
    post = {'C': 0.002}
    a = insert_mongodb_data('120.26.129.95',10086,'mintor','2599','mintor','containers_info',post)
    print a