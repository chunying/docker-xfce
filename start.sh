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
docker run -d \
	-p "127.0.0.1:$_RDPP:3389" \
	-p "127.0.0.1:$_VNCP:5910" \
	--cap-add=SYS_ADMIN --cap-add=SETUID --cap-add=SETGID \
	--security-opt seccomp=unconfined \
	--security-opt apparmor=unconfined \
	--security-opt label=disable \
	--security-opt no-new-privileges:false \
	--volume "./share:/home/user/share" \
	--volume "./opt:/opt" \
	--hostname "$_FULLNAME" --name "$_FULLNAME" \
	chunying/xfce
