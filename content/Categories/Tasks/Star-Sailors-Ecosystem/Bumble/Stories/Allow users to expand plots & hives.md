---
tags:
  - Story
  - Bumble
  - Hive
type: story
Project:
  - Bumble
projects:
  - Bumble
story: Allow users to expand plots & hives
status:
  - completed
segment: Initial Bumble Setup/Refactor
sticker: lucide//filter
pr:
icon: lucide//list-checks
---

 
1. Expand page shows current level & available perks (e.g. expansions)
2. If the user has an available perk, they can create a new page - this is saved for the user
3. User can also increase number of plots per page (each page is referred to as a "Greenhouse" (maybe a better name for that exists...somewhere??))


### 🚩 Actionable Tasks (Generated 2025-12-28)

- [x] #Bumble #Greenhouse #UI #Layout #2025-12-30 🆔 9x2j4p
	**Consistent height and width for all plot pages**
	Start: 2025-12-30
	Due: 2025-12-30
	
- [x] #Bumble #Greenhouse #Soil #ID #2025-12-30 🆔 7qk8vn
	**Each soil plot has a unique numerical id**
	Start: 2025-12-30
	Due: 2025-12-30
	
- [x] #Bumble #Greenhouse #UI #Bug #2025-12-30 🆔 4b6wzq
	**Bug: Remove duplicate down arrow button**
	Start: 2025-12-30
	Due: 2025-12-30
- [x]  #Bumble #Greenhouse #UI #Bug #2025-12-30 🆔 ctbgk8 ✅ 2025-12-30
	**Bug: Sprites other than wheat not showing**
	Start: 2025-12-30
	Due: 2025-12-30
	
- [x]  #Bumble #Hive #Greenhouse #Farming #Expansion #Progression #2025-12-29 🆔 tnag47 ✅ 2025-12-29
  **Define and document the perks available for plot/greenhouse expansion.**  
  Start: 2025-12-28  
  Due: 2026-01-05
Fairly straightforward - users will get one new plot region at level 3, another new region at level 7, etc.
I think limiting the level upgrades to level 7 for the first demo would suffice for even any potential power users.

* [x] Remove Godot build from Bumble codebase #2025-12-29 🆔 lbfdbn ✅ 2025-12-29

- [x]  #Bumble #Hive #Greenhouse #Farming #Expansion #UX #2025-12-29 🆔 wyf429 ✅ 2025-12-29
  **Implement UI to show current level and available perks for each greenhouse.**  
  Start: 2025-12-28  
  Due: 2026-01-07
Scope - we'll show the level number in the header, this will then be clickable to show perks and total experience points & breakdown.
When the user levels up, we'll see a dedicated animation page.


- [x]  #Bumble #Hive #Greenhouse #Farming #Expansion #Progression #2025-12-29 🆔 3ca1qw ✅ 2025-12-29
  **Develop logic to allow users to create a new greenhouse page when a perk is available.**  
  Start: 2025-12-28  
  Due: 2026-01-10
We'll say that a new plot region costs 20, then 50, then 100 coins. And they obviously can't be added UNTIL the user has unlocked the perk by virtue of reaching a new level.


- [x]  #Bumble #Greenhouse #Farming #UX #2025-12-29 🆔 l8nkin ✅ 2025-12-30
  **Enable increasing the number of plots per greenhouse and persist user changes.**  
  Start: 2025-12-28  
  Due: 2026-01-12
Just need to make sure that all the above functionality is saved to local storage


- [x]  #Bumble #Hive #Greenhouse #Farming #Expansion #Progression 🆔 sthx3g ✅ 2025-12-29 
  **Define and document the perks available for plot/greenhouse expansion.**  
  Start: 2025-12-28  
  Due: 2026-01-05

## Navigation
- [[content/Categories/_Index|Categories Index]]
- [[content/Categories/Tasks/index|Tasks Index]]
- [[content/Categories/Tasks/Star-Sailors-Ecosystem/Bumble/Stories/index.md|Tasks - Star-Sailors-Ecosystem/Bumble/Stories Index]]
