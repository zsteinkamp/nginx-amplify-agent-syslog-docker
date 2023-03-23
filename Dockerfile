FROM nginx:1

# Steps required to install the Amplify Agent
RUN apt-get update
RUN apt-get install --no-install-recommends --no-install-suggests -y curl gnupg1 procps lsb-release ca-certificates debian-archive-keyring lsof netcat
RUN curl https://nginx.org/keys/nginx_signing.key | gpg1 --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://packages.amplify.nginx.com/py3/debian/ $(lsb_release -cs) amplify-agent" > /etc/apt/sources.list.d/nginx-amplify.list
RUN apt-get update
RUN apt-get install --no-install-recommends --no-install-suggests -y nginx-amplify-agent
#RUN apt-mark hold nginx-amplify-agent
#RUN apt-get remove --purge --auto-remove -y curl gnupg1
#RUN rm -f /etc/apt/sources.list.d/nginx-amplify.list
#RUN rm -f /usr/share/keyrings/nginx-archive-keyring.gpg
#RUN rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh
COPY ./agent.conf.default /etc/amplify-agent/agent.conf.default
ENTRYPOINT ["/entrypoint.sh"]
