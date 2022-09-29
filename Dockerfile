FROM alpine:latest as base

ENV VERSION=202208211945
ENV TAC_PLUS_BIN=/tacacs/sbin/tac_plus
ENV CONF_FILE=/etc/tac_plus/tac_plus.cfg
ENV USER_FILE=/etc/tac_plus/tac_user.cfg


FROM base as build
RUN apk add --no-cache \
    build-base bzip2 perl perl-digest-md5 perl-ldap freeradius-client-dev perl-authen-radius pcre-dev
ADD http://www.pro-bono-publico.de/projects/src/DEVEL.$VERSION.tar.bz2 /tac_plus.tar.bz2
RUN tar -xjf /tac_plus.tar.bz2 && \
    cd /PROJECTS && \
    ./configure --with-freeradius --with-pcre --prefix=/tacacs && \
    make && \
    make install

FROM base
COPY --from=build /tacacs /tacacs
ADD mavis_tacplus_radius.pl /tacacs/lib/mavis_tacplus_radius.pl
ADD mavis_tacplus_ldap.pl /tacacs/lib/mavis_tacplus_ldap.pl
RUN chmod u+x /tacacs/lib/mavis_tacplus_ldap.pl && \
    chmod u+x /tacacs/lib/mavis_tacplus_radius.pl

COPY dic.tar.gz dic.tar.gz
RUN mkdir /tacacs/etc/radiusclient && \
    tar xfv dic.tar.gz -C /tacacs/etc/radiusclient/ && \
    rm dic.tar.gz

RUN apk add --no-cache perl perl-digest-md5 perl-ldap perl-authen-radius freeradius-client pcre && \
    rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh 
RUN chmod u+x /entrypoint.sh

COPY tac_base.cfg $CONF_FILE
COPY tac_user.cfg $USER_FILE    

EXPOSE 49
ENTRYPOINT ["/entrypoint.sh"]
