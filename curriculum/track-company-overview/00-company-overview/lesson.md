# Company Overview

If you're new here, this is everything you need to know about what we do, how we got here, and where you fit in.

## What is Lightning AI?

Lightning AI is a **full-stack AI cloud platform** — from GPU infrastructure through developer tooling and inference. "From GPU to endpoint."

- **Founded in 2019** by William Falcon during his PhD at NYU, while working at Facebook AI Research
- Created **PyTorch Lightning**, a deep learning framework that simplifies neural network training on top of PyTorch
- Built **Lightning AI Studios** — a fully integrated platform for data prep, model development, distributed training, and AI product deployment
- Joined the **PyTorch Foundation board** in 2023
- Enterprise customers include **Cisco, Black Forest Labs, Cursor**
- Currently at **Series C**

## The Merger: Lightning AI + Voltage Park

In **December 2025** (announced January 2026), Lightning AI and **Voltage Park** merged into a single company.

**Why it happened:**

- Lightning had a unified software platform (Studios, inference, managed K8s) but no hardware
- Voltage Park had massive GPU infrastructure and its own software stack, but it wasn't as unified as Lightning's platform
- Enterprise AI adoption requires **hybrid compute** — hyperscalers + private cloud + on-prem — with software to bridge all three
- Together: end-to-end AI platform that competitors can't replicate

**Post-merger:**

- Legal entity: **Lightning AI, Inc.** (fka Voltage Park, Inc.)
- **Lightning AI** = primary customer-facing brand
- **Voltage Park** = infrastructure layer brand
- Both brands remain active during transition

**Leadership:**

| Role | Name |
|------|------|
| CEO | Will Falcon |
| CDO | JP Hennessy |
| VP Product | Neil Bhatt |
| VP Engineering | Noha Alon |

## What is a Neo Cloud?

You'll hear this term a lot. A **neo-cloud** is a non-hyperscaler cloud provider that offers GPU compute — companies like us, Lambda, Nebius, Vultr.

The big three (AWS, GCP, Azure) are hyperscalers. We're the alternative.

**Our differentiator:** We don't just rent GPUs. We sell a **software-enabled platform** on top of the hardware. That's what gives us higher margins and stickier customers than a pure infrastructure play.

**Why it matters for enterprise:** Companies consume AI in a hybrid way — some workloads on hyperscalers, some on private cloud, some on-prem. We're the neo-cloud piece of that mix, and our platform makes it easy to move between providers.

## Products

### Lightning AI Studios (PLG)
Cloud-based platform for building and deploying AI products at scale. Coding on the cloud, multi-node training, distributed data prep, hosting AI web apps. Four tiers: Free, Pro, Teams, Enterprise. This is the product-led growth (PLG) side — users sign up at lightning.ai and start building.

### Reserved Instances
Contract-based dedicated node allocations with SLAs and a Technical Account Manager (TAM) for onboarding. This is the enterprise sales motion — big customers who need guaranteed capacity.

### VPOD (VP On-Demand)
Legacy self-service bare-metal GPU rentals via web dashboard and API. Stripe billing. **Being rolled into the Lightning platform** — you'll still see references to it but it's merging into the unified product.

### Managed Kubernetes (MK8s)
Managed K8s clusters running on GPU nodes. Handles cluster lifecycle management so customers don't have to.

### Managed Slurm
HPC clusters provisioned on top of MK8s for traditional high-performance computing workloads.

### Harbor
The "VP Cloud" platform — API-driven provisioning at cloud.voltagepark.com. Another piece being unified under Lightning.

## Infrastructure

### GPU Servers

| Model | GPUs | Notes |
|-------|------|-------|
| **Dell PowerEdge XE9680** | 8x H100 SXM | Primary fleet |
| **Dell PowerEdge XE9780** | 8x B200 SXM | Newer builds |
| **Nvidia DGX H100** | 8x H100 | Select sites (Lambda-managed) |

### Networking
- **InfiniBand NDR** fabric (Nvidia ConnectX-7 adapters, QM9700 switches)
- **Dell Z9432F / Z9864F** Ethernet switches (SONiC OS)
- **VAST** shared NFS storage
- **Tailscale** VPN for secure access

### Data Centers

| Code | Location | Colo Provider |
|------|----------|---------------|
| **SEA1** | Puyallup, WA | Centeris |
| **SEA2** | Quincy, WA | H5 Data Centers |
| **IAD1** | Sterling, VA | CyrusOne |
| **DFW1** | Allen, TX | CenterSquare |
| **DFW2** | Fort Worth, TX | CenterSquare |
| **SLC1/SLC2** | Bluffdale, UT | Lambda/DataBank |
| **ORD1** | Lisle, IL | CenterSquare |

### Management Tools

| Tool | What It Does |
|------|-------------|
| **Canonical MaaS** | Bare-metal provisioning, DHCP/PXE |
| **Dell iDRAC** | BMC / out-of-band server management |
| **Observium** | Host and device monitoring |
| **UFM** | InfiniBand fabric management |
| **Rootly** | Incident paging and management |
| **Asset Panda** | Hardware inventory tracking |
| **Metabase** | Usage reporting and analytics |

## Teams That Matter to CX

| Team | What They Do | When You Interact |
|------|-------------|-------------------|
| **CX / Tech Support** | Customer-facing support across PLG and infra | That's you |
| **DC Ops** | Physical hardware work — GPU swaps, cable runs, power | TT tickets, maintenance Jira in Operations project |
| **Infra-Ops** | Software/driver/OS level issues on nodes | Software escalations after you've diagnosed |
| **Net-Ops** | InfiniBand, switches, network fabric | IB and network escalations |
| **Customer Onboarding** | New customer provisioning and handover | Enterprise customer setup |

**CX Leadership:**

| Role | Name |
|------|------|
| Head of CX / Product | Spencer Mellon |
| Director | Liv Wenc |
| Manager, APAC | Christian Corpuz |
| Manager, EMEA | Joe Mannix |

## How CX Fits In

CX is the bridge between customers and every internal team. You're the first point of contact regardless of the issue.

**Two ticket streams:**

| Stream | Tool | Customers |
|--------|------|-----------|
| **PLG Support** | Crisp | Lightning AI Studio users (free + paid) |
| **Infra Support** | Plain | Bare-metal / VPOD / enterprise customers |

**Your toolkit:**

| Tool | Purpose |
|------|---------|
| **ToolJet** | Look up Lightning AI user accounts, ban status, credits |
| **sshv** | SSH into customer nodes for diagnosis |
| **Node Toolkit** | Fleet management, log collection, DCGM diagnostics |
| **Crisp** | PLG ticket management |
| **Plain** | Infra ticket management |
| **Jira** | Operations project tickets for DC Ops |

**Where docs live:**
- **Confluence** (voltagepark.atlassian.net) — VP infrastructure, DC ops, runbooks
- **Notion** (notion.so/lightningai) — Lightning product, engineering, company
