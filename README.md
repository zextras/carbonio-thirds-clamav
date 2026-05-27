# Carbonio ClamAV

This repository contains build configurations for ClamAV 21 and related certificate packages for the Carbonio platform. It packages the Adoptium Temurin JDK distribution along with curated CA certificates for secure communication.

This repository builds two packages:

- **`carbonio-clamav`** - ClamAV 21 Development Kit based on Adoptium Temurin binaries
- **`carbonio-clamav-cacerts`** - Curated CA certificate keystore for ClamAV with automatic certificate management

The packages are designed to integrate seamlessly with the Carbonio platform, providing Java runtime environment and secure certificate management for Carbonio services.

## Quick Start

### Prerequisites

- Podman installed
- Make

### Building Packages

```bash
# Build packages for Ubuntu 22.04
make build TARGET=ubuntu-jammy

# Build packages for Rocky Linux 9
make build TARGET=rocky-9

# See all available commands
make help
```

### Supported Targets

- `ubuntu-jammy` - Ubuntu 22.04 LTS
- `ubuntu-noble` - Ubuntu 24.04 LTS
- `rocky-8` - Rocky Linux 8
- `rocky-9` - Rocky Linux 9

### Configuration

You can customize the build by setting environment variables:

```bash
# Use a different container runtime
make build TARGET=ubuntu-jammy CONTAINER_RUNTIME=docker

# Use a different output directory
make build TARGET=rocky-9 OUTPUT_DIR=./my-packages

# Use a specific YAP version
make build TARGET=ubuntu-noble YAP_VERSION=1.47
```

## Installation

These packages are distributed as part of the [Carbonio platform](https://zextras.com/carbonio). To install:

### Ubuntu (Jammy/Noble)

```bash
apt-get install carbonio-clamav carbonio-clamav-cacerts
```

### Rocky Linux (8/9)

```bash
yum install carbonio-clamav carbonio-clamav-cacerts
```

## Package Details

### carbonio-clamav

Provides ClamAV 21 Java Development Kit with the following features:

- Based on Adoptium Temurin 21 binaries
- Installed to `/opt/zextras/common/lib/jvm/java`
- Symlinked executables in `/opt/zextras/common/bin`
- Configured to use Carbonio certificate store
- Optimized for Carbonio platform requirements

### carbonio-clamav-cacerts

Provides CA certificate management with:

- Curated CA certificates from Mozilla NSS
- Custom certificate import support
- Automatic certificate backup and restore during upgrades
- Integration with Carbonio's certificate management tools
- Self-signed certificate detection and handling

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for information on how to contribute to this project.

## License

The build scripts, patches, and configuration files in this repository are licensed under the GNU Affero General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.
