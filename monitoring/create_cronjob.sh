#!/bin/bash

# Configuration variables
CRON_FILE="/etc/cron.d/aethir_monitor"
MONITOR_SCRIPT="/opt/aethir/monitoring/monitor.sh"

# Setup cron job (only if not already configured)
if ! grep -q "$MONITOR_SCRIPT" /etc/cron.d/*; then
    cat <<EOF | sudo tee $CRON_FILE
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin

*/15 * * * * root $MONITOR_SCRIPT
EOF

    chmod 644 $CRON_FILE
    echo "Cron job successfully configured."
else
    echo "Cron job already exists, skipping configuration."
fi
