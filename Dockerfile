# Start from the only available version for ARM which is 9 as container image
FROM mageia:9
# First update mga to latest (for RPM DB support)
RUN urpmi.update -a
RUN urpmi --auto --auto-select
# Prepare as a Mageia build node
RUN urpmi --auto openssh-server xz xauth iurt
RUN useradd iurt
# iurt ssh configured as root with same keys
RUN mkdir -p /home/iurt/.ssh
COPY .ssh/authorized_keys /home/iurt/.ssh
RUN chown -R iurt:iurt /home/iurt/.ssh
RUN chmod 700 /home/iurt/.ssh
RUN chmod 600 /home/iurt/.ssh/authorized_keys
# Setup ssh server
RUN chmod 750 /etc/ssh/sshd_config.d
RUN chmod 640 /etc/ssh/sshd_config.d/*
RUN chmod 640 /etc/ssh/sshd_config
# Generate host keys
RUN ssh-keygen -A
RUN chmod 640 /etc/ssh/ssh_host*
RUN chgrp -R iurt /etc/ssh/sshd_config.d /etc/ssh/sshd_config /etc/ssh/ssh_host*
# Fix sftp-server location
RUN sed -i 's@/usr/lib/openssh/sftp-server@/usr/libexec/openssh/sftp-server@' /etc/ssh/sshd_config
# Setup sudo
COPY iurt /etc/sudoers.d
COPY entrypoint.sh /usr/local/bin
# Everything else run as iurt user
USER iurt
ENTRYPOINT /usr/local/bin/entrypoint.sh
