#!/bin/bash -e
# ==============================================================================
# Author      : ZhenJin.Qu
# Email       : jayknoxqu@gmail.com
# Date      : 2019.08.26
# Version     : 1.0.0
# Description   : This script is initialize the development environment
# ==============================================================================

add_dependent(){

  echo -e "\e[36m==> Install basic kit and docker dependencies...\e[0m"
  yum install -y git unzip vim yum-utils conntrack-tools net-tools telnet tcpdump bind-utils socat ntp kmod ceph-common dos2unix device-mapper-persistent-data lvm2

  echo -e "\e[36m==> Add aliyun mirrors to yum source.\e[0m"
  curl http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo

  echo -e "\e[36m==> Yum make cache all.\e[0m"
  yum makecache all

}

deploy_docker(){

  echo -e "\e[36m==> The input docker_version is ${DOCKER_VERSION}...\e[0m"
  local version=$(yum list docker-ce.x86_64 --showduplicates | sort -r | grep ${DOCKER_VERSION} | awk '{print $2}')

  echo -e "\e[36m==> Install docker-ce-${version} and docker-ce-selinux-${version}...\e[0m"
  yum -y install --setopt=obsoletes=0 docker-ce-${version} docker-ce-selinux-${version}

}

deploy_composes(){

  echo -e "\e[36m==> Install docker-ce-${COMPOSES_VERSION}...\e[0m"
  curl -L https://github.com/docker/compose/releases/download/${COMPOSES_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

  chmod +x /usr/local/bin/docker-compose

}

new_user(){

  echo -e "\e[36m==> You are setting username : ${DOCKER_USER_NAME}.\e[0m"
  adduser ${DOCKER_USER_NAME}

  echo -e "\e[36m==> You are setting password : ${DOCKER_USER_PASSWORD} for ${DOCKER_USER_NAME}.\e[0m"
  echo ${DOCKER_USER_PASSWORD} | passwd --stdin ${DOCKER_USER_NAME}

  echo -e "\e[36m==> Setting the user [${DOCKER_USER_NAME}] as administrator.\e[0m"
  echo "${DOCKER_USER_NAME} ALL=(ALL) ALL" >> /etc/sudoers

  echo -e "\e[36m==> Add the current user [${DOCKER_USER_NAME}] to the docker group.\e[0m"
  usermod -aG docker ${DOCKER_USER_NAME}

}

start_daemon(){

   echo -e "\e[36m==> Setting up docker image acceleration.\e[0m"
   mkdir -p /etc/docker && tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://92g9mk7b.mirror.aliyuncs.com"]
}
EOF

  echo -e "\e[36m==> Start the docker.\e[0m"
  systemctl start docker

  echo -e "\e[36m==> Setting docker boot up.\e[0m"
  systemctl enable docker

}

config_network(){

  echo -e "\e[36m==>Configure the docker network.\e[0m"

  echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf
  echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.conf
  sysctl -p

}

main() {
  add_dependent
  deploy_docker
  deploy_composes
  new_user
  start_daemon
  config_network
  echo -e "==>\e[1;33m Deployment Complete. <==.\e[0m"
}

main
