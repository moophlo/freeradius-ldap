FROM debian:stretch
MAINTAINER Moophlo <andrea.odorisio@gmail.com>

# RADIUS Authentication Messages
EXPOSE 1812/udp

# RADIUS Accounting Messages
EXPOSE 1813/udp

# Install freeradius with ldap support
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'deb http://www.linotp.org/apt/debian stretch linotp linotp-deps' > /etc/apt/sources.list.d/linotp.list
RUN apt-get install dirmngr -y
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 913DFF12F86258E5
RUN apt update && apt dist-upgrade -y
RUN apt -y install tini freeradius-ldap mariadb-server
RUN mysql_secure_installation
RUN apt-get install linotp -y
RUN apt-get install linotp-adminclient-cli python-ldap freeradius python-passlib python-bcrypt git libio-all-lwp-perl libconfig-file-perl libtry-tiny-perl -y

# Copy our configuration
RUN rm -rf /etc/freeradius/3.0/mods-available/ldap
COPY ldap /etc/freeradius/3.0/mods-available/
COPY clients.conf /etc/freeradius/3.0/
COPY inner-tunnel /etc/freeradius/3.0/sites-available/
COPY default /etc/freeradius/3.0/sites-available/
COPY init /
RUN chmod +x /init

ENTRYPOINT [ "/init" ]
