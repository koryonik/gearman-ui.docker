# Gearman UI Docker image

Docker image for [Gearman UI](http://gaspaio.github.io/gearmanui/), a small PHP application providing a minimal 
monitoring dashboard for a cluster of Gearman Job Servers.

## Usage

To run the server and expose the port:

### With Docker

```bash
$ docker run -it --rm --name=gearmanui -p 8085:80 \ 
	--link gearman:gearman koryonik/gearman-ui
```

### With Fig / Docker compose

```
gearmanui:
	image: koryonik/gearman-ui
		ports:
		- "8085:80"
		links:
		- gearman

gearman:
	image: pataquets/gearmand
	ports:
    	- '4730:4730'
```

## Configuration

If you need to link multiple Gearman servers, or change other application settings, create & mount your own config file `gearmanui.yml` :

```
# gearmanui.yml

# The list of servers to monitor.
gearmanui.servers:
    - name: "Gearmand#1"
      addr: "gearman1:4730"
    - name: "Gearmand#2"
      addr: "1.2.3.4:4730"

# General settings.
gearmanui.settings:
    # Server info refresh interval, in seconds.
    # The javascript will ajax the server every 'refresh_interval' seconds for new information.
    refresh_interval: 5

# By default, only log errors. Check \Monolog\Logger for valid values.
monolog.level: 400
```

And mount file :

```bash
$ docker run -it --rm --name=gearmanui -p 8085:80 \
	--link gearman:gearman koryonik/gearman-ui \
	"$PWD"/gearmanui.yml:/gearmanui/app/config/gearmanui.yml
```