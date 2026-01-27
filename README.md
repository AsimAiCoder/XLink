# 🚀 XLink

**Link Your VMs, Ditch Public IPs**

Save $3/VM/month by eliminating public IPs while maintaining secure access through Tailscale.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub Pages](https://img.shields.io/badge/demo-live-success)](https://asimaicoder.github.io/xlink)

---

## ✨ Features

- 💰 **Save Money** - Eliminate $3/VM/month public IP costs
- 🔒 **Secure** - WireGuard-based encryption
- ⚡ **Fast Setup** - 2-minute installation
- 🎨 **Beautiful UI** - Modern, responsive design
- 📊 **VM Details** - Complete system information
- 🌐 **No Database** - Simple, stateless design

---

## 🚀 Quick Start

### One-Line Install

```bash
curl -fsSL https://asimaicoder.github.io/xlink/public/xlink.sh | sudo bash
```

### Manual Install

```bash
# Download script
wget https://asimaicoder.github.io/xlink/public/xlink.sh

# Make executable
chmod +x xlink.sh

# Run
sudo ./xlink.sh
```

### Optional Overrides

Set a custom hostname or tags before running:

```bash
sudo XLINK_HOSTNAME="myvm" XLINK_TAGS="tag:prod,tag:bots" ./xlink.sh
```

---

## 📋 Prerequisites

1. **Tailscale Account** (Free)
   - Sign up: https://login.tailscale.com/start

2. **Auth Key** (Required)
   - Get from: https://login.tailscale.com/admin/settings/keys
   - Click: "Generate auth key"
   - Check: ✅ Reusable

---

## 💡 How It Works

```
1. User runs script on VM
2. Script detects VM details
3. User enters Tailscale auth key
4. Script installs Tailscale
5. VM gets private IP (100.x.x.x)
6. User deletes public IP
7. Access VM via Tailscale IP
8. Save $3/month! 🎉
```

---

## 📊 Cost Savings

| Setup | Monthly Cost | Annual Cost |
|-------|--------------|-------------|
| **With Public IP** | $7 | $84 |
| **With XLink** | $4 | $48 |
| **Savings** | **$3** | **$36** |

For 100 VMs: **Save $3,600/year!**

---

## 🎯 Use Cases

- 🤖 Bot farms
- 🕷️ Web scraping clusters
- 🔬 Development environments
- 🚀 Microservices
- 📊 Data processing nodes

---

## 🛠️ Tech Stack

- **Frontend**: HTML, CSS, JavaScript
- **Backend**: Bash script
- **VPN**: Tailscale (WireGuard)
- **Hosting**: GitHub Pages

---

## 📖 Documentation

- [Setup Guide](docs/SETUP.md)
- [FAQ](docs/FAQ.md)
- [Contributing](docs/CONTRIBUTING.md)
- [Deployment](docs/DEPLOYMENT.md)
- [Azure Functions](docs/AZURE_FUNCTIONS.md)

---

## 🤝 Contributing

Contributions welcome! Please read [CONTRIBUTING.md](docs/CONTRIBUTING.md) first.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file.

---

## 👨💻 Author

**Asim**
- Website: [xasim.me](https://xasim.me)
- GitHub: [@AsimAiCoder](https://github.com/AsimAiCoder)

---

## ⭐ Support

If you find XLink useful, please star this repo!

---

## 🔗 Links

- 🌐 Website: https://xasim.me/xlink
- 📚 Docs: https://xasim.me/xlink/docs
- 🐛 Issues: https://github.com/AsimAiCoder/xlink/issues
