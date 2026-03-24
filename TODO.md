# TODO - NemoClaw Unraid Project

**Last Updated:** 2026-03-24

## 🟢 Phase 1: k3s Plugin (COMPLETED - 2026-03-24)

### Research & Planning
- [x] Research NemoClaw architecture
- [x] Understand k3s requirements
- [x] Decide on two-part approach (plugin + template)
- [x] Study existing Unraid plugin examples
- [x] Determine k3s version compatibility (v1.35.2+k3s1 stable)
- [x] Map out k3s installation requirements

### Plugin Development ✅ COMPLETE
- [x] Create k3s-plugin.plg structure
- [x] Write metadata (name, author, version, etc.)
- [x] Define download URL for k3s binary
- [x] Create install script
  - [x] Download k3s binary to /usr/local/bin/
  - [x] Set executable permissions
  - [x] Create k3s config directory
  - [x] Generate kubeconfig
- [x] Create start script
  - [x] Start k3s server
  - [x] Wait for readiness
  - [x] Verify cluster is healthy
- [x] Create stop script
  - [x] Gracefully stop k3s
  - [x] Clean up processes
- [x] Create uninstall script
  - [x] Stop k3s
  - [x] Remove binary
  - [x] Remove config files
  - [x] Clean up any remaining resources

### Testing
- [ ] Test install on Unraid server
- [ ] Verify k3s starts successfully
- [ ] Check kubeconfig is valid
- [ ] Test stop/restart
- [ ] Test uninstall (leaves system clean)
- [ ] Check resource usage (CPU/RAM)

### Documentation (Phase 1)
- [ ] Write installation instructions
- [ ] Document configuration options
- [ ] Create troubleshooting section
- [ ] Add screenshots/examples

### Optional Enhancements
- [ ] Create web UI status page
- [ ] Add version checking/updates
- [ ] Implement health checks
- [ ] Add logging

---

## 🟡 Phase 2: NemoClaw Docker Template (NEXT)

### Research
- [ ] Check if NVIDIA publishes official NemoClaw image
- [ ] Understand NemoClaw CLI installation
- [ ] Map out required environment variables
- [ ] Determine volume mount requirements
- [ ] Research port mappings needed

### Dockerfile Development (if needed)
- [ ] Choose base image (Ubuntu 22.04+)
- [ ] Install Node.js 20+
- [ ] Install OpenShell binary
- [ ] Install NemoClaw CLI
- [ ] Create entrypoint script
- [ ] Test image build
- [ ] Optimize image size

### Template Creation
- [ ] Create template.xml structure
- [ ] Define dependency on k3s-plugin
- [ ] Configure repository/image
- [ ] Set up volume mappings
  - [ ] /config for persistence
  - [ ] /workspaces for sandboxes
- [ ] Define environment variables
  - [ ] API keys
  - [ ] Model selection
  - [ ] Network policies
- [ ] Configure port mappings (18789 default)
- [ ] Add descriptions and help text

### Testing
- [ ] Test with k3s plugin installed
- [ ] Verify dependency checking works
- [ ] Test first-run configuration
- [ ] Create test sandbox
- [ ] Verify persistence across restarts
- [ ] Test updates

### Documentation (Phase 2)
- [ ] Write installation guide
- [ ] Document configuration options
- [ ] Create usage examples
- [ ] Troubleshooting guide

---

## 🟢 Phase 3: Polish & Release

### GitHub Setup
- [ ] Create k3s-unraid-plugin repository
- [ ] Create nemoclaw-unraid-template repository
- [ ] Write README files
- [ ] Add LICENSE files
- [ ] Set up issue templates

### Community Applications Submission
- [ ] Submit k3s plugin to CA
- [ ] Submit NemoClaw template to CA
- [ ] Respond to reviewer feedback
- [ ] Make required changes
- [ ] Get approved!

### Community Engagement
- [ ] Post announcement on Unraid forums
- [ ] Create support thread
- [ ] (Optional) Make tutorial video
- [ ] Gather user feedback
- [ ] Plan improvements

---

## 📝 Notes

- k3s binary is ~40MB
- NemoClaw sandbox image is ~2.4GB compressed
- Minimum 8GB RAM recommended (we have 31GB)
- Requires Docker (Unraid already has this)
- Alpha software - expect changes

---

## 🎯 Immediate Next Steps

1. Study existing Unraid plugin structure
2. Create k3s-plugin.plg file
3. Write install script
4. Test on Unraid VM

---

**Assigned to Codex:** Phase 1 - k3s Plugin Development
