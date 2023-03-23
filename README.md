# nginx-amplify-agent-syslog-docker
Example of how to configure a Docker container to run nginx + amplify agent without local log files.

## The Idea
This solution utilizes capabilities in NGINX as well as in the Amplify Agent to work well in a Dockerized environment.

NGINX:
* can send logs to multiple destinations
* can send logs to a Syslog server

Amplify Agent:
* can run a Syslog server in-process

Therefore, NGINX can be configured to send Access and Error logs to `stdout` / `stderr` as a good Docker container should. It can also send logs via Syslog to the locally running Agent.

The `nginx.conf` in this repo configures logging like this:
```
access_log /var/log/nginx/access.log main_ext;
access_log syslog:server=127.0.0.1:12000,tag=amplify,severity=info main_ext;
```
Note that in the standard OSS NGINX container, `/var/log/nginx/access.log` is a symlink to `/dev/stdout`.

The `agent.conf.default` file in this repo has the syslog listener config hard-coded.

```
[listener_syslog-default]
address = 127.0.0.1:12000
```

There are also some additions to the `entrypoint.sh` script (copied from [https://github.com/nginxinc/docker-nginx-amplify](https://github.com/nginxinc/docker-nginx-amplify) to configure the a hostname to be displayed in Amplify, since container IDs are not very useful.
