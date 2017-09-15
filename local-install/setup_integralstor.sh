#!/bin/bash

# Configure network interfaces
echo "Configure network interfaces"
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=none/' /etc/sysconfig/network-scripts/ifcfg-eno*
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=none/' /etc/sysconfig/network-scripts/ifcfg-enp*
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=none/' /etc/sysconfig/network-scripts/ifcfg-em*
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=none/' /etc/sysconfig/network-scripts/ifcfg-eth*
sed -i 's/ONBOOT=yes/ONBOOT=no/' /etc/sysconfig/network-scripts/ifcfg-eno*
sed -i 's/ONBOOT=yes/ONBOOT=no/' /etc/sysconfig/network-scripts/ifcfg-enp*
sed -i 's/ONBOOT=yes/ONBOOT=no/' /etc/sysconfig/network-scripts/ifcfg-em*
sed -i 's/ONBOOT=yes/ONBOOT=no/' /etc/sysconfig/network-scripts/ifcfg-eth*
sed -i 's/NM_CONTROLLED=no/NM_CONTROLLED=yes/' /etc/sysconfig/network-scripts/ifcfg-eno*
sed -i 's/NM_CONTROLLED=no/NM_CONTROLLED=yes/' /etc/sysconfig/network-scripts/ifcfg-enp*
sed -i 's/NM_CONTROLLED=no/NM_CONTROLLED=yes/' /etc/sysconfig/network-scripts/ifcfg-em*
sed -i 's/NM_CONTROLLED=no/NM_CONTROLLED=yes/' /etc/sysconfig/network-scripts/ifcfg-eth*
sed -i 's/IPV6INIT=yes/IPV6INIT=no/' /etc/sysconfig/network-scripts/ifcfg-eno*
sed -i 's/IPV6INIT=yes/IPV6INIT=no/' /etc/sysconfig/network-scripts/ifcfg-enp*
sed -i 's/IPV6INIT=yes/IPV6INIT=no/' /etc/sysconfig/network-scripts/ifcfg-em*
sed -i 's/IPV6INIT=yes/IPV6INIT=no/' /etc/sysconfig/network-scripts/ifcfg-eth*


# Prevent Network Manager from adding DNS servers received from DHCP to /etc/resolv.conf
echo "Prevent Network Manager from adding DNS servers received from DHCP to /etc/resolv.conf"
sed -i '/\[main\]/a dns=none' /etc/NetworkManager/NetworkManager.conf
echo "NETWORKING=yes" >> /etc/sysconfig/network
echo "127.0.0.1   localhost   localhost.localdomain   localhost4    localhost4.localdomain4" > /etc/hosts


# Disable OPenGPGCheck
echo "Disable OPenGPGCheck"
if [ -e "/etc/abrt/abrt-action-save-package-data.conf" ] ; then
  sed -i 's/OpenGPGCheck = yes/OpenGPGCheck = no/' /etc/abrt/abrt-action-save-package-data.conf
else
  echo "No such file found : /etc/abrt/abrt-action-save-package-data.conf"
fi


# Configure sshd
echo "Configure sshd"
/usr/sbin/sshd stop
cp /etc/ssh/sshd_config /etc/ssh/original_sshd_config
sed '/#PermitRootLogin/a PermitRootLogin no' /etc/ssh/sshd_config > /etc/ssh/temp_file
rm -f /etc/ssh/sshd_config
mv /etc/ssh/temp_file /etc/ssh/sshd_config
/usr/sbin/sshd start


# Disable CentOS base, updates and extras repositories
echo "Disable CentOS base, updates and extras repositories"
cp -rf /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/Original-CentOS-Base-repo
sed -i '/\[base\]/a enabled=0' /etc/yum.repos.d/CentOS-Base.repo
sed -i '/\[updates\]/a enabled=0' /etc/yum.repos.d/CentOS-Base.repo
sed -i '/\[extras\]/a enabled=0' /etc/yum.repos.d/CentOS-Base.repo
sed -i '/\[centosplus\]/a enabled=0' /etc/yum.repos.d/CentOS-Base.repo
sed -i '/\[contrib\]/a enabled=0' /etc/yum.repos.d/CentOS-Base.repo


# Create required directories
echo "Create required directories"
/usr/bin/mkdir -p /opt/integralstor
/usr/bin/mkdir -p /run/samba
/usr/bin/mkdir -p /opt/integralstor/integralstor/tmp


# Pull and extract Integralstor tar ball
echo "Pull and extract Integralstor tar ball"
cd /opt/integralstor/
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/integralstor.tar.gz
/bin/tar xzf integralstor.tar.gz
rm integralstor.tar.gz

