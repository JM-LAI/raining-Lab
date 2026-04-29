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

You'll hear this term a lot. Understanding it is key to understanding where we sit in the market.

### The Cloud Landscape

The GPU cloud market has three tiers:

| Tier | Who | Examples | Pros | Cons |
|------|-----|----------|------|------|
| **Hyperscalers** | The big three | AWS, GCP, Azure | Massive scale, broad services, enterprise trust | Expensive GPU compute, long waitlists for H100s, lock-in |
| **Neo-clouds** | GPU-focused providers | **Lightning AI**, Lambda, Nebius, CoreWeave, Vultr | Purpose-built for AI, better GPU pricing, faster access | Smaller ecosystem, less brand recognition |
| **On-prem** | Customer-owned | Private data centers | Full control, data sovereignty | Massive capex, slow to scale, maintenance burden |

**We are a neo-cloud.** But not just any neo-cloud — we're the one with a full software platform on top.

### Why Neo-Clouds Exist

Hyperscalers weren't built for AI training. They were built for web apps, databases, and general compute. When the AI boom hit, GPU demand exploded and hyperscalers couldn't keep up:

- **Waitlists** — companies waiting months for H100 allocations on AWS/GCP
- **Price** — hyperscaler GPU pricing is significantly higher than dedicated providers
- **Overhead** — you're paying for services you don't need (load balancers, CDNs, managed databases) when all you want is raw GPU

Neo-clouds fill that gap. We provide **dedicated GPU infrastructure** optimized specifically for AI workloads — training, fine-tuning, and inference.

### Our Differentiator: Software + Hardware

Most neo-clouds are just GPU rental companies. You get bare metal, you figure out the rest.

We're different because we own **both sides**:

- **Hardware layer (Voltage Park)** — we own and operate the physical GPU infrastructure across multiple data centers
- **Software layer (Lightning AI)** — we provide the platform that makes that hardware useful: managed clusters, studios, inference, deployment

This is the "from GPU to endpoint" pitch. A customer can go from raw H100s to a deployed AI product without leaving our ecosystem.

**Why this matters commercially:**

- **Higher margins** — software on top of hardware means we're not competing purely on GPU price
- **Stickier customers** — once they're using our platform, switching costs are high
- **Broader TAM** — we can serve everyone from individual developers (PLG, free tier) to Fortune 100 enterprises (reserved instances, managed K8s)

### How Enterprise AI Actually Works

Enterprise companies don't put all their AI workloads in one place. They use a **hybrid compute** model:

- **Hyperscaler** for non-GPU workloads, data lakes, existing infra
- **Neo-cloud (us)** for GPU-heavy training and inference at better price/performance
- **On-prem** for sensitive data, regulatory requirements, or where they already have hardware

Our platform is **cloud-agnostic** — it can orchestrate workloads across all three. That's the strategic vision. The customer uses Lightning AI as the control plane, and we handle where the compute actually runs.

### The Competition

| Competitor | What They Offer | How We're Different |
|-----------|----------------|-------------------|
| **CoreWeave** | GPU cloud, K8s-native | No integrated developer platform, pure infra play |
| **Lambda** | GPU cloud + workstations | Smaller scale, less enterprise focus |
| **Nebius** | GPU cloud (Yandex spin-off) | No unified software platform |
| **Together AI** | Inference + fine-tuning API | No bare-metal, no own hardware |
| **AWS/GCP/Azure** | Everything | GPU-expensive, not purpose-built for AI |

Our moat is that nobody else has the full stack: own hardware + own data centers + developer platform + managed services + inference. That's what the merger created.

## Products & Services

We sell AI compute and tooling across different consumption models. Understanding what each product is helps you route customer questions correctly.

### Lightning AI Studios (PLG)

The self-service platform at **lightning.ai**. Users sign up, get a cloud environment, and start building.

**What it includes:**

- **Studios** — cloud-based dev environments with GPU access. Think VS Code in the browser with a GPU attached
- **Multi-node training** — scale training across multiple GPUs/nodes without managing infrastructure
- **LitData** — distributed data preparation at scale
- **Lightning Inference** — deploy models as API endpoints
- **App hosting** — deploy and share AI web applications

**Pricing tiers:**

| Tier | Credits | Who It's For |
|------|---------|-------------|
| **Free** | 15 credits/month (~80 GPU hours) | Individual developers, students, hobbyists |
| **Pro** | 40 credits/month | Professional developers, researchers |
| **Teams** | Per-seat pricing | Small-to-mid teams collaborating on projects |
| **Enterprise** | Custom | Large organizations with compliance/security needs |

This is the **product-led growth (PLG)** side of the business — high volume, lower touch, users self-serve. PLG support tickets come through **Crisp**.

### Reserved Instances (Enterprise)

Contract-based dedicated node allocations for large customers. This is the **enterprise sales motion**.

**What they get:**

- Dedicated GPU nodes (not shared)
- SLAs on uptime and support response
- Technical Account Manager (TAM) for onboarding and ongoing support
- Custom networking and storage configurations
- Priority maintenance scheduling

**Key customers on reserved instances:** Cisco, Black Forest Labs, Cursor, and others. These are multi-month or multi-year contracts. When these customers have issues, they expect fast responses — they're paying for it.

### Managed Kubernetes (MK8s)

Managed K8s clusters running on our GPU nodes. We handle the cluster lifecycle — provisioning, scaling, upgrades, monitoring — so the customer focuses on their workloads.

**Why customers want this:** Running Kubernetes on GPU infrastructure is painful. GPU scheduling, driver management, fabric manager, InfiniBand CNI plugins — it's a lot. We abstract that away.

### Managed Slurm

HPC-style clusters for customers who prefer traditional job scheduling over Kubernetes. Provisioned on top of MK8s infrastructure. Common in research and academic settings.

### VPOD (VP On-Demand) — Legacy

Self-service bare-metal GPU rentals via web dashboard and API with Stripe billing. **Being rolled into the Lightning platform** — you'll still see references to it in tickets and docs, but it's merging into the unified product.

### Harbor — Legacy

The original "VP Cloud" platform for API-driven provisioning at cloud.voltagepark.com. Also being unified under Lightning.

### AI Factory

Newer offering for dedicated GPU factory deployments at scale. Behind feature flags currently — you'll hear about it but it's not fully GA yet.

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
