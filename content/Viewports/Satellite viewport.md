---
tags:
  - Satellite
  - Viewport
---

#SSF-40 - dialogue about anomalies 
![[Pasted image 20250905202809.png]]

![[Pasted image 20250905132547.png]]

## Planet Inspection Missions

After a player classifies a planet, they can initiate a satellite mission to "continue studying" it. This creates a new mission type (`Satellite-PlanetInspect`) that gradually unlocks planetary stats over time (e.g., every 10 minutes).

These missions use a “grey, fuzzy” placeholder planet config. As time passes, color and data is revealed, based on atmospheric or solar data.

At the end of the mission, users are presented with a screen showing:
- Their classification
- The planet and unlocked stats
- A “Publish” button to complete the mission

This scene should be accessible via the sidebar or from `/next/{classificationId}`.