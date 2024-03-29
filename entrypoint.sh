#!/bin/sh

# Check configuration file exists
if [ ! -f /etc/tac_plus/tac_plus.cfg ]; then
    echo "No configuration file at ${CONF_FILE}"
    exit 1
fi

if [ ! -f /etc/tac_plus/tac_user.cfg ]; then
    echo "No user file at ${USER_FILE}"
    exit 1
fi

# Check configuration file for syntax errors
${TAC_PLUS_BIN} -P ${CONF_FILE}
if [ $? -ne 0 ]; then
    echo "Invalid configuration/user file"
    exit 1
fi

# Make the log directories
mkdir -p /var/log/tac_plus

echo "Starting server..."

# Start the server
exec ${TAC_PLUS_BIN} -d 0 ${CONF_FILE}