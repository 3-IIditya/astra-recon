# 🚀 A.S.T.R.A

### **Advanced Security Testing & Reconnaissance Arsenal**

**From subdomains to secrets — silently ⚙️**



---

## 🧠 Overview

**A.S.T.R.A** is an automated reconnaissance framework built for security enthusiasts, bug bounty hunters, and red teamers.
It chains multiple industry-standard tools into a streamlined workflow — turning scattered recon steps into a single, powerful execution.

Think of it as your silent digital scout… mapping the terrain before the attack begins.

---

## ⚙️ Features

* 🔍 **Subdomain Enumeration** (multi-tool aggregation)
* 🌐 **Live Host Detection**
* 🚪 **Port Scanning** (Naabu + Nmap)
* 📸 **Visual Recon** (screenshots with Gowitness)
* 🔗 **URL Gathering** (gau + hakrawler)
* 🧬 **Technology Fingerprinting**
* 💥 **Vulnerability Scanning** (Nuclei)
* 🎲 **Random CLI Banners**
* ⚡ Parallel execution for speed

---

## 🛠️ Tools Used

A.S.T.R.A integrates:

* `sublist3r`
* `subfinder`
* `assetfinder`
* `httprobe`
* `httpx`
* `naabu`
* `nmap`
* `gowitness`
* `gau`
* `hakrawler`
* `wappalyzer`
* `whatweb`
* `nuclei`
* `jq`

---

## 📦 Installation

```bash
git clone https://github.com/yourusername/A.S.T.R.A.git
cd A.S.T.R.A
chmod +x install.sh
sudo ./install.sh
```

---

## 🚀 Usage

```bash
astra example.com
```

---

## 📁 Output Structure

```
target/
├── recon/
│   ├── subdomains.txt
│   ├── hosts_alive.txt
│   └── clean_target.txt
│
├── ports/
│   ├── naabu.txt
│   └── nmap.txt
│
├── urls/
│   └── gathered_urls.txt
│
├── screenshots/
│
├── technologies/
│   ├── wappalyzer.txt
│   └── whatweb.txt
│
└── vulns/
    └── nuclei.txt
```

---

## 🎨 CLI Experience

* Random ASCII banners 🎲
* Color-coded output
* Clean step-by-step execution logs

---

## ⚡ Performance Notes

* Uses background jobs (`&`) + `wait` for concurrency
* Optimized sorting & deduplication (`sort -u`)
* Parallel tech detection via `xargs -P`

---

## ⚠️ Requirements

* Linux (Kali recommended)
* Go (for tool installation)
* Python3
* Root privileges (for installer)

---

## 🧩 Roadmap

* [ ] Directory brute forcing module
* [ ] Smart rate limiting
* [ ] Auto-update system
* [ ] JSON + HTML reporting
* [ ] Severity-based vuln summaries

---

## 🤝 Contributing

Pull requests are welcome.
If you’ve got ideas that make recon faster, stealthier, or smarter — bring them in.

---

## ⚠️ Disclaimer

This tool is intended for **educational and authorized testing purposes only**.
Do not use it against systems without proper permission.

---

## 👨‍💻 Author

**Aditya Pandey**

---

## 🌌 Final Thought

> Recon isn’t just scanning… it’s storytelling.
> A.S.T.R.A writes the first chapter — quietly.

---
