# TACACS+ Docker Image

This image is a built version of [tac_plus](http://www.pro-bono-publico.de/projects/),
a TACACS+ implementation written by Marc Huber.

Various configuration options and components were taken from an existing docker image repo which can be found here:
https://github.com/lordmrcs/docker-tacacs

## Configuration
Configuration is stored in two files `tac_base.cfg` and `tac_user.cfg` for the majority of users neither of these need changing should simple, basic TACACS+ testing be required.

If additional users or parameters are required, the `tac_user.cfg` file should be modified and passed into the container via a docker volume using `-v /path/to/tac_user.cfg:/etc/tac_plus/tac_user.cfg`

If base configuration changes are required, the `tac_base.cfg` file can be altered and included as a docker volume following the above syntax.

## Usage
By default all logs (including detailed information on authorization and authentication) are sent to stdout, meaning they're available to view via `docker logs` once the container is operational. This log contains all AAA information.

A log file is also generated with less verbosity (i.e. no debug information). This can be found at `/var/log/tac_plus.log` within the container. This can either be exported via a docker volume or read directly to console by cat or tailing the file via docker exec. E.g. `docker exec <containerid / name>  tail -f /var/log/tac_plus.log`

TACACS+ uses port 49. This is exposed by the container, but will require forwarding to the host if the default bridged networking is used using `-p 49:49`

Example - Running the default container for a quick test and inspecting the logs:
```
docker run -it --rm -p 49:49 ghcr.io/lordmrcs/docker-tacacs:master
```  

Example - Deamonise the container and live-view basic logs after a while:
```
docker run -itd --name=tacacs -p 49:49 ghcr.io/lordmrcs/docker-tacacs:master
docker exec tacacs tail -f /var/log/tac_plus.log
```  

Example - Deamonise the container and live-view all logs after a while:
```
docker run -itd --name=tacacs -p 49:49 ghcr.io/lordmrcs/docker-tacacs:master
docker logs -f tacacs
```  

Example - Daemonise the container with a modified config file and live-view all logs after a while:
```
docker run -itd --name=tacacs -v /path/to/my/config/tac_user.cfg:/etc/tac_plus/tac_user.cfg:ro -p 49:49 ghcr.io/lordmrcs/docker-tacacs:master
docker logs -f tacacs
```
