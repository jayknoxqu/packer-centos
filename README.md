# Packer templates for CentOS

### Overview

This repository contains Packer templates for creating CentOS Vagrant boxes.



### `Master Branch` Boxes

https://app.vagrantup.com/jayknoxqu/boxes/aliyun-centos



### `Docker Branch` Boxes
**pre-install** `docker`, `docker_compose`

https://app.vagrantup.com/jayknoxqu/boxes/docker-centos



### Build dependencies

**Packer:** https://www.packer.io/downloads.html

**VirtualBox:** https://www.virtualbox.org/wiki/Downloads



### Building the Vagrant boxes with Packer

  We make use of JSON files containing user variables to build specific versions of CentOS.
You tell `packer` to use a specific user variable file via the `-var-file=` command line
option. This will override the default options on the core `packer-metadata.json` packer template,
which builds CentOS 7 by default.




#### Customize template

Customize the boxes by modifying the `centos-template.json` file
```json
{
  "iso_url": "https://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso",
  "iso_checksum": "38d5d51d9d100fd73df031ffd6bd8b1297ce24660dc8c13a3b8b4534a4bd291c",
  "iso_checksum_type": "sha256",
  "iso_version": "7.6-x64",
  "disk_size": "65536",
  "memory": "1024",
  "cpus": "2",
  "docker_user_name":"devops",
  "docker_user_password":"google00",
  "docker_version":"18.06.3",
  "docker_compose_version":"1.24.1"
}
```
Tip: **iso_url** value can be **local disk path** or **remote url**



#### Running Packer

```bash
packer build -var-file=centos-template.json packer-metadata.json
```

 debug log output from

```bash
PACKER_LOG=1 packer build -var-file=centos-template.json packer-metadata.json
```



#### Using box

Modify the value `config.vm.box` in file `Vagrantfile`, and then execute the command
```bash
vagrant up
```
