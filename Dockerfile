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
# Adds schedbot pubkey
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD74XjxAUlKsEQngCGQ7uG1waCkd26ZbzUSUHdnQ3VGLxK2X8VTpDAN1xAxrQM2bTmED1o1y3UhI5n3QicJspB8DZUS7CW93bsE6GrIqh9e1HVbZXzV20esU2r68I5GUsBXXS5EQkUQfESAtAvL9cSARo/ZXiJ6yeX5OiFKofD6i1WnkboP6HM3fdG+vNZV5EYq1MU33NOUYR8HMMNFjcAiVpBjM++x1I+rIKro6l3jFKgBMfC1+afAB2o7en3CuqJtpcspb3A8wIKxXLWWK/aU5U8WK2lbixBzNWDb1Ug3HH7/DQdhZsZUe7U5bRlMe9U6OkJasOOeGqAuWrO6kcoN schedbotssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD74XjxAUlKsEQngCGQ7uG1waCkd26ZbzUSUHdnQ3VGLxK2X8VTpDAN1xAxrQM2bTmED1o1y3UhI5n3QicJspB8DZUS7CW93bsE6GrIqh9e1HVbZXzV20esU2r68I5GUsBXXS5EQkUQfESAtAvL9cSARo/ZXiJ6yeX5OiFKofD6i1WnkboP6HM3fdG+vNZV5EYq1MU33NOUYR8HMMNFjcAiVpBjM++x1I+rIKro6l3jFKgBMfC1+afAB2o7en3CuqJtpcspb3A8wIKxXLWWK/aU5U8WK2lbixBzNWDb1Ug3HH7/DQdhZsZUe7U5bRlMe9U6OkJasOOeGqAuWrO6kcoN schedbot' >> /home/iurt/.ssh/authorized_keys
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
