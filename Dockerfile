# Start from the only availble version for ARM which is 8 as container image
FROM mageia:9
# First update mga to latest (for RPM DB support)
RUN urpmi.update -a
RUN urpmi --auto --auto-select
# Prepare as a Mageia build node
RUN urpmi --auto openssh-server xauth iurt
RUN useradd iurt
COPY iurt /etc/sudoers.d
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT /usr/local/bin/entrypoint.sh
