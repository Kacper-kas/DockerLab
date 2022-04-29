#!/bin/bash
docker network create -d bridge --subnet 10.0.10.0/24 bridge1
docker network create -d bridge --subnet 10.0.2.0/24 bridge2

docker run -itd -p 80:80 --name T2 nginx
docker run -itd -p 8000:80 --name D2 httpd
docker run -itd --name T1 alpine
docker run -itd --name D1 alpine
docker run -itd --name S1 ubuntu
docker network connect --alias host2 bridge2 S1
docker network connect bridge1 T2
docker network connect --ip 10.0.10.254 --alias host1 bridge1 D1
sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT
docker run -itd --name late --net bridge2 ubuntu
docker network connect bridge1 late
docker network connect --alias apa2 bridge2 D2 
docker network connect --alias apa1 bridge1 D2