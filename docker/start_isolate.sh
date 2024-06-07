#!/bin/sh

set -e

QUIET=true
ISOLATE_CHECK_EXECUTE=false
STRICT=false

ARGS=$(getopt -o : -l verbose,execute-patches,strict,help -- "$@")
eval set -- "$ARGS"

while true; do
    case "$1" in
        --verbose)
            QUIET=false
            shift ;;
        --execute-patches)
            ISOLATE_CHECK_EXECUTE=true
            shift ;;
        --strict)
            STRICT=true
            shift ;;
        --)
            shift
            break ;;
        --help)
            echo "$(basename "$0")"
            echo "Usage: [--verbose] [--execute-patches] [--strict] [--help] [--] <command>"
            echo "  --verbose: Print every thing"
            echo "  --execute-patches: Run isolate-check-environment --execute --quiet. Increases reproducibility."
            echo "  --strict: Fail if isolate-check-environment fails."
            echo "  -- <command>: Optional command to be excuted."
            echo "  --help: Show this help message"
            exit 0 ;;
    esac
done

print() {
    if [ $QUIET = false ]; then
        echo "$1"
    fi
}

if ! mount -t cgroup2 | grep -E "\(rw\)|\(rw,|,rw\)|,rw,"; then
    print "/sys/fs/cgroup read-only. Remounting as read-write."
    mount -o remount,rw /sys/fs/cgroup/
fi

# Run isolate daemon
print "Running isolate daemon. This will move all processes to the /daemon control group."
isolate-cg-keeper --move-cg-neighbors & DAEMON_PID=$!

if [ $ISOLATE_CHECK_EXECUTE = true ]; then
    print "Running isolate-check-environment --execute --quiet"
    isolate-check-environment --execute --quiet > /dev/null 2> /dev/null || true
fi

if [ $STRICT = true ]; then
    print "Running isolate-check-environment"
    if [ $QUIET = true ]; then
        isolate-check-environment --quiet > /dev/null 2> /dev/null
    else
        isolate-check-environment
    fi
else
    print "Skipping isolate-check-environment"
fi

exec "$@"

wait $DAEMON_PID
