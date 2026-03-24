# Project Notes - NemoClaw Unraid

## 2026-03-24: Initial Planning Session

### Context
- Dustin wants to deploy NemoClaw on Unraid server
- Prefers Docker over VMs for resource efficiency and scalability
- Has experience creating Unraid templates for game servers
- Current setup: Ubuntu VM running OpenClaw (working well)

### Key Decisions

**Architecture Choice: Two-Part Solution**
- **Part 1:** k3s Unraid Plugin (system-level)
- **Part 2:** NemoClaw Docker Template (application-level)

**Rationale:**
- k3s is a system service, not a user app
- Follows Unraid best practices (like nvidia-driver plugin)
- Clean separation of concerns
- Easy dependency management via CA
- Can support future k3s-based apps

**Rejected Approaches:**
1. ❌ "Fat Container" with k3s inside - Too complex, nested containers
2. ❌ Manual install script - Not user-friendly for Unraid
3. ❌ docker-compose only - Still needs k3s orchestration

### Technical Understanding

**What is k3s?**
- Lightweight Kubernetes (~40MB binary vs 1GB+ for full k8s)
- Runs as single process
- Perfect for edge/IoT/small deployments
- NemoClaw uses it to orchestrate multiple isolated sandboxes

**NemoClaw Architecture:**
```
Host (Unraid)
└── k3s cluster
    ├── OpenShell Gateway (NVIDIA runtime)
    ├── Sandbox: my-assistant (isolated OpenClaw)
    ├── Sandbox: work-assistant (optional, separate)
    └── (can create more as needed)
```

**Security Layers:**
- **Landlock** - Filesystem access control
- **seccomp** - System call filtering
- **netns** - Network namespace isolation
- **OpenShell** - All traffic/inference routed through NVIDIA gateway

**Why This Is Complex:**
- Not just "OpenClaw in a container"
- Multi-container orchestration required
- Security enforcement at multiple layers
- Network policy management
- Inference routing

### Resources & Requirements

**Dustin's Server (UbuntuClaw VM):**
- ✅ 31GB RAM (exceeds 8-16GB requirement)
- ✅ 8 vCPUs (exceeds 4+ requirement)
- ✅ 250GB disk (exceeds 20-40GB requirement)
- ✅ Ubuntu 24.04 (exceeds Ubuntu 22.04+ requirement)

**NemoClaw is Alpha Software:**
- Released March 16, 2026 (8 days ago!)
- APIs subject to breaking changes
- Not production-ready yet
- Perfect time for early adoption / template creation

### Research Links

- NemoClaw GitHub: https://github.com/NVIDIA/NemoClaw
- NemoClaw Docs: https://docs.nvidia.com/nemoclaw/latest/
- k3s Official: https://k3s.io/
- OpenShell: https://github.com/NVIDIA/OpenShell
- Unraid Forum Plugin Dev: https://forums.unraid.net/topic/38619-plug-in-file-install-plugin/

### Team Structure

**Hybrid Approach:**
- **Dustin** - Project lead, testing, decision maker
- **OZ (me)** - Project coordination, research, documentation
- **Codex** - Coding agent for script/file development

**Why Codex?**
- Dustin heard great things about it
- Good for focused coding tasks
- Can work independently on file creation
- Requires PTY mode (will run on Ubuntu VM)

### Next Actions

1. Create plugin structure
2. Research Unraid plugin examples
3. Spawn Codex to start Phase 1 development
4. Test k3s installation approach

---

## Future Considerations

- Could become the "NemoClaw-Unraid guy" in community
- Other users might build on this foundation
- k3s plugin could enable other Kubernetes apps on Unraid
- Template could be template (pun intended) for other complex multi-container apps

---

## Questions to Answer

- [ ] What k3s version is compatible with NemoClaw?
- [ ] Does NVIDIA publish official NemoClaw Docker images?
- [ ] What are the minimal permissions needed for k3s on Unraid?
- [ ] How to handle k3s updates without breaking NemoClaw?
- [ ] Best way to present NemoClaw configuration to Unraid users?

---

**Status:** Ready to start Phase 1 development with Codex