# Pull and install non RPM packages
echo "Pull and install non RPM packages"
cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/sysstat-11.0.5.tar.xz
/bin/tar xJf sysstat-11.0.5.tar.xz
cd sysstat-11.0.5
./configure --prefix=/usr
make
make install
rm -rf sysstat-11.0.5*
cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/setuptools-29.0.1.tar.gz
/bin/tar xzf setuptools-29.0.1.tar.gz
cd setuptools-29.0.1
python setup.py install
rm -rf setuptools-29.0.1*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/uwsgi-2.0.9.tar.gz
/bin/tar xzf uwsgi-2.0.9.tar.gz
cd uwsgi-2.0.9
python setup.py install
rm -rf uwsgi-2.0.9*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/netifaces-0.10.5.tar.gz
/bin/tar xzf netifaces-0.10.5.tar.gz
cd netifaces-0.10.5
python setup.py install
rm -rf netifaces-0.10.5*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/six-1.10.0.tar.gz
/bin/tar xzf six-1.10.0.tar.gz
cd six-1.10.0
python setup.py install
rm -rf six-1.10.0*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/python-dateutil-2.6.0.tar.gz
/bin/tar xzf python-dateutil-2.6.0.tar.gz
cd python-dateutil-2.6.0
python setup.py install
rm -rf python-dateutil-2.6.0*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/python-crontab-2.1.1.tar.gz
/bin/tar xzf python-crontab-2.1.1.tar.gz
cd python-crontab-2.1.1
python setup.py install
cd /tmp
rm -rf python-crontab-2.1.1*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/mbuffer-20161115.tgz
/bin/tar xzf mbuffer-20161115.tgz
cd mbuffer-20161115
./configure
make && make install
cd /tmp
rm -rf mbuffer-20161115*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/zfs-auto-snapshot.tar.gz
/bin/tar xzf zfs-auto-snapshot.tar.gz
cd zfs-auto-snapshot
make install
cd /tmp
rm -rf zfs-auto-snapshot*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/Django-1.8.16.tar.gz
/bin/tar xzf Django-1.8.16.tar.gz
cd Django-1.8.16
python setup.py install
cd /tmp
rm -rf Django-1.8.16*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/cron_descriptor-1.2.6.tar.gz
/bin/tar xzf cron_descriptor-1.2.6.tar.gz
cd cron_descriptor-1.2.6
python setup.py install
cd /tmp
rm -rf cron_descriptor-1.2.6*

cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/nagios-plugins-2.1.4.tar.gz
/bin/tar -xvf nagios-plugins-2.1.4.tar.gz
cd nagios-plugins-2.1.4
./configure
make
make install
cd /tmp
rm -rf nagios-plugins-2.1.4*
cd /tmp
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/tar_installs/3.0.1.tar.gz
/bin/tar -xvf 3.0.1.tar.gz
cd nrpe-3.0.1/
./configure
make all
make install-groups-users
make install
make install-plugin
make install-daemon
make install-config
make install-init
cd /tmp
rm -rf nrpe*
rm -rf 3.0.1*

modprobe ipmi_devintf
modprobe 8021q

hardware_vendor=''
hardware_vendor= `cat /root/hardware_vendor | cut -d':' -f2`
# Configure Integralstor
echo "Configure Integralstor"
echo "Hardware vendor: $hardware_vendor"
echo "/opt/integralstor/integralstor/install/configure_integralstor.sh $hardware_vendor" | /bin/bash

if grep "dell" /opt/integralstor/platform > /dev/null
then
  (crontab -l 2>/dev/null; echo "@reboot srvadmin-services.sh restart > /tmp/srvadmin_logs >> /tmp/srvadmin_errors") | crontab -
  echo "copying integralstor repository..."
  cd /etc/yum.repos.d
  /usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/integralstor.repo
  echo "copying integralstor repository...Done"
  echo "installing dell specific dependencies..."
  yum install srvadmin-all dell-system-update -y
  echo "installing dell specific dependencies...Done"
  echo "disabling integralstor repository..."
  sed -i '/\[updates\]/a enabled=0' /etc/yum.repos.d/integralstor.repo
  echo "disabling integralstor repository...Done"
else
  echo "Non dell hardware."
fi

# Run login_menu.sh at user login
echo "Run login_menu.sh at user login"
ln -s /opt/integralstor/integralstor/scripts/shell/login_menu.sh /etc/profile.d/spring_up.sh

# Configuring nagios
echo "Configuring nagios"
echo "nrpe            5666/tcp                 NRPE" >>/etc/services
iptables -A INPUT -p tcp -m tcp --dport 5666 -j ACCEPT
firewall-cmd --zone=public --add-port=5666/tcp --permanent


# Configure AFP
echo "Configure AFP"
mkdir /tmp/netatalk
cd /tmp/netatalk
echo "Installing AFT Dependencies..."
/usr/bin/wget -c http://192.168.1.150/netboot/distros/centos/7.2/x86_64/integralstor/v1.0/netatalk.tar.gz
/bin/tar xzf netatalk.tar.gz
cat >> /etc/yum.repos.d/integralstor.repo << EOF
[integralstor]
enabled=1
name= integralstor - base
baseurl=file:///tmp/netatalk/netatalk
gpgcheck=0
EOF
yum install avahi dbus nss-mdns gnome-boxes netatalk -y
echo "Installing AFT Dependencies...Done"
cat >> /etc/yum.repos.d/integralstor.repo << EOF
[integralstor]
enabled=0
name= integralstor - base
baseurl=file:///tmp/netatalk/netatalk
gpgcheck=0
EOF

cp /opt/integralstor/integralstor/install/conf_files/afpd.service /etc/avahi/services/
cp /opt/integralstor/integralstor/install/conf_files/afpd.conf /etc/netatalk/
echo "hosts: files mdns4_minimal dns mdns mdns4" >> /etc/nsswitch.conf

# Turn on services
echo "Turn on services"
systemctl start nrpe &> /dev/null; systemctl enable nrpe &> /dev/null
systemctl start avahi-daemon &> /dev/null; systemctl enable avahi-daemon &> /dev/null
systemctl start netatalk &> /dev/null; systemctl enable netatalk &> /dev/null

systemctl daemon-reload
udevadm control --reload-rules

sed -i 's/rhgb/net.ifnames=0 biosdevname=0 ipv6.disable=1/' /etc/default/grub &> /dev/null
grub2-mkconfig -o /boot/grub2/grub.cfg &> /dev/null

# Configure default IP(172.16.16.16) on eth0
systemctl enable first-boot

