# PC-Free — Windows 10 in GitHub Codespaces and Docker

Run a complete Windows 10 environment in your browser with automatic setup, secure generated credentials, and persistent storage. PC-Free is open source; cloud-host usage and Windows licensing are separate.

[![GitHub stars](https://img.shields.io/github/stars/suraj-premi/PC-Free?style=social)](https://github.com/suraj-premi/PC-Free/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/suraj-premi/PC-Free?style=social)](https://github.com/suraj-premi/PC-Free/network/members)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![Windows 10](https://img.shields.io/badge/Windows-10-0078D6?style=flat&logo=windows&logoColor=white)](https://www.microsoft.com/windows)

**[🇪🇸 Español](#español)** • **[🚀 Quick Start](#quick-start-windows-10-in-your-browser)** • **[📖 Documentation](#documentation)** • **[🐛 Report Bug](https://github.com/suraj-premi/PC-Free/issues)**

![Windows 10 Desktop in Browser](./images/windows10-desktop.png)

---

## What is PC-Free?

PC-Free is an open-source project that lets you run Windows 10 directly in your web browser using GitHub Codespaces and Docker. No local Windows installation or powerful client device is required. Codespaces usage depends on your GitHub quota.

### Key Benefits

- ✅ **Open Source** - PC-Free has no software fee; cloud-host quota may apply
- ✅ **Browser-Based** - Access Windows from any device
- ✅ **5-Minute Setup** - Deploy Windows 10 in minutes
- ✅ **No PC Required** - Run Windows without owning a Windows PC
- ✅ **Docker Container** - Isolated, secure, and portable
- ✅ **Persistent Data** - Your files and apps survive restarts
- ✅ **Open Source** - MIT licensed, community-driven

---

## Table of Contents

- [Quick Start](#quick-start-windows-10-in-your-browser)
- [System Requirements](#system-requirements)
- [Management Commands](#management-commands)
- [Configuration](#configuration)
- [Hindi Setup Guide](SETUP-HI.md)
- [FAQ](#frequently-asked-questions-faq)
- [Troubleshooting](#troubleshooting-common-issues)
- [Contributing](#contributing)
- [License](#license)

---



## Comparison: PC-Free vs Alternatives

Compare PC-Free with other Windows cloud solutions:

| Feature | PC-Free | Azure Virtual Desktop | AWS WorkSpaces | Local VM |
|---------|---------|----------------------|----------------|----------|
| **Monthly Cost** | ✅ Uses free quota | ❌ $31-100+ | ❌ $25-75+ | ✅ $0 (Free) |
| **Setup Time** | ⚡ 10–20 minutes | ⏱️ 30+ minutes | ⏱️ 30+ minutes | ⏱️ 15-30 minutes |
| **Hardware Required** | ✅ None | ✅ None | ✅ None | ❌ Powerful PC needed |
| **Browser Access** | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Limited |
| **Open Source** | ✅ Yes | ❌ No | ❌ No | ⚠️ Partial |
| **Data Persistence** | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |

---

## Quick Start: Windows 10 in Your Browser

> **Hindi instructions:** [SETUP-HI.md](SETUP-HI.md)
>
> Windows 10 reached end of support on October 14, 2025. Use it only when you specifically need Windows 10, keep the browser port private, and provide your own valid Microsoft licence.

### Option 1: GitHub Codespaces (recommended)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/suraj-premi/PC-Free?quickstart=1)

1. Fork this repository, then create a Codespace with **4 cores or more**.
2. The included Dev Container configuration creates secure credentials and starts Windows 10 automatically.
3. Codespaces opens the forwarded **Windows 10 (Web)** port (8006). Keep its visibility **Private**.
4. In the Codespace terminal, display the generated login:

```bash
./pcfree credentials
```

The first installation normally takes 10–20 minutes. The Windows disk persists when the Codespace stops.

### Option 2: KVM-enabled Linux host

```bash
git clone https://github.com/suraj-premi/PC-Free.git
cd PC-Free
./pcfree setup
```

The setup command:

- generates a private `.env` file and strong Windows password;
- verifies Docker, Compose, KVM, TUN, CPU, RAM, and storage;
- downloads the pinned Dockur Windows image;
- starts an unattended Windows 10 Pro installation; and
- keeps the VM disk under `windows/` and shared files under `shared/`.

Open <http://localhost:8006> and get the login with `./pcfree credentials`.

## System Requirements

### GitHub Codespaces

- GitHub account with Codespaces quota
- x86_64 Codespace, 4 cores recommended
- At least 32 GB available storage
- Modern web browser and stable connection

### Local host

- x86_64 **Linux** host with `/dev/kvm` access
- Docker Engine and Docker Compose v2
- 2+ CPU cores (4 recommended)
- 4+ GB host RAM (8 GB recommended)
- 32+ GB free disk space

> Docker Desktop on macOS, Linux, and Windows 10 does not expose KVM to this container and is not supported. Windows 11 requires nested virtualization. Run `./pcfree doctor` before downloading anything to verify your machine.

## Management Commands

```bash
./pcfree doctor       # Check all host requirements
./pcfree start        # Start or resume Windows
./pcfree stop         # Graceful shutdown; data is preserved
./pcfree restart      # Restart the VM
./pcfree status       # Show container health/status
./pcfree logs         # Follow installation and runtime logs
./pcfree open         # Open the browser viewer
./pcfree credentials  # Show Windows/web username and password
./pcfree update       # Pull the configured image and recreate safely
./pcfree down         # Remove the container, not the VM data
```

## Configuration

`./pcfree setup` creates `.env` from [.env.example](.env.example). Edit that local file to customize Windows, then run `./pcfree down && ./pcfree start`.

```ini
WINDOWS_RAM_SIZE=4G
WINDOWS_CPU_CORES=2
WINDOWS_DISK_SIZE=64G
WINDOWS_LANGUAGE=en-US
WINDOWS_REGION=en-US
WINDOWS_KEYBOARD=en-US
WEB_PORT=8006
RDP_PORT=3389
```

The web viewer and RDP bind to `127.0.0.1` by default. Do not expose RDP directly to the public internet. The web viewer uses the generated Windows credentials for HTTP authentication.

### Persistent storage and file sharing

- `windows/` contains the virtual disk and survives container recreation.
- `shared/` appears as the `Shared` desktop folder and `Z:` drive in Windows.
- `.env` contains credentials, is mode `600`, and is ignored by Git.

To remove Windows permanently, stop it first and then manually delete `windows/`. This cannot be undone.

## Screenshots

### Windows 10 Desktop Interface
![Windows 10 Desktop](./images/windows10-desktop.png)

### Windows 11 Alternative
![Windows 11 About](./images/windows11-about.png)

---

## Frequently Asked Questions (FAQ)

### How long does Windows take to boot?

- **Initial boot**: usually 10–20 minutes (download + unattended installation)
- **Subsequent boots**: 2-3 minutes

### Can I install additional software?

Yes! You have full administrator access. Installed software persists in Docker volumes between restarts.

### Does this work on GitHub free tier?

It can, if your GitHub account has enough Codespaces quota. Quotas and machine availability depend on your current GitHub plan; check the billing page before starting a large machine.

### Can I use this for gaming?

Limited. Codespaces don't have GPU acceleration. Light, older games may work, but modern 3D games won't run well.

### Is this legal to use?

Yes, provided you have a valid Windows license. This uses official Windows installation methods. Check Microsoft's licensing terms for your use case.

### How secure is this setup?

The VM runs inside a container, the Codespaces forwarded port is private by default, and the web viewer requires the generated login. Keep port 8006 private and never expose RDP directly to the public internet.

### Can I access my files from outside?

Yes, files stored in Docker volumes persist between sessions. You can also mount external volumes or use cloud storage within Windows.

### What internet speed do I need?

Minimum 2 Mbps for basic usage. 5+ Mbps recommended for smooth experience. Initial setup downloads a Windows image of roughly 6 GB.

---

## Troubleshooting Common Issues

### Windows Container Won't Start

Run the built-in checks, then inspect the logs:

```bash
./pcfree doctor
./pcfree logs
```

Verify KVM access (Linux):

```bash
ls -la /dev/kvm
```

### Slow Performance Issues

1. Ensure the host has at least 4 GB RAM (8 GB recommended)
2. Keep at least 2 CPU cores assigned
3. Close other resource-intensive Codespace apps
4. Use RDP on `localhost:3389` after installation for better responsiveness

### Cannot Access Port 8006

1. Run `./pcfree status` and confirm the service is running
2. In Codespaces, open the **Ports** tab and keep port 8006 **Private**
3. Click the globe icon next to port 8006
4. Locally, open `http://localhost:8006` and check firewall settings

### Storage Full Error

Check what is consuming space before deleting anything:

```bash
df -h
docker system df
```

The persistent VM is in `windows/`. Do not delete that folder unless you intend to erase Windows permanently.

### Container Keeps Restarting

Check if KVM is available:

```bash
# Linux
ls -l /dev/kvm

# If not available, may need to enable KVM in BIOS
```

### Black Screen After Login

1. Wait 2-3 minutes for desktop to load
2. Try refreshing browser
3. Check if container is still running: `./pcfree status`
4. Restart container: `./pcfree restart`

---

## Roadmap - Upcoming Features

- [x] Windows 10 support
- [x] Docker Compose setup
- [x] Web interface (noVNC)
- [x] Persistent storage volumes
- [x] Windows 11 support
- [x] One-command setup and diagnostics
- [ ] GPU passthrough (local Docker)
- [ ] Audio support improvement
- [ ] Clipboard synchronization
- [ ] Pre-configured Windows templates
- [ ] Multiple Windows instances
- [ ] Automated backup system
- [ ] Performance optimization guide

[Vote for features →](https://github.com/suraj-premi/PC-Free/discussions)

---

## Contributing

Contributions are welcome! Help improve PC-Free:

1. **Fork** the project repository
2. **Create** feature branch: `git checkout -b feature/AmazingFeature`
3. **Commit** changes: `git commit -m 'Add AmazingFeature'`
4. **Push** to branch: `git push origin feature/AmazingFeature`
5. **Open** a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Ways to Contribute

- 🐛 Report bugs and issues
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit bug fixes
- ⭐ Star and share the project

---

## Community & Support

- 💬 [GitHub Discussions](https://github.com/suraj-premi/PC-Free/discussions) - Ask questions
- 🐛 [Issue Tracker](https://github.com/suraj-premi/PC-Free/issues) - Report bugs
- ⭐ [Star this repo](https://github.com/suraj-premi/PC-Free) - Show support
- 👤 Follow [@jephersonRD](https://github.com/jephersonRD) for updates

---

## Documentation

- 📖 [Full Documentation](https://github.com/suraj-premi/PC-Free/wiki)
- 🚀 [Advanced Setup Guide](https://github.com/suraj-premi/PC-Free/wiki/Advanced-Setup)
- 🔧 [Troubleshooting Guide](https://github.com/suraj-premi/PC-Free/wiki/Troubleshooting)
- 🎯 [Best Practices](https://github.com/suraj-premi/PC-Free/wiki/Best-Practices)

---

## License

Distributed under the MIT License. See [LICENSE](LICENSE) file for more information.

---

## Acknowledgments

Special thanks to:

- [dockurr/windows](https://github.com/dockurr/windows) - Docker Windows image
- [GitHub Codespaces](https://github.com/features/codespaces) - Cloud development environment
- All our [amazing contributors](https://github.com/suraj-premi/PC-Free/graphs/contributors)

---

## Support the Project

If PC-Free helped you, consider:

- ⭐ **Starring** this repository
- 🐦 **Sharing** on social media
- 📝 **Writing** a blog post about it
- 🤝 **Contributing** code or documentation

---

## 🇪🇸 Español

### Inicio Rápido en Español

1. Haz fork del repositorio
2. Abre en Codespace
3. Sigue la Guía Rápida arriba
4. Accede al puerto 8006

[Ver documentación completa →](https://github.com/suraj-premi/PC-Free/wiki)

---

<div align="center">

**⭐ Star this repo if you found it helpful!**

Made with ❤️ for developers who need Windows without owning a PC

[⬆ Back to top](#pc-free---windows-10-in-github-codespaces--run-windows-10-free-in-browser)

</div>
