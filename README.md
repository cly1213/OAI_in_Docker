# OAI_in_Docker
# OAI eNB with Docker Container on Ubuntu 18.04
## Pull the Ubuntu image from Docker hub.
```shell=
sudo docker pull ubuntu:18.04
sudo docker images ls
```

## Run the docker images.
### docker privileged mode

https://stackoverflow.com/questions/33013539/docker-loading-kernel-modules
https://rancher.com/docs/os/v1.1/en/configuration/kernel-modules-kernel-headers/
```shell=
sudo docker run -t -i --net=host --privileged --cap-add=ALL -v /dev:/dev -v /usr/src:/usr/src -v /lib/modules:/lib/modules --name="oai_enb" ubuntu:18.04 /bin/bash
```
#### in docker
```shell=
apt-get update
apt-get install net-tools vim git iputils-ping sudo software-properties-common git wget psmisc -y
```

## Add a certificate from gitlab.eurecom.fr.
```shell=
echo -n | openssl s_client -showcerts -connect gitlab.eurecom.fr:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' >> /etc/ssl/certs/ca-certificates.crt
```

## Download OAI eNB installs file with git clone in the container.
```shell=
cd ~
git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
cd openairinterface5g

## R14 version
git checkout -b edb74831dabf79686eb5a92fbf8fc06e6b267d35
git branch -v
```
```shell=
source oaienv

cd cmake_targets
sudo ./build_oai -I --eNB -x --install-system-files -w USRP --install-optional-packages

#OR===================================================================

./cmake_targets/build_oai -I  # install SW packages from internet
./cmake_targets/build_oai -w USRP --eNB --UE # compile eNB and UE

#There might be some errors in installation but its okay.
#verify that USRP is working

$ uhd_find_devices

$ uhd_usrp_probe 
```
## Final test and verification
```bash=
sudo bash
cd ~/openairinterface5g; source oaienv
cd cmake_targets/lte_build_oai/build
./lte-softmodem -O ~/enb.10MHz.b200
```

Also you can commit container into image
$ sudo docker commit containerID yourIamgeName
