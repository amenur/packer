#!/bin/sh

yum -y update

echo "####################"
echo "Install Java JDK 8"
echo "####################"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

echo "##############"
echo "Install Maven"
echo "##############"
sudo yum install -y maven

echo "##############"
echo "Install git"
echo "##############"
sudo yum install -y git

echo "#######################"
echo "Install Docker engine"
echo "########################"
sudo yum install docker -y

echo "################"
echo "Install Jenkins"
echo "################"
#amazon-linux-extras install -y java-openjdk11
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo amazon-linux-extras install -y epel
sudo yum install -y jenkins
#sudo yum install -y epel-release # repository that provides 'daemonize'
sudo usermod -a -G docker jenkins

echo "########################"
echo "Start Jenkins Service"
echo "#######################"
sudo service docker start
sudo service jenkins start
sudo chkconfig jenkins on

echo "########################"
echo "Check Jenkins Service"
echo "#######################"
sudo systemctl status jenkins


#echo "########################################################"
#echo "Store Jenkins Password in /jenkinsInitialAdminPassword"
#echo "########################################################"
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /jenkinsInitialAdminPassword