# Prosentriq Helm charts

| Chart | What it installs |
|---|---|
| [`prosentriq-agent`](charts/prosentriq-agent) | The Prosentriq Linux sensor (XDP/eBPF engine and bridge) as a DaemonSet on every node, with pod, namespace and image attribution |

The source is published so you can review exactly what runs on your nodes.

## Install

Create an enrollment key in the console (Settings → Sensors). Keep it in a
Secret rather than on the command line:

```bash
kubectl create namespace prosentriq
kubectl -n prosentriq create secret generic prosentriq-enroll --from-literal=enrollKey=psqe_...

git clone https://github.com/PROSENTRIQ/helm-charts
helm install prosentriq-agent ./helm-charts/charts/prosentriq-agent -n prosentriq \
    --set existingSecret=prosentriq-enroll \
    --set interface=eth0
```

From the first release, the chart is also published as an OCI artifact at
`oci://ghcr.io/prosentriq/charts/prosentriq-agent`, and the sensor image at
`ghcr.io/prosentriq/agent`, both signed. See
[PROSENTRIQ/releases](https://github.com/PROSENTRIQ/releases) to verify them.

## What the sensor needs on a node

- Linux with BTF (`/sys/kernel/btf`), for XDP/eBPF
- The host network (XDP attaches to the node's interface; set `interface`) and
  the host PID namespace (process attribution)
- Not privileged, but these capabilities: `BPF`, `PERFMON`, `NET_ADMIN`,
  `SYS_ADMIN`, `SYS_RESOURCE`, `SYS_PTRACE`, `KILL`

Every node starts **observe-only**: the sensor can't block anything until you
change that host's mode in the console.

## Values

| Value | Default | |
|---|---|---|
| `existingSecret` | `""` | Secret with the key `enrollKey` (preferred) |
| `enrollKey` | `""` | The enrollment key itself, if you don't use a Secret |
| `apiBase` | `https://api.prosentriq.com` | Your control plane (self-hosted: your API URL) |
| `interface` | `eth0` | Interface the XDP probe attaches to on every node |
| `image.digest` | `""` | Pin the image by digest (wins over `image.tag`) |
| `tolerations` | all | Runs on every node, including tainted ones |
| `priorityClassName` | `system-node-critical` | |

All values are in [`values.yaml`](charts/prosentriq-agent/values.yaml).

## Licence and contributing

The Prosentriq sensor this chart deploys is commercial software, licensed under
the Prosentriq commercial licence. This repository is a one-way mirror of the
charts in our private repository: issues are welcome; pull requests are applied
there by a maintainer, who credits you with `Co-authored-by:`. Security
problems: see the [security policy](https://github.com/PROSENTRIQ/.github/blob/main/SECURITY.md).
