FROM c7-systemd:latest
# FROM centos:latest
# ENV container docker
RUN yum update -y && \
yum install -y wget && \
yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
yum clean all

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.

# (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
# VOLUME [ “/sys/fs/cgroup” ]
CMD [“/usr/sbin/init”]
# RUN yum -y update && yum clean all

# ARG FULLTARBALL_URL=http://archives.streamsets.com/datacollector/3.6.0/tarball/streamsets-datacollector-all-3.6.0.tgz
ARG FULLTARBALL_URL=http://archives.streamsets.com/datacollector/3.6.0/tarball/streamsets-datacollector-core-3.6.0.tgz

RUN mkdir /opt/local
RUN ls /etc/systemd

CMD ["/usr/sbin/init"]

COPY run_config.sh /tmp/

RUN chgrp -R 0 /tmp && \
    chmod -R g=u /tmp

RUN mkdir /etc/sdc

RUN chgrp -R 0 /etc/sdc && \
    chmod -R g=u /etc/sdc

COPY sdc.tgz /tmp/sdc.tgz
RUN /tmp/run_config.sh



# ARG SDC_USER=sdc

RUN chmod g=u /etc/passwd
# ENTRYPOINT [ "uid_entrypoint" ]
# USER ${SDC_USER}

# COPY /opt/local/streamsets-datacollector-3.6.1/systemd/sdc.service /etc/systemd/system/sdc.service


# COPY /opt/local/systemd/sdc.socket /etc/systemd/system/sdc.socket

# RUN systemctl daemon-reload

RUN systemctl enable sdc


# COPY -R /etc/* /etc/sdc


RUN mkdir /var/log/sdc && \
    chgrp -R 0 /var/log/sdc && \
    chmod -R g=u /var/log/sdc

RUN mkdir /var/lib/sdc && \
    chgrp -R 0 /var/lib/sdc && \
    chmod -R g=u /var/lib/sdc

RUN mkdir /var/lib/sdc-resources && \
    chgrp -R 0 /var/lib/sdc-resources && \
    chmod -R g=u /var/lib/sdc-resources


EXPOSE 18630

RUN systemctl start sdc
CMD ["/usr/sbin/init"]
RUN service sdc start
# CMD ["/bin/bash", “service sdc start”]

# RUN chkconfig --add sdc
