# 🚀 XLink Setup Guide

Complete guide to set up XLink on your VMs.

---

## 📋 Prerequisites

### 1. Tailscale Account
- Sign up at: https://login.tailscale.com/start
- Free account works perfectly

### 2. Auth Key
- Visit: https://login.tailscale.com/admin/settings/keys
- Click "Generate auth key"
- **Important**: Check ✅ Reusable
- Copy the key (starts with `tskey-auth-`)

---

## ⚡ Quick Install

### One-Line Command
```bash
curl -fsSL https://xasim.me/xlink/public/xlink.sh | sudo bash
```

### Manual Install
```bash
# Download
wget https://xasim.me/xlink/public/xlink.sh

# Make executable
chmod +x xlink.sh

# Run
sudo ./xlink.sh
```

### Optional Overrides

Use environment variables for a custom hostname or tags:

```bash
sudo XLINK_HOSTNAME="myvm" XLINK_TAGS="tag:prod,tag:bots" ./xlink.sh
```

---

## 📝 Step-by-Step Process

### 1. Run Script
```bash
sudo ./xlink.sh
```

### 2. VM Detection
Script automatically detects:
- Hostname
- OS version
- RAM/CPU specs
- Current IPs
- Architecture

### 3. Enter Auth Key
- Paste your Tailscale auth key
- Key format: `tskey-auth-xxxxxxxxx`

### 4. Installation
Script will:
- Download Tailscale
- Install packages
- Connect to network
- Configure XLink

### 5. Get Tailscale IP
- VM gets private IP (100.x.x.x)
- Note this IP for SSH access

---

## 🔧 Post-Installation

### 1. Test Connection
```bash
# From another Tailscale device
ssh root@100.x.x.x
```

### 2. Delete Public IP
- Go to your cloud provider
- Remove/delete public IP
- **Save $3/month!**

### 3. Update DNS (Optional)
```bash
# Add to /etc/hosts on other devices
100.x.x.x  myvm.local
```

---

## 🌐 Multi-VM Setup

### For Multiple VMs:
1. Run script on each VM
2. Use same auth key (reusable)
3. Each gets unique Tailscale IP
4. All VMs can communicate

### Example Network:
```
VM1: 100.64.0.1
VM2: 100.64.0.2  
VM3: 100.64.0.3
```

---

## 🔍 Verification

### Check Tailscale Status
```bash
tailscale status
```

### Check IP
```bash
tailscale ip -4
```

### Test Connectivity
```bash
# From another Tailscale device
ping 100.x.x.x
```

---

## 🛠️ Troubleshooting

### Script Fails?
```bash
# Check internet connection
curl -I google.com

# Check permissions
sudo ./xlink.sh
```

### Can't Connect?
```bash
# Restart Tailscale
sudo systemctl restart tailscaled

# Check firewall
sudo ufw status
```

### Wrong IP?
```bash
# Get correct IP
tailscale ip -4

# Reconnect
tailscale up
```

---

## 📁 File Locations

- **Install**: `/opt/xlink/`
- **Config**: `/etc/xlink/config.json`
- **Logs**: `/var/log/tailscaled.log`

---

## 🔄 Uninstall

```bash
# Remove Tailscale
sudo tailscale down
sudo apt remove tailscale

# Remove XLink
sudo rm -rf /opt/xlink /etc/xlink
```

---

## 💡 Tips

- Use descriptive hostnames
- Keep auth key secure
- Monitor Tailscale admin panel
- Test before deleting public IP

---

## 🆘 Support

- 📧 Issues: GitHub Issues
- 🌐 Website: https://xasim.me/xlink
- 📚 Docs: https://xasim.me/xlink/docs
