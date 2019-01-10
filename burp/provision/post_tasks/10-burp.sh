#!/bin/bash
set -eo pipefail

# copy configuration files depending on operation mode
copy_autogenerated_files /tmp/burp/$BURP_MODE /container/burp

# set permissions
chmod 0600 /container/burp/burp.conf
if [[ "$BURP_MODE" == server ]]; then
    chmod 0750 /container/burp/notify.sh
elif [[ "$BURP_MODE" == client ]]; then
    chmod 0700 \
        /container/burp/pre-backup.sh \
        /container/burp/post-backup.sh
fi

# cleanup
rm -rf /tmp/burp
