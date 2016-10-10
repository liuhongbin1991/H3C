#!/bin/bash
#***************************************************** 
#ScriptName:make_cdrom_as_a_yum.sh 
#Author:liu.hongbin@h3c.com  
#Create Date:2016-10-09 17:28 
#Fuction:this shell is used to make a local cdrom as a source for yum
#判断是否存在/mnt/cdrom这个目录
if [ ! -d "/mnt/cdrom" ]; then
  mkdir /mnt/cdrom
  echo 'create /mnt/cdrom for your cdrom'
fi
#挂载对应光盘
mount /dev/cdrom /mnt/cdrom >/dev/null 2>&1;
localpath=/mnt/cdrom
#判断是否安装了createrepo的RPM包
if [ `rpm -qa | grep createrepo |wc -l` = 0 ];then
        rpm -ivh $localpath/Packages/deltarpm-3.6-3.el7.x86_64.rpm;
        rpm -ivh $localpath/Packages/python-deltarpm-3.6-3.el7.x86_64.rpm;
        rpm -ivh $localpath/Packages/createrepo-0.9.9-23.el7.noarch.rpm;
fi;
#创建cdrom.repo文件
if [ ! -a /etc/yum.repos.d/cdrom.repo ] ;then
        touch /etc/yum.repos.d/cdrom.repo
fi;
if [ `cat /etc/yum.repos.d/cdrom.repo |wc -l` ! = 4 ];then
        > /etc/yum.repos.d/cdrom.repo
        echo [cdrom] >>/etc/yum.repos.d/cdrom.repo
        echo name=CentOS7 - cdrom >> /etc/yum.repos.d/cdrom.repo
        echo baseurl=file:///mnt/cdrom/ >> /etc/yum.repos.d/cdrom.repo
        echo enable=1 >> /etc/yum.repos.d/cdrom.repo
fi
yum clean all >/dev/null 2>&1;
echo "you can use the yum like 'yum --disablerepo=* --enablerepo=cdrom list'"