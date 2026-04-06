#!/bin/bash
_NAME=xfce
_UID=$(id -u)
_GID=$(id -g)
_ARG1=1
if [ ! -z "$1" ]; then
	_ARG1=$1
fi
_FULLNAME="${_NAME}${_ARG1}"
_RDPP=$((4000 + $_ARG1))
_VNCP=$((5900 + $_ARG1))

echo "# $0: port number is base port + user-id (arg 1)"
echo "# $_FULLNAME: RDP@$_RDPP VNC@$_VNCP"
# check: sysctl?
# kernel.unprivileged_userns_apparmor_policy = 1
# kernel.unprivileged_userns_clone = 1
for d in ./share ./opt; do
	if [ ! -d $d ]; then mkdir $d; fi
done
docker run -d \
	-p "127.0.0.1:$_RDPP:3389" \
	-p "127.0.0.1:$_VNCP:5910" \
	--cap-add=SYS_ADMIN \
	--cap-add=NET_ADMIN,SETFCAP,SETPCAP,SETUID,SETGID \
	--security-opt seccomp=unconfined \
	--security-opt apparmor=unconfined \
	--security-opt label=disable \
	--security-opt no-new-privileges:false \
	--sysctl net.ipv4.conf.all.src_valid_mark=1 \
	--device /dev/net/tun:/dev/net/tun \
	--volume "./share:/home/user/share" \
	--volume "./opt:/opt" \
	--hostname "$_FULLNAME" --name "$_FULLNAME" \
	chunying/xfce
