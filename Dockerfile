FROM fedora:21

MAINTAINER Mikulas Dite <mikulas@mangoweb.cz>

ENV shellcheckVersion 0.4.5

RUN useradd shellcheck \
    && yum install --setopt=tsflags=nodocs --nogpgcheck --assumeyes --quiet \
		cabal-install \
		tar \
		zlib-devel \
	&& cabal update \
	&& cabal install cabal-install \
    && yum clean all \
    && rm -rf /var/cache/yum

USER shellcheck

RUN curl -Lso /tmp/shellcheck-$shellcheckVersion.tar.gz \
		https://github.com/koalaman/shellcheck/archive/v$shellcheckVersion.tar.gz \
    && tar zxf /tmp/shellcheck-$shellcheckVersion.tar.gz -C /tmp/ \
    && rm /tmp/shellcheck-$shellcheckVersion.tar.gz \
    && cabal install /tmp/shellcheck-$shellcheckVersion

ENTRYPOINT ["/home/shellcheck/.cabal/bin/shellcheck"]
CMD ["-s", "bash", "*.sh"]
