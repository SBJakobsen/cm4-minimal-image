#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <rpi3/rpi4>. Supply which architecture you are building for."
    exit 1
fi

case $1 in
    rpi3)
        MACHINE=raspberrypi3
        ;;
    rpi4)
        MACHINE=raspberrypi4-64
        ;;
    *)
        echo "Invalid parameter. Use 'rpi3' or 'rpi4'."
        exit 1
        ;;
esac

BUILD_DIR=build
REMOVEBUILD=no
LOG=no
IMAGE=update-image
BITBAKEARGS=
LOGFILE=`pwd`/`basename "$0"`.log
EXIT_CODE=0

function log {
    # Address log levels
    case $1 in
        ERROR)
            loglevel=ERROR
            shift
            ;;
        WARN)
            loglevel=WARNING
            shift
            ;;
        *)
            loglevel=LOG
            ;;
    esac
    ENDTIME=$(date +%s)
    if [ "z$LOG" == "zyes" ]; then
        printf "[%09d%s%s\n" "$(($ENDTIME - $STARTTIME))" "][$loglevel]" "$1" | tee -a $LOGFILE
    else
        printf "[%09d%s%s\n" "$(($ENDTIME - $STARTTIME))" "][$loglevel]" "$1"
    fi
    if [ "$loglevel" == "ERROR" ]; then
        exit 1
    fi
}

# Timer
STARTTIME=$(date +%s)

# Get the absolute script location
pushd `dirname $0` > /dev/null 2>&1
SCRIPTPATH=`pwd`
popd > /dev/null 2>&1


if [ "x$REMOVEBUILD" == "xyes" ]; then
    log "Removing old build in $SCRIPTPATH/../../$BUILD_DIR."
    log "This might take a while ..."
    rm -rf $SCRIPTPATH/../../$BUILD_DIR
fi


export TEMPLATECONF=${SCRIPTPATH}/conf/samples
source ${SCRIPTPATH}/layers/poky/oe-init-build-env ${SCRIPTPATH}/${BUILD_DIR}


log "TestRunner build initialized in directory: $BUILD_DIR."

# Start builds
if [ "$DRY_RUN" == "yes" ]; then
    log "Dry run requested so don't start builds."
    log WARN "Don't forget to setup build MACHINE as this script ignores it in dry run mode."
else
    log "Run build for $MACHINE: MACHINE=$MACHINE bitbake $IMAGE $BITBAKEARGS"
    log "This might take a while ..."
    env MACHINE=$MACHINE bitbake ${IMAGE} $BITBAKEARGS

    if [ $? -eq 0 ]; then
        log "Build for $MACHINE suceeded."
    else
        log "Build for $MACHINE failed. Check failed log in $BUILD_DIR/tmp/log/cooker/$machine ."
        EXIT_CODE=2 # Fail at the end
    fi
fi

log "Done."

exit $EXIT_CODE