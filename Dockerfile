FROM debian:trixie-slim

ARG _UID _GID
ENV USER_UID=$_UID
ENV USER_GID=$_GID

ENV DEBIAN_FRONTEND=noninteractive

# install base system
RUN mkdir /scripts

COPY scripts/pkgs-base.sh /scripts/pkgs-base.sh
RUN apt update && apt upgrade -y && bash -e /scripts/pkgs-base.sh

COPY scripts/pkgs-extra.sh /scripts/pkgs-extra.sh
RUN apt update && apt upgrade -y && bash -e /scripts/pkgs-extra.sh

# install VScode
COPY ./scripts/pkgs-vscode.sh /scripts/pkgs-vscode.sh
RUN bash -e /scripts/pkgs-vscode.sh

# setup PATH
RUN echo 'export PATH="/opt/anaconda3/bin:/opt/codeql:$PATH"' >> /etc/bash.bashrc

# setup user & vnc
RUN groupadd -g $USER_GID -o usergroup
RUN useradd -u $USER_UID -g $USER_GID -G sudo -m -s /bin/bash -o user
RUN cp /etc/skel/.[a-z]* /home/user/
RUN echo "user:password" | chpasswd
RUN mkdir -p /home/user/.config/tigervnc/
RUN echo "xfce" | vncpasswd -f > /home/user/.config/tigervnc/passwd
COPY scripts/conf/dot.xsession /home/user/.config/tigervnc/xstartup
COPY scripts/conf/dot.vnc.config /home/user/.config/tigervnc/config
RUN chmod 0600 /home/user/.config/tigervnc/passwd
RUN chown -R user:usergroup /home/user
RUN su - user -c 'ln -s ./.config/tigervnc /home/user/.vnc'
RUN echo :10=user >> /etc/tigervnc/vncserver.users

# locale
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && /usr/sbin/locale-gen

# setup rdp
COPY scripts/conf/xrdp.ini /etc/xrdp/xrdp.ini

# required for some apps depends on systemd?
RUN mkdir -p "/run/user/$USER_UID"
RUN chmod 0700 "/run/user/$USER_UID"
RUN chown "$USER_UID:$USER_GID" "/run/user/$USER_UID"

# allow sudo
RUN echo "user ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/user \
	&& chmod 440 /etc/sudoers.d/user

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash", "/entrypoint.sh" ]
