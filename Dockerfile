FROM mageia:8
# First update mga8 to latest (for RPM DB support)
RUN urpmi.update -a
RUN urpmi --auto --auto-select
# Now move to mga9
RUN urpmi.removemedia -a
RUN urpmi.addmedia --distrib mga http://distrib-coffee.ipsl.jussieu.fr/pub/linux/Mageia/distrib/9/aarch64/
RUN urpmi.update -a
RUN urpmi --auto --auto-select
RUN urpmi -y openssh-server
ENTRYPOINT /usr/sbin/sshd -D -p 2222
