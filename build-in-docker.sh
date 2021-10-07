#!/bin/sh

# Examples:
#
# Get shell:          ./build-in-docker.sh bash
# Building U540:      ./build-in-docker.sh build -a RISCV64 -t GCC5 -p Platform/SiFive/U5SeriesPkg/FreedomU540HiFiveUnleashedBoard/U540.dsc
# Building U500:      ./build-in-docker.sh build -a RISCV64 -t GCC5 -p Platform/SiFive/U5SeriesPkg/FreedomU500VC707Board/U500.dsc
# Building RiscvVirt: ./build-in-docker.sh build -a RISCV64 -t GCC5 -p Platform/Qemu/RiscvVirt/RiscvVirt.dsc

# Enable bash strict mode
set -euo pipefail

# By default run with docker, if podman is available use that
DOCKER_CMD=docker
RISCV_EDK2_CONTAINER_TAG=latest
# The name of the container image we run
RISCV_EDK2_CONTAINER=ghcr.io/johnazoidberg/riscv-edk2:$RISCV_EDK2_CONTAINER_TAG

PARAM_NUM=$#
SHOW_HELP=0
REBUILD_CONTAINER=0
PUSH_CONTAINER=0
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) SHOW_HELP=1;;
        --rebuild-container-image) REBUILD_CONTAINER=1 ;;
        --push-container-image) PUSH_CONTAINER=1 ;;
        --container-image) RISCV_EDK2_CONTAINER=$2; shift ;;
        -*) echo "Unknown parameter passed: $1"; echo ""; SHOW_HELP=1 ;;
	*) break
    esac
    shift
done

# Run remaining arguments in container or bash if nothing specified
RUN=${@:-bash}

if [ $SHOW_HELP -eq 1 ] ; then
  echo "build-in-docker.sh [args] [commands]"
  echo ""
  echo "-h|--help                       Show this help"
  echo "--rebuild-container-image       Rebuild the container image from the Dockerfile"
  echo "--push-container-image          Push the container image to dockerhub. Requires docker login"
  echo "--container-image [image]       Build with a different container image"
  echo ""
  echo "All [commands] will be run in the container. Default is bash."
  exit 1
fi

# Check if podman is available, then we can run as the current user
if command -v podman &> /dev/null; then
  DOCKER_CMD=podman
else
  if command -v docker &> /dev/null; then
    DOCKER_CMD=docker
  else
    echo "Neither podman nor docker is installed. Please install one of them."
    exit 1
  fi
fi

# Check if we have the image locally already
IMAGE_EXISTS=0
$DOCKER_CMD image inspect "$RISCV_EDK2_CONTAINER" >> /dev/null || IMAGE_EXISTS=$?

# First try to pull the image if it doesn't exist locally
if [ $IMAGE_EXISTS -ne 0 ]; then
  $DOCKER_CMD pull $RISCV_EDK2_CONTAINER
  $DOCKER_CMD image inspect "$RISCV_EDK2_CONTAINER" >> /dev/null || IMAGE_EXISTS=$?
fi

# If it still doesn't exist or if the user wants it, build the image locally
if [ $REBUILD_CONTAINER -eq 1 ] || [ $IMAGE_EXISTS -ne 0 ]; then
  [ $IMAGE_EXISTS -ne 0 ] && echo "Couldn't find $RISCV_EDK2_CONTAINER locally nor pull it."

  echo "Building $RISCV_EDK2_CONTAINER locally"

  # Building like this to build without any context at all.
  # We don't need anything from the local environment in the image.
  $DOCKER_CMD image build -t $RISCV_EDK2_CONTAINER - < Dockerfile
fi

if [ $PUSH_CONTAINER -eq 1 ]; then
  [ $DOCKER_CMD = "podman" ] && \
    echo "Podman has some issues when pushing to the HPE dockerhub. Use cautiously"
  $DOCKER_CMD push $RISCV_EDK2_CONTAINER
fi

# Run the given command in the container
# --rm to clean up the container afterwards. It doesn't contain any state.
#      Everything is in the local directory, since we're fully mounting it into
#      the container. All of the build results are in the Build/ subdirectory.
$DOCKER_CMD run \
  --rm \
  -v $(pwd)/Build:/Build \
  -v $(pwd)/:/docker \
  -v $(pwd)/../edk2:/edk2 \
  -v $(pwd)/../edk2-platforms/:/edk2-platform-riscv \
  -v ~/.ccache:/ccache \
  -e "CCACHE_DIR=/ccache" \
  -e "PACKAGES_PATH=/edk2:/edk2-platform-riscv" \
  -e "EDK_TOOLS_PATH=/edk2/BaseTools" \
  -it "$RISCV_EDK2_CONTAINER" \
   /docker/build-edk2.sh \
   $RUN
