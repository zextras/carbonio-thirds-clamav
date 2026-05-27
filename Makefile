# SPDX-FileCopyrightText: 2026 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: AGPL-3.0-only

# Makefile for building carbonio-clamav packages using YAP
#
# Usage:
#   make build TARGET=ubuntu-jammy           # Build all packages for Ubuntu 22.04
#   make build TARGET=rocky-9                # Build all packages for Rocky Linux 9
#   make clean                               # Clean build artifacts
#
# Supported targets:
#   ubuntu-jammy, ubuntu-noble, rocky-8, rocky-9

# Configuration
YAP_IMAGE_PREFIX ?= docker.io/m0rf30/yap
YAP_VERSION ?= 1.47
CONTAINER_RUNTIME ?= podman

# Build directories
OUTPUT_DIR ?= artifacts

# Default target (can be overridden)
TARGET ?= ubuntu-jammy

# Container image name (format: docker.io/m0rf30/yap-<target>:<version>)
YAP_IMAGE = $(YAP_IMAGE_PREFIX)-$(TARGET):$(YAP_VERSION)

# Container name
CONTAINER_NAME ?= yap-clamav-$(TARGET)

# Container options
CONTAINER_OPTS = --rm -ti \
	--name $(CONTAINER_NAME) \
	-v $(CURDIR):/project \
	-v $(CURDIR)/$(OUTPUT_DIR):/artifacts \
	-e OUTPUT_DIR=/artifacts

.PHONY: all build clean list-targets help pull

# Default target
all: help

## help: Show this help message
help:
	@echo "Carbonio ClamAV - Build System"
	@echo ""
	@echo "This Makefile builds ClamAV packages for Carbonio using YAP"
	@echo "(Yet Another Packager) in Podman containers."
	@echo ""
	@echo "Usage:"
	@echo "  make <target> [TARGET=<distro>] [OPTIONS]"
	@echo ""
	@echo "Targets:"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## /  /' | column -t -s ':'
	@echo ""
	@echo "Options:"
	@echo "  TARGET             Distribution target (default: $(TARGET))"
	@echo "  YAP_IMAGE_PREFIX   YAP image prefix (default: $(YAP_IMAGE_PREFIX))"
	@echo "  YAP_VERSION        YAP image version (default: $(YAP_VERSION))"
	@echo "  CONTAINER_RUNTIME  Container runtime (default: podman)"
	@echo "  CONTAINER_NAME     Container name (default: $(CONTAINER_NAME))"
	@echo "  OUTPUT_DIR         Output directory for packages (default: $(OUTPUT_DIR))"
	@echo ""
	@echo "Examples:"
	@echo "  make build TARGET=ubuntu-jammy"
	@echo "  make build TARGET=rocky-9"
	@echo "  make pull TARGET=ubuntu-noble"
	@echo ""

## build: Build ClamAV packages for the specified TARGET
build:
	@echo "Building ClamAV packages for $(TARGET)..."
	@mkdir -p $(OUTPUT_DIR)
	$(CONTAINER_RUNTIME) run $(CONTAINER_OPTS) $(YAP_IMAGE) build $(TARGET) /project

## pull: Pull the YAP container image for the specified TARGET
pull:
	@echo "Pulling YAP image for $(TARGET)..."
	$(CONTAINER_RUNTIME) pull $(YAP_IMAGE)

## clean: Remove build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(OUTPUT_DIR)

## list-targets: List supported distribution targets
list-targets:
	@echo "Supported distribution targets:"
	@echo ""
	@echo "  ubuntu-jammy    (Ubuntu 22.04 LTS)"
	@echo "  ubuntu-noble    (Ubuntu 24.04 LTS)"
	@echo "  rocky-8         (Rocky Linux 8)"
	@echo "  rocky-9         (Rocky Linux 9)"
	@echo ""
	@echo "Usage: make build TARGET=<target>"
