---

kanban-plugin: board

---

**Original sprint goal**
 📌 Sprint Theme
“Refining core loops, improving dashboard navigation, and laying groundwork for research & notifications expansion.”
 **User Stories**

 **1. Consensus & Discussion**

> _As a player, I want to participate in naming and discussing discoveries so that I feel ownership and recognition for my contributions._

- **Tasks**
    - Update **Planet Naming** logic to allow community consensus instead of anomalies.content
    - Add simple vote/comment integration for naming suggestions (connected to existing voting)
    - UI tweak: Show name voting panel in classification detail view
---
**2. Research & Progression Flow**

> _As a player, I want to see my discoveries progress from detection to detailed study so I understand the value of my work._
- **Tasks**
    - Map out project-specific “next steps” (Planet Hunters, DMP, Cloudspotting, Jovian Vortex) in Obsidian
        - Example: **Planet Hunters** → Deploy telescope → Classify → Study radius/mass → Atmosphere scan (satellite)
        - Example: **DMP** → Detect asteroid → Identify active features → Archive entry
    - Add placeholder “Next Step” indicators in classification view
    - Prepare UI slots for future “post-classification tasks”
---
**3. Checkback Reminders**

> _As a player, I want timely notifications when new actions are available so I return regularly._

- **Tasks**
    - Extend notifications to satellites (ready to redeploy / completed scan)
    - Implement pipeline for gradual linked_anomalies unlock
        - Subtask: Backend schedule logic (unlock X anomalies/day per user)
        - Subtask: Display “Next anomaly in: Xh Ym” countdown in viewport
    - Weekly notification for telescope redeploy (already working for structures — extend scope)
---
**4. UI Improvements**

> _As a player, I want the interface to be clear, responsive, and visually engaging so I enjoy using it on all devices._

- **Tasks**
    - Fix **ActivityHeader** layout on mobile
    - Update **Telescope Viewport** to:
        - Only show linked_anomalies[anomalies] and classifications
        - Animate anomalies moving based on speed property
    - Add minor visual flair to viewports (ambient animations, background motion)
    - Update section/page routing system:
        - Sub-layout for each section
        - Each section opens in dedicated page with expandable UI blocks

---

**5. Obsidian-first Planning**

> _As a dev, I want all planning & docs in Obsidian so I can track and evolve the game coherently._
- **Tasks**
    - Create Kanban board in Obsidian for sprint
    - Add “Research Flow” diagrams for each project
    - Add “UI Routes & Sections” outline
---


## Icebox



## Todo

* [ ] Allow tasks #Frontend #SSG-281  to be shown in multiple boards #Frontend #SSG-281 #In-Progress
* [ ] Setup Sprint board #Frontend #SSG-281 #Todo

## In-Progress



## Done





%% kanban:settings
```
{"kanban-plugin":"board","list-collapse":[false,false,false,false]}
```
%%