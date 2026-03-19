---
title: Star Sailors Ecosystem - Release Dashboard
icon: lucide//gauge
tags:
  - release
  - dashboard
  - ecosystem
  - star-sailors
created: 2026-03-06
sticker: lucide//package-open
---

# Star Sailors Ecosystem - Release Dashboard

## Overall
- Batch: `v0 feedback release`
- Projects: `Client`, `Experiment 1`, `Coral`, `Saily`, `Bumble`
- Tickets created: `5/5`

```dataviewjs
const projects = [
  { tag: "#client", name: "Client" },
  { tag: "#experiment1", name: "Experiment 1" },
  { tag: "#coral", name: "Coral" },
  { tag: "#saily", name: "Saily" },
  { tag: "#bumble", name: "Bumble" }
];

const tasks = (dv.current()?.file?.tasks ?? []).filter((t) =>
  projects.some((p) => (t.text || "").includes(p.tag))
);

let total = 0;
let done = 0;

dv.header(3, "Live Progress");
for (const p of projects) {
  const scoped = tasks.filter((t) => (t.text || "").includes(p.tag));
  const t = scoped.length;
  const d = scoped.filter((x) => x.completed).length;
  total += t;
  done += d;
  const pct = t ? Math.round((d / t) * 100) : 0;
  dv.paragraph(`- **${p.name}:** ${d}/${t} (${pct}%)`);
}

const open = total - done;
const pctAll = total ? Math.round((done / total) * 100) : 0;
dv.paragraph(`**Overall:** ${done}/${total} done, ${open} open (${pctAll}%)`);
```

## By Date
### 2026-03-06
- [x] Dashboard created #release #v0
- [x] Client ticket created (`r6c3k1`) #release #v0 #ux #analytics #feedback #client
- [x] Experiment 1 ticket created (`v4n8ta`) #release #v0 #ux #tutorial #contractor #experiment1
- [x] Coral ticket created (`p9m2qd`) #release #v0 #levels #onboarding #feedback #coral
- [x] Saily ticket created (`k7w1he`) #release #v0 #build #tests #analytics #saily
- [x] Bumble ticket created (`b2q9lu`) #release #v0 #ux #auth #notifications #bumble

## By Project
### Client
- Ticket: `r6c3k1`
- [ ] Release polish pass #release #v0 #ux #analytics #feedback #client

### Experiment 1
- Ticket: `v4n8ta`
- [ ] Mission/UI clarity pass + contractor v0 rules #release #v0 #ux #tutorial #contractor #experiment1

### Coral
- Ticket: `p9m2qd`
- [ ] Starter flow + onboarding lock for first testers #release #v0 #levels #onboarding #feedback #coral

### Saily
- Ticket: `k7w1he`
- [ ] Scope freeze + build/test + analytics verify #release #v0 #build #tests #analytics #saily

### Bumble
- Ticket: `b2q9lu`
- [ ] UI/auth/notifications stabilization for first cohort #release #v0 #ux #auth #notifications #bumble

## Cross-Project Gates
- [ ] Scope locked per project #release #v0
- [ ] Critical UX blockers cleared #release #v0 #ux
- [ ] Analytics + feedback capture verified #release #v0 #analytics #feedback
- [ ] Distribution path confirmed #release #v0
