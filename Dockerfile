FROM java:8
MAINTAINER Tobias Raatiniemi <raatiniemi@gmail.com>

ENV CONF_HOME /var/atlassian/confluence
ENV CONF_INSTALL /opt/atlassian/confluence
ENV CONF_VERSION 5.10.2

RUN set -x \
	&& apt-get update \
	&& mkdir -p "${CONF_HOME}" \
	&& chmod -R 700 "${CONF_HOME}" \
	&& mkdir -p "${CONF_INSTALL}" \
	&& curl -Ls "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONF_VERSION}.tar.gz" \
		| tar -xz --directory "${CONF_INSTALL}" --strip-components=1 --no-same-owner \
	&& chmod -R 700 "${CONF_INSTALL}/conf" \
	&& chmod -R 700 "${CONF_INSTALL}/logs" \
	&& chmod -R 700 "${CONF_INSTALL}/temp" \
	&& chmod -R 700 "${CONF_INSTALL}/work" \
	&& echo -e "\nconfluence.home=$CONF_HOME" >> "${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties"

# Expose default HTTP connector port.
EXPOSE 8090

VOLUME ["${CONF_HOME}"]

WORKDIR ${CONF_HOME}
CMD ["/opt/atlassian/confluence/bin/start-confluence.sh", "-fg"]
