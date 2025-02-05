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
    echo "$(date) Error: $1" >&2
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

echo "$(date) Downloading config"
wget --no-check-certificate -O ${SBOX_CONFIG_PATH_NEW} $SBOX_CONFIG_URL
mv $SBOX_CONFIG_PATH_NEW $SBOX_CONFIG_PATH
echo "$(date) - ${SERVICE_NAME} to start" 
/etc/init.d/${SERVICE_NAME} reload
