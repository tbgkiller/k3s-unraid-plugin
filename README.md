# NemoClaw Unraid Template Project

**Project Goal:** Create an easy-to-install NemoClaw deployment for Unraid users

**Created:** 2026-03-24  
**Owner:** Dustin (TBG_Killer)  
**Assistant:** OZ ⚙️

## 🎯 Overview

NemoClaw is NVIDIA's enterprise-grade secure wrapper for OpenClaw, providing:
- Enhanced security (Landlock, seccomp, network isolation)
- NVIDIA OpenShell runtime
- Sandbox orchestration via k3s
- Network policy enforcement
- Inference routing and monitoring

Currently, NemoClaw requires manual installation. This project aims to make it accessible to Unraid users via Community Applications.

## 🏗️ Architecture Decision

**Two-Part Solution:**

### Part 1: k3s Unraid Plugin
- Installs k3s on Unraid host
- Manages k3s as a system service
- Provides web UI for status/management
- Submitted to Community Applications

### Part 2: NemoClaw Docker Template
- **Depends on:** k3s-plugin
- Uses existing k3s cluster
- Manages NemoClaw sandboxes
- Easy configuration via Unraid UI
- Submitted to Community Applications

**Why this approach:**
- ✅ Clean separation (k3s = system, NemoClaw = app)
- ✅ Familiar Unraid pattern (plugin dependencies)
- ✅ Easy updates and uninstall
- ✅ Can support other k3s apps in future
- ✅ Community-friendly

## 📋 Project Phases

### Phase 1: k3s Plugin ⬅️ **CURRENT**
- [ ] Create plugin PLG file
- [ ] Write install script (download k3s binary)
- [ ] Write start/stop scripts
- [ ] Create web UI page (optional)
- [ ] Write uninstall script
- [ ] Test on Unraid server
- [ ] Submit to CA

### Phase 2: NemoClaw Docker Template
- [ ] Research/create Dockerfile (or use official image)
- [ ] Write template XML with k3s dependency
- [ ] Configure environment variables
- [ ] Set up volume mappings
- [ ] Test installation flow
- [ ] Create documentation
- [ ] Submit to CA

### Phase 3: Documentation & Community
- [ ] Create GitHub repositories
- [ ] Write installation guide
- [ ] Create troubleshooting guide
- [ ] (Optional) Make tutorial video
- [ ] Gather feedback
- [ ] Iterate and improve

## 🔧 Technical Requirements

### NemoClaw Requirements
- **CPU:** 4+ vCPU (we have 8 ✅)
- **RAM:** 8-16GB (we have 31GB ✅)
- **Disk:** 20-40GB free (we have 250GB ✅)
- **OS:** Ubuntu 22.04+ (we have 24.04 ✅)
- **Node.js:** 20+ (can install in container)
- **Docker:** Required (Unraid has this ✅)
- **k3s:** Will be provided by plugin

### k3s Details
- Lightweight Kubernetes distribution
- ~40MB binary
- Runs as single process
- Manages container orchestration
- Provides networking between sandboxes

## 🗂️ Project Structure

```
projects/nemoclaw-unraid/
├── README.md (this file)
├── TODO.md (detailed task list)
├── NOTES.md (research and decisions)
├── docs/
│   ├── installation.md
│   ├── troubleshooting.md
│   └── architecture.md
├── phase1-k3s-plugin/
│   ├── k3s-plugin.plg (plugin definition)
│   ├── scripts/
│   │   ├── install.sh
│   │   ├── start.sh
│   │   ├── stop.sh
│   │   └── uninstall.sh
│   └── webui/
│       └── k3s-status.php (optional)
└── phase2-nemoclaw-docker/
    ├── Dockerfile (if building custom)
    ├── template.xml (CA template)
    ├── docker-compose.yml (reference)
    └── scripts/
        └── entrypoint.sh
```

## 🤝 Team

- **Project Lead:** Dustin (architecture, testing, publishing)
- **Main Coordinator:** OZ (research, planning, documentation)
- **Development:** Codex (coding, scripting, file creation)

## 📚 Resources

- NemoClaw GitHub: https://github.com/NVIDIA/NemoClaw
- NemoClaw Docs: https://docs.nvidia.com/nemoclaw/latest/
- OpenShell: https://github.com/NVIDIA/OpenShell
- k3s: https://k3s.io/
- Unraid Plugin Development: https://forums.unraid.net/topic/38619-plug-in-file-install-plugin/

## 🎯 Success Criteria

- [ ] k3s plugin installs cleanly on Unraid
- [ ] k3s service starts/stops reliably
- [ ] NemoClaw template deploys successfully
- [ ] User can create sandboxed assistants
- [ ] Documentation is clear and complete
- [ ] Community feedback is positive
- [ ] Both submitted and approved in CA

---

**Status:** 🟡 In Progress - Phase 1 Starting  
**Last Updated:** 2026-03-24
