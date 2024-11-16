#!/bin/bash

# -------------------------------------------
# Basic configuration
# -------------------------------------------

# Mode to change output behavior
#   cron   - This script is invoked by cron
#   icinga - This script is invoked by icinga
RUN_MODE="cron"

# Name of the container
CONTAINER="aethir-checker-node"

# Command to invoke the CLI
CMD="podman exec -it $CONTAINER /opt/aethir/AethirCheckerCLI"

# Command to run expect
EXPECT=/usr/bin/expect

# Command to send mail
MAIL_CMD=/usr/bin/mail

# -------------------------------------------
# Kill any existing AethirCheckerCLI instance
# -------------------------------------------
function cli_cleanup(){
    if podman exec $CONTAINER pgrep -f AethirCheckerCLI > /dev/null; then
        podman exec $CONTAINER kill -9 $(podman exec $CONTAINER pgrep -f AethirCheckerCLI)
        sleep 1
    fi
}

cli_cleanup

# -------------------------------------------
# Spawn AethirCheckerCLI and check the status
# -------------------------------------------
$EXPECT << EOF >/dev/null 2>&1
set timeout 60
spawn $CMD

expect {
    "Please accept the Terms of service before continuing.*" {
        send "y\r"
    }
    "Please input:" {
        send "aethir license list --all\r"
        expect {
            -re "Status\r\n.*(Checking|Ready)" {
		send "aethir exit\r"
                expect eof
                exit 0
            }
            default {
		send "aethir exit\r"
                expect eof
                exit 1
            }
        }
    }
    timeout {
	send "aethir exit\r"
        expect eof
        exit 1
    }
}
EOF
EXIT_STATUS=$?

cli_cleanup

# -------------------------------------------
# Deal with the result
# -------------------------------------------
if [ "$RUN_MODE" = "cron" ]; then
    if [ $EXIT_STATUS -ne 0 ]; then
        echo "Health check for container $CONTAINER has failed." | $MAIL_CMD -s "Monitoring Alert: Aethir Checker Node on $HOSTNAME has failed" root
    fi
    # No output for success
elif [ "$RUN_MODE" = "icinga" ]; then
    if [ $EXIT_STATUS -eq 0 ]; then
        echo "OK - Container $CONTAINER is healthy"
        exit 0
    else
        echo "CRITICAL - Container $CONTAINER is unhealthy"
        exit 2
    fi
else
    echo "Invalid RUN_MODE specified. Use 'cron' or 'icinga'."
    exit 1
fi

