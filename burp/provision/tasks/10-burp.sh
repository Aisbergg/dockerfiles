#!/bin/bash
set -eo pipefail

export BURP_MODE=$(default "$BURP_MODE" client server)
export MYSQL_DATABASES=${MYSQL_DATABASES:-""}

print_info "Configuring Burp in '$BURP_MODE' mode"

if [[ "$BURP_MODE" == server ]]; then
    mkdir -p \
        /container/burp/clientconfdir \
        /container/tls \
        /container/backup

    export INIT=supervisor
    export BURP_SERVER_SSL_DHFILE=${BURP_SERVER_SSL_DHFILE:-"/container/tls/dhfile.pem"}
    export BURP_CLIENT_PASSWORD="$(create_random_string 64)"

    if [[ ! -f "$BURP_SERVER_SSL_DHFILE" ]] ; then
        print_info "Generating Diffie-Hellman parameters, this will might take a long time..."
    	openssl dhparam -dsaparam -out "$BURP_SERVER_SSL_DHFILE" 4096
    	chmod 600 "$BURP_SERVER_SSL_DHFILE"
    fi

elif [[ "$BURP_MODE" == client ]]; then
    mkdir -p \
        /container/burp \
        /container/tls

    BURP_CLIENT_SCHEDULE=${BURP_CLIENT_SCHEDULE:-20}
    BURP_IONICE_CLASS=${BURP_IONICE_CLASS:-2}
    BURP_IONICE_CLASSDATA=${BURP_IONICE_CLASSDATA:-7}
    export INIT=tini
    export INIT_ARGS=( /usr/bin/ionice -c${BURP_IONICE_CLASS} -n${BURP_IONICE_CLASSDATA} /usr/bin/schedule_program --minutes $BURP_CLIENT_SCHEDULE --wake-up 60 -- /usr/sbin/burp -a t -c /container/burp/burp.conf )
fi
