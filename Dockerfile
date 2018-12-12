FROM c7-systemd:latest
# FROM centos:latest
# ENV container docker
# RUN yum update -y && \
# yum install -y wget && \
# yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
# yum clean all

# # Set environment variables.
# ENV HOME /root
# # Set environment
# ENV JAVA_HOME /opt/jdk
# ENV PATH ${PATH}:${JAVA_HOME}/bin
# # Define working directory.
# WORKDIR /root
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 191
ENV JAVA_VERSION_BUILD 12
ENV JAVA_PACKAGE server-jre
ENV JAVA_SHA256_SUM 8d6ead9209fd2590f3a8778abbbea6a6b68e02b8a96500e2e77eabdbcaaebcae
ENV JAVA_URL_ELEMENT 2787e4a523244c269598db4e85c51e0c

# Download and unarchive Java
RUN apt-get add --update curl && \
  mkdir -p /opt && \
  curl -jkLH "Cookie: oraclelicense=accept-securebackup-cookie" -o java.tar.gz\
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_URL_ELEMENT}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
  echo "$JAVA_SHA256_SUM  java.tar.gz" | sha256sum -c - && \
  gunzip -c java.tar.gz | tar -xf - -C /opt && rm -f java.tar.gz && \
  ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
  apk del curl && \
  rm -rf /var/cache/apk/*

# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin

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

# COPY sdc.tgz /tmp/sdc.tgz
RUN /tmp/run_config.sh

RUN ls /opt/local

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

# RUN systemctl start sdc
CMD ["/usr/sbin/init"]
CMD ["sdc"]
# RUN service sdc start
# CMD ["/bin/bash", “service sdc start”]

# RUN chkconfig --add sdc
