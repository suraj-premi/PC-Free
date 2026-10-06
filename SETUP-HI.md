# Windows 10 setup — Hindi guide

PC-Free ab Windows 10 ko Docker + KVM mein automatically configure karta hai. Windows browser mein port **8006** par aur Remote Desktop se port **3389** par milta hai.

> Windows 10 ka support 14 October 2025 ko end ho chuka hai. Internet-facing ya sensitive kaam ke liye supported Windows version use karein. Windows chalane/activate karne ke liye valid Microsoft licence aapki zimmedari hai.

## Sabse aasaan: GitHub Codespaces

1. Repository ke GitHub page par **Code → Codespaces → Create codespace** choose karein.
2. 4-core (ya bada) machine aur kam-se-kam 32 GB storage choose karein.
3. Codespace khulte hi PC-Free secure credentials banakar Windows 10 start karega.
4. Forwarded port **8006 — Windows 10 (Web)** automatically browser mein khulega. Agar nahi khule, **Ports** tab se port 8006 open karein. Port ko **Private** rakhein.
5. Login dekhne ke liye Codespace terminal mein:

```bash
./pcfree credentials
```

Pehli installation ko aam taur par 10–20 minute lagte hain.

## Linux host par local setup

### Requirements

- x86_64 Linux host
- Docker Engine aur Docker Compose v2
- `/dev/kvm` access (BIOS/UEFI mein Intel VT-x ya AMD-V enabled)
- 2+ CPU cores, 4+ GB RAM (8 GB recommended)
- 32+ GB free storage

Check aur start:

```bash
./pcfree setup
```

Phir `http://localhost:8006` kholein. Login:

```bash
./pcfree credentials
```

Agar setup rukta hai to exact problem dekhne ke liye:

```bash
./pcfree doctor
```

## Roz ke commands

```bash
./pcfree start        # Windows start
./pcfree stop         # Safe shutdown; data save rahega
./pcfree restart      # Restart
./pcfree status       # Status
./pcfree logs         # Installation/runtime logs
./pcfree open         # Browser viewer
./pcfree credentials  # Login details
./pcfree update       # Container image update
./pcfree down         # Container remove; VM data safe
```

## Settings

Pehli run par `.env` banti hai. Ismein RAM, CPU, disk, language aur ports badal sakte hain:

```ini
WINDOWS_RAM_SIZE=4G
WINDOWS_CPU_CORES=2
WINDOWS_DISK_SIZE=64G
WINDOWS_LANGUAGE=en-US
WINDOWS_REGION=en-IN
WINDOWS_KEYBOARD=en-US
```

Badlav ke baad:

```bash
./pcfree down
./pcfree start
```

- Windows VM disk: `windows/`
- Windows Desktop ka shared folder: `shared/` (guest mein `Z:`)
- Secrets: `.env` — ise kabhi commit/share na karein

## Windows ya macOS host

Dockur ko KVM chahiye. **Docker Desktop on Windows 10**, macOS, aur Linux par KVM device containers ko nahi deta, isliye yeh setup wahan supported nahi hai. Windows 11 + nested virtualization ya KVM-enabled Linux/cloud host use karein.

## Security

- Web viewer aur RDP default mein sirf `127.0.0.1` par bind hote hain.
- Codespaces port 8006 ko **Private** rakhein.
- Auto-generated password `.env` mein mode `600` ke saath store hota hai.
- Public internet par port 3389 expose na karein; VPN/SSH tunnel use karein.
