# OAI_in_Docker
To be continued...
My work note: https://hackmd.io/SoYgmw6nQgmKLIRRkeDeOw

# OAI eNB with Docker Container on Ubuntu 18.04
## Pull the Ubuntu image from Docker hub.
```shell=
sudo docker pull ubuntu:18.04
sudo docker images ls
```

## Run the docker images.
### Docker privileged mode
```shell=
sudo docker run -t -i --net=my-network --privileged --cap-add=ALL -v /dev:/dev -v /usr/src:/usr/src -v /lib/modules:/lib/modules --name="oai_enb" ubuntu:18.04 /bin/bash
```
#### In container
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

source oaienv
cd cmake_targets
sudo ./build_oai -I --eNB -x --install-system-files -w USRP --install-optional-packages

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
