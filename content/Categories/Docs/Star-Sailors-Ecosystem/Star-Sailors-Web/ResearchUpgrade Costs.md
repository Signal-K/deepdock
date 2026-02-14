---
aliases:
  - Research/Upgrade Costs
sticker: lucide//syringe
tags:
  - Research
  - Upgrades
  - Stardust
icon: lucide//file-text
---

[[Research - Mission Progression Flow]]

## Increasing anomalies found/linked per deployment
The first upgrade will increase the capacity by 2 per deployment, and will cost 10 stardust. The cost will increase by 10 for every level. We will have separate upgrades available for the Telescope, Rover & Satellites.

## Increasing quantities of tools/automatons
Telescopes can not be increased, but users can add more types, which will introduce a weighting towards certain `anomalyType` values when deploying. This is a #future feature.

Users will be able to increase the number of satellites. This is a feature I will implement in #SSG-290 sprint. However, users will also be able to edit their satellites and specialisation/setup - this is a #future feature. Increasing the number of satellites will allow for more locations to be visited. The flow for this behaviour is the sidebar in the satellite #Deploy page will show the number of satellites, and the user will be able to select multiple planets corresponding to the number of satellites they "have". There is no requirement for user's selection # to match the # of satellites. Once a deployment occurs, they can't select other planets or deploy "undeployed" satellites.

For now, users will not be able to increase the number of rovers.


I'm going to organise the naming structure like this:
1. Telescope - starting with a radio telescope. Specialisation: gravity-based anomalous events. Add a visual light telescope to your array, this will increase your anomalies per deployment to 6. Level 3 adds a microscope telescope to your array, increasing anom/deployment to 8.
2. Satellite - pretty simple, just add more satellites.

## Navigation
- [[content/Categories/_Index|Categories Index]]
- [[content/Categories/Docs/index|Docs Index]]
- [[content/Categories/Docs/Star-Sailors-Ecosystem/Star-Sailors-Web/index.md|Docs - Star-Sailors-Ecosystem/Star-Sailors-Web Index]]
