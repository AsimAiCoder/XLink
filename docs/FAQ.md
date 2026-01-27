# ❓ XLink FAQ

Frequently Asked Questions about XLink.

---

## 🤔 General Questions

### What is XLink?
XLink eliminates the need for public IPs on VMs by using Tailscale's private network, saving $3/VM/month.

### How does it work?
1. Install Tailscale on VM
2. VM gets private IP (100.x.x.x)
3. Access via Tailscale network
4. Delete public IP = Save money

### Is it secure?
Yes! Uses WireGuard encryption, same as Tailscale. More secure than public IPs.

---

## 💰 Cost & Savings

### How much can I save?
- **Per VM**: $3/month = $36/year
- **100 VMs**: $3,600/year
- **1000 VMs**: $36,000/year

### What's the catch?
None! Tailscale is free for personal use (up to 20 devices).

### Any hidden costs?
No. Tailscale free tier covers most use cases.

---

## 🔧 Technical Questions

### Which OS supported?
- Ubuntu/Debian
- CentOS/RHEL
- Most Linux distros

### What about Windows?
Not yet. Linux only for now.

### Does it affect performance?
Minimal impact. WireGuard is very efficient.

### Can VMs talk to each other?
Yes! All VMs on same Tailscale network can communicate.

---

## 🚀 Installation

### Installation fails?
```bash
# Try with sudo
sudo ./xlink.sh

# Check internet
ping google.com

# Check permissions
ls -la xlink.sh
```

### Invalid auth key error?
- Key must start with `tskey-auth-`
- Get from: https://login.tailscale.com/admin/settings/keys
- Must check "Reusable"

### Script hangs?
- Check firewall settings
- Ensure port 41641 is open
- Try different network

---

## 🌐 Network & Access

### Can't SSH after setup?
```bash
# Get Tailscale IP
tailscale ip -4

# SSH with Tailscale IP
ssh root@100.x.x.x
```

### Forgot Tailscale IP?
```bash
# On the VM
tailscale ip -4

# Or check admin panel
# https://login.tailscale.com/admin/machines
```

### Multiple users access?
Share Tailscale network or use subnet routing.

---

## 🔒 Security

### Is it safe to delete public IP?
Yes, once Tailscale is working. Test first!

### What if Tailscale goes down?
You'd lose access. Keep one VM with public IP as backup.

### Can others access my VMs?
No. Only devices on your Tailscale network.

---

## 🛠️ Troubleshooting

### VM not showing in Tailscale admin?
```bash
# Check status
tailscale status

# Reconnect
tailscale up --authkey=YOUR_KEY
```

### Connection timeout?
```bash
# Restart service
sudo systemctl restart tailscaled

# Check logs
sudo journalctl -u tailscaled
```

### Wrong hostname?
```bash
# Set custom hostname
tailscale up --hostname=myvm
```

---

## 📊 Use Cases

### Perfect for:
- Bot farms
- Web scraping
- Development environments
- Microservices
- Data processing

### Not ideal for:
- Public web servers
- High-traffic applications
- Services needing public access

---

## 🔄 Management

### How to update?
```bash
# Update Tailscale
sudo tailscale update

# Re-run XLink script
sudo ./xlink.sh
```

### How to uninstall?
```bash
# Disconnect
sudo tailscale down

# Remove
sudo apt remove tailscale
sudo rm -rf /opt/xlink /etc/xlink
```

### Multiple auth keys?
One reusable key works for all VMs. Or create separate keys.

---

## 🌟 Advanced

### Custom subnets?
Use Tailscale subnet routing feature.

### Load balancing?
Set up behind Tailscale with internal load balancer.

### Monitoring?
Use Tailscale admin panel or integrate with monitoring tools.

---

## 🆘 Still Need Help?

- 🐛 **Bug Reports**: GitHub Issues
- 💬 **Questions**: GitHub Discussions  
- 📧 **Contact**: xasim.me
- 📚 **Docs**: https://xasim.me/xlink/docs

---

## 🎯 Quick Answers

**Q: Does it work with Docker?**  
A: Yes! Tailscale works with containers.

**Q: IPv6 support?**  
A: Yes, Tailscale supports IPv6.

**Q: Can I use custom domains?**  
A: Yes, with Tailscale MagicDNS.

**Q: Works with Kubernetes?**  
A: Yes, Tailscale has K8s operator.

**Q: Free forever?**  
A: Tailscale free tier is permanent for personal use.
