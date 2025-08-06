#!/bin/sh

# listener.sh - Run this on macOS host (outside container)
# Listens on port 8080 and says "hello" when triggered

PORT=${1:-8080}

echo "Starting listener on port $PORT..."
echo "Press Ctrl+C to stop"
echo ""

while true; do
    echo "$(date): Listening on port $PORT..."

    # Listen, capture message, and send response back (closes connection immediately)
    nc -l $PORT | (
        read RECEIVED_MESSAGE
        echo "received"  # This goes back to the client, closing the connection

        if [ -n "$RECEIVED_MESSAGE" ]; then
            echo "$(date): Received message: '$RECEIVED_MESSAGE'" >&2
            echo "$(date): Saying: '$RECEIVED_MESSAGE'" >&2
            say "$RECEIVED_MESSAGE" &
        else
            echo "$(date): Empty message received - saying default" >&2
            say "hello" &
        fi
    )
    echo ""
done
