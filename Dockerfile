FROM alpine

ENV PASSENGER=passenger-5.0.14 \
    PATH="/passenger/bin:$PATH"

# install build deps
RUN apk add --update ca-certificates ruby procps curl pcre libstdc++ && \
    apk add ruby-rake wget build-base linux-headers curl-dev pcre-dev ruby-dev && \
    apk add --update-cache --repository 'http://nl.alpinelinux.org/alpine/edge/testing' libexecinfo libexecinfo-dev && \
# download+extract passenger
    wget "https://s3.amazonaws.com/phusion-passenger/releases/$PASSENGER.tar.gz" && \
    tar xzf "$PASSENGER.tar.gz" && rm "$PASSENGER.tar.gz" && \
# compile standalone
    mv "$PASSENGER" /passenger && cd /passenger && \
    export EXTRA_PRE_CFLAGS='-O' EXTRA_PRE_CXXFLAGS='-O' EXTRA_LDFLAGS='-lexecinfo' && \
# speed up by trying to skip downloading
    passenger-config install-standalone-runtime --auto --url-root=fake --connect-timeout=1 && \
    passenger-config build-native-support && \
# remove logs and docs
    rm -rf /tmp/* /passenger/doc && \
# remove build deps and apk cache
    apk del ruby-rake wget build-base linux-headers curl-dev pcre-dev ruby-dev libexecinfo-dev && \
    rm -rf /var/cache/apk/* && \
# validate install
    passenger-config validate-install --auto && \
    mkdir -p /usr/src/app

WORKDIR /usr/src/app
EXPOSE 3000

ENTRYPOINT ["passenger", "start", "--log-file=/dev/null", "--no-install-runtime", "--no-compile-runtime", "--no-download-binaries"]
