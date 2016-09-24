#/bin/bash
#Fuction:this script is used to precheck the enviroment for installing vcfc's dependence
#Time:2016-7-17 1842
echo "-----------------------------------------"
echo "start precheck the vcfc's enviroment"
echo "-----------------------------------------"
ubuntu="Ubuntu"
redhat="RedHatEnterpriseServer"
centos="CentOS"
system=""

#判断当前linux的发行版本
function version_of_linux(){
        system=`lsb_release -i | awk '{print $3}'`
        #echo $system
}

#检查防火墙的状态
function check_firewall_status(){
	if [ "$system" = "$centos" ]
	then	
		if systemctl status firewalld.service |grep 'inactive (dead)' > /dev/null 2>&1;
		then 
			echo 'the firewall has been stoped!';
		else
		    	systemctl stop firewalld.service;
		fi
	else
		echo error os;
	fi
} 
#检查libvirt 安装运行情况以及软件版本
function check_libvirt_version(){
        if [ "$system" = "$centos" ]
        then
                libvirtversion=`rpm -qa libvirt |awk -F'-' '{print $2}'`
		virshversion=`virsh --version` 
		if [ $libvirtversion = $virshversion ]
                then
                        echo the libvirt has been installed and version is $libvirtversion;
                else
                        echo 'please retry ./install.sh or contack the 4008100504';
                fi
        else
                echo error os;
        fi
}
#检查postgresql安装运行情况
function check_postgresql_status(){
	if [ "$system" = "$centos" ]
        then 
		if systemctl status postgresql |grep 'active (running)' > /dev/null 2>&1;
		then
			echo 'the postgresql has been installed and is running';
		else
			echo 'please retry ./install.sh or contack the 4008100504';
		fi
	else
		echo error os;
        fi
}


main(){
	version_of_linux;
	check_firewall_status;
	check_libvirt_version;
	check_postgresql_status;
}
	main;
