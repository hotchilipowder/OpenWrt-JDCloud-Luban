#!/bin/sh
# sing-box monitor

LOG_FILE="/var/log/sbox_monitor.log"
SERVICE_NAME="sing-box"
SBOX_PATH="/tmp/sing-box/sing-box"
SBOX_URL="https://github.com/hotchilipowder/sing-box/releases/download/binary-linux_mipsle_softfloat/sing-box"
SBOX_CONFIG_PATH="/tmp/sing-box/config.json"
SBOX_CONFIG_PATH_NEW="/tmp/sing-box/config-new.json"
SBOX_CONFIG_URL=""

error_exit() {
    echo "$(timestamp) Error: $1" >&2
    exit "${2:-1}"
}

# no file
if [ ! -f "$SBOX_PATH" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ${SERVICE_NAME} not found"

    wget --no-check-certificate -O $SBOX_PATH $SBOX_URL 
    chmod +x $SBOX_PATH
fi

if ! pgrep -f "${SERVICE_NAME}" > /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ${SERVICE_NAME} to start" 
    /etc/init.d/${SERVICE_NAME} start
fi

echo "$(timestamp) Downloading config"
wget --no-check-certificate -O ${SBOX_CONFIG_PATH_NEW} $SBOX_CONFIG_URL

if ! ${SERVICE_NAME} check -c "$SBOX_CONFIG_PATH_NEW"; then
    echo "$(timestamp) new config not working"
    error_exit "Config Error"
else
    mv $SBOX_CONFIG_PATH_NEW $SBOX_CONFIG_PATH
    echo "$(timestamp) - ${SERVICE_NAME} to start" 
    /etc/init.d/${SERVICE_NAME} reload
fi

