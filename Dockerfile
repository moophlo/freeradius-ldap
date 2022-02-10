FROM ubuntu:focal
MAINTAINER Moophlo <andrea.odorisio@gmail.com>

# RADIUS Authentication Messages
EXPOSE 1812/udp

# RADIUS Accounting Messages
EXPOSE 1813/udp

# Install freeradius with ldap support
RUN apt update && apt dist-upgrade -y
RUN apt -y install tini freeradius-ldap

# Copy our configuration
RUN rm -rf /etc/freeradius/3.0/mods-available/ldap
COPY ldap /etc/freeradius/3.0/mods-available/
COPY init /

ENTRYPOINT [ "/init" ]
