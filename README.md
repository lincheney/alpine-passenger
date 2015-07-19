# [alpine-passenger](https://registry.hub.docker.com/u/lincheney/alpine-passenger/)
[![](https://badge.imagelayers.io/lincheney/alpine-passenger:latest.svg)](https://imagelayers.io/?images=lincheney/alpine-passenger:latest 'Get your own badge on imagelayers.io')

Phusion Passenger Standalone running on Alpine Linux in Docker.

Available on Docker Hub: https://registry.hub.docker.com/u/lincheney/alpine-passenger/

## Super simple [Rack](http://rack.github.io/) example

Shamelessly copy the example on the rack website ...
```ruby
# config.ru
run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
```

... add a Dockerfile ...
```
# Dockerfile
FROM lincheney/alpine-passenger
RUN apk add --update ruby-rack && rm -rf /var/cache/apk/*
COPY config.ru /usr/src/app/
```

... build the image and then run it!
```sh
> docker build -t rack-example .
> docker run -d -p 80:3000 --name rack-app rack-example
> curl 'http://localhost'
get rack'd
```

We can also get the Passenger status:
```sh
docker exec rack-app passenger status
```

## Details

The image based on [Alpine Linux 3.2](https://registry.hub.docker.com/_/alpine/)
running the [Phusion Passenger Standalone runtime 5.0.14](https://www.phusionpassenger.com/documentation/Users guide Standalone.html)
with native support compiled for [Ruby 2.2.2](http://pkgs.alpinelinux.org/package/main/x86_64/ruby).

### Phusion Passenger Standalone

The standalone runtime runs on Nginx. Those interested should take a look at the 
[docs](https://www.phusionpassenger.com/documentation/Users guide Standalone.html) provided by the Phusion team, especially [command line options](https://www.phusionpassenger.com/documentation/Users%20guide%20Standalone.html#_command_line_options)
and [Nginx configuration](https://www.phusionpassenger.com/documentation/Users%20guide%20Standalone.html#advanced_configuration)

#### Default command line arguments

By default, the image runs with `passenger start --no-install-runtime --no-compile-runtime --no-download`
plus the additional supplied to `docker run`.

Passenger runs on port 3000 by default and this port has been exposed.

### Building extension modules

You can use this image to build the Nginx or Apache modules for Phusion Passenger.
Take care that you will need to compile from source! Pre-compiled binaries that the Phusion team
provide (probably) won't work since Alpine Linux uses `musl` instead of `glibc`.

Have a look at the `alpine-passenger` Dockerfile to see how the standalone runtime was compiled.
