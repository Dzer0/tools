��ϵͳ�汾CentOS 7.0  ��С�汾

1�� ȷ���Լ������� �����Ƿ���eth0
2�� һ��������Ⱥ�˿�Ϊ9000-9005 6���˿�
3�� ��һ����װ����Ҫ������


ʹ�÷�����
linxu�½����Ŀ¼ ֱ������ sh start.sh����



�����޸�
��startĿ¼��
vim  create_redis_cluster.sh
�ڶ����޸���������


�˿��޸�
��startĿ¼��
vim start_cluster.sh
{9000..9005} ��Ϊ�˿ڶΣ����������޸ļ���
Ҳ����д������ģʽ9000 9003 9004 9100 9002 8888 ȥ�������ţ�ֱ��д�����֣�
for i in 9000 8888 2222 6666 8887 7777;do


�Ľű�ֻ�����ڵ�ϵͳ������Ⱥ


Ŀ¼��⣺
redis3.0.7 			����redis
start      			���������ű�
redis-3.0.7.gem 		������Ⱥ��Ҫ��redis����
ruby-2.2.5.tar.gz 		ruby��װ���������߰�װruby
rubygems-update-2.6.7.gem	rubygems���߰�װ�����������߰�װ
start.sh 			���ܵ�һ�������ű�

startĿ¼��
create_redis_cluster.sh 	������Ⱥ����
password.sh			һ�����ü�Ⱥ���룬ע��ᵼ�¼�Ⱥ���������ݿ��ܻᶪʧ
start_cluster.sh 		����redis��Ⱥ�ڵ�
stop.sh				ֹͣ��ɾ��������redis