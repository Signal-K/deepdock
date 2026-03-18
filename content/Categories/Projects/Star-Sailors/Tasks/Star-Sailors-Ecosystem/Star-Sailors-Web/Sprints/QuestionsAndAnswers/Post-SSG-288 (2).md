---
tags:
  - SSG-288
  - Sprints
  - Planning
  - Questions
sticker: lucide//bean-off
icon: lucide//list-checks
---

GPT Questions:

---

## **🔍 50+ Questions to Refine Stories, Features & Growth Strategy**

  

### **🧭 GAMEPLAY & FEATURE DEPTH**

1. Which of the currently integrated projects (e.g. Planet Hunters, AI4M, Planet Four, etc.) are the most replayed or revisited by users?
Answer: it seems like Planet Hunters is the most played in the most recent/up-to-date versions, however, I don't really have enough users playing the current versions to really know what projects are most appealing.
When I've spoken to industry professionals, engineers, etc; PlanetHunters seems to be the most interesting - almost everyone understands the concept, and a lot of the other projects in Star Sailors are derived from it (e.g. the second part of Planet Hunters (each mission for a planet identified) involves sending identifying the physical dimensions of the planet. We also replace Mars/Jupiter with the discovered planets as the in-game (fictional) location that the cloud and sublimation anomalies come from). 
In older version of Star Sailors, PH was again the most popular, but at the start of development that was the only project, and even after adding more projects, it was the one that was the most fleshed out.
    
2. How long does it typically take for a user to complete their first classification on each project?
It's pretty simple:
*  They have a list of astronomical anomalies their telescope has discovered, this includes asteroid candidates and (obviously) planet candidates. They would follow a simple tutorial (varying between 3-5 slides consisting of one paragraph each and an image) and then make annotations on the anomaly's image based on their observation (e.g. marking a legitimate transit pattern or event on a lightcurve graph)
* For other projects, it's still the same process - right now, it's all making annotations or textual inputs. So maybe 90-120 seconds to go from the main dashboard, finish the tutorial, and understand what you're looking at
    
3. Are there any current gameplay loops that feel “finished” or fully self-contained from discovery → classification → reward?
Well, all of the projects' classification loops are finished:
*  Planet Hunters & Daily Minor Planet: Users point their telescope at a sector, they "deploy" the telescope. This creates up to 4 (later, we'll have the ability to research telescope improvements so that users can get more anomalies per week) anomalies (of either asteroid or planet type, randomly allocated) that the user can classify. 
* AI4Mars: The user draws 4 waypoints on a topographic map of Mars, and then "deploys" their rover. This then creates a route in Supabase, as time passes, the rover moves along the screen and the user will then be given tasks (like identify hazardous objects or point out the sandy and rocky outcroppings in the photo) to move on to the next waypoint
* Projects accessed via the satellite deployment: Users choose the mission they want to follow and the planet they want to deploy their satellite to, the satellite will then orbit the planet and gradually return data points or anomalies (e.g. cloud data) for the user to classify

The only project that isn't finished is the Sunspot project, right now
    
5. What’s the typical user flow from landing on the homepage to completing their first classification?
The user sees a selection of sections (referred to as "Viewports") which can be expanded (opens the route `/viewports/${viewportSelected`}) and a little bit of text describing what this tool/viewport shows. They then would click a button to "Deploy" or activate the viewport, which involves them selecting a location to focus on, and (depending on the viewport selected) a mission or datatype to focus. The user then gets redirected back to the viewport, which now shows the tool in operation, with a countdown timer until the tool has some data available. The user then clicks on a button to classify data, when it's available.
    
6. Are users incentivised in any meaningful way to **return the next day** or next week?
Well, they can redeploy the tool each week, and it takes time for the tool to acquire new data. That's about it, for now.
Missions/milestones (like weekly tasks, not narrative loop tasks) were previously implemented but are no longer available to the end user.
    
7. Is the current “deploy → classify → post-classify” loop satisfying? What feels missing?
We're stuck where there's not a huge amount to do, beyond choosing a focus target and then classifying. So, I've been forced to add a waiting period between those two steps, otherwise users would whip straight through all the anomalies too quickly. 
Additionally, it provides another thing to research - i.e. shorten the waiting period (this could be described as increasing the speed of the rover, for e.g.)
    
8. Do users have a **clear reason** to explore multiple projects rather than just doing one?
There's no real in-game inventory, so users are really just able to do whatever projects interest them. Some projects have additional missions or data types that are locked behind a progression/tech tree, but there's no requirement (and there shouldn't be) to do everything. If you just want to discover planets, just do that!
    
9. How are research unlocks currently surfaced to the user? Is there a progression that makes sense?
I think so. Mainly it's just a big research CTA section and a link in the navigation. There's not really anything that's functional yet, because I haven't introduced any features to research (they're just labelled "Coming soon"), however the functionality to interpret the user's researched items (by drawing on the `researched` table records for `session.user.id`) has been implemented for quite a while.
    
10. Have you noticed users getting stuck after completing their first few missions/classifications?
Usually, users are getting stuck with the deployment phase, if they're completing classifications usually they drop off as well - but I think that's not because they're getting stuck. There's just not a huge amount to do.
    
11. Does the game currently surface “next actions” (e.g. inspect anomaly, upgrade tool, vote) clearly after each step?
Well, after making a classification users are shown buttons like "Go home" or "Continue", which directs the user to the structure/viewport. So kind of.
    
12. Do anomalies or objects ever evolve/change based on player interaction?
Users will interpret things in different ways, so two users may be given the same photo but make different annotations and thus produce a different landscape on the planet/location.
    
13. Do we track long-term player “careers” — e.g. specialist in a project? Highest-ranked rover pilot?
We don't have a leaderboard yet, but we do have a page that shows the user's total number of classifications/contributions per project (as well as per "scientific discipline" and tool type).

---

### **🧑‍🚀 USER BASE & BEHAVIOR**

13. How many unique users have signed up (guest or full) in the past 2 weeks?
3 guest users, 1 full user
    
14. What % of users ever return after their first visit?
0%
    
15. How many users complete a second mission/classification?
0
    
16. Have any users interacted with more than one project? Which ones?
0
    
17. What projects are most/least popular by engagement?
Telescope missions/deployments (Telescope viewport/tool) - so Planet & Asteroid Hunting
    
18. Have you personally onboarded or watched someone new try Star Sailors recently?
I am in intermittent contact with one early user
    
19. What questions or confusion points come up most often from new users?
> What is deploying? I thought I was finding planets?
    
20. What are your biggest “a-ha” moments from watching users play?
Haven't actually watched anyone play the recent versions, yet.

---

### **🧠 LEARNING & WORLD-BUILDING**

21. Do users understand what real-world data they’re classifying? Where is that explained?
Yes - each deployment screen shows the data type
    
22. How are classification effects on parent data (e.g. lightcurve → planet → traits) explained or visualised?
We have a simple series of tutorials for each project, consisting of 3-5 slides each, one paragraph and image each.
e.g. this is the format used:
```tsx
const tutorialContent = (

<div className="flex flex-col items-start gap-4 pb-4 relative w-full max-w-lg overflow-y-auto max-h-[90vh] rounded-lg">

<div className="p-4 bg-[#2C3A4A] border border-[#85DDA2] rounded-md shadow-md relative w-full">

<div className="relative">

<div className="absolute top-1/2 left-[-16px] transform -translate-y-1/2 w-0 h-0 border-t-8 border-t-[#2C3A4A] border-r-8 border-r-transparent"></div>

{part === 1 && (

<>

{line === 1 && <p className="text-[#EEEAD1]">Hello there! To start your journey, you'll need to discover your first planet.</p>}

{line === 2 && <p className="text-[#EEEAD1]">To determine if a planet is real, you'll need to examine a lightcurve and identify patterns in dips and variations.</p>}

{line === 3 && <p className="text-[#EEEAD1]">Look for regular dips—these often signal a planet passing in front of its star and can confirm its orbit.</p>}

{line === 4 && <p className="text-[#EEEAD1]">Pay attention to the shape of these dips: a sharp, symmetrical dip usually indicates a genuine planet transit...</p>}

{line === 5 && <p className="text-[#EEEAD1]">...While asymmetrical or irregular shapes might suggest something else.</p>}

{line === 6 && <p className="text-[#EEEAD1]">Let's give it a try! Identify the dips in this lightcurve:</p>}

{line < 6 && <button onClick={nextLine} className="mt-4 px-4 py-2 bg-[#D689E3] text-white rounded">Next</button>}

{line === 6 && <button onClick={nextPart} className="mt-4 px-4 py-2 bg-[#D689E3] text-white rounded">Continue</button>}

{line < 6 && (

<div className="flex justify-center mt-4 w-full h-64">

{line === 1 && <img src="/assets/Template.png" alt="Step 1" className="max-w-full max-h-full object-contain" />}

{line === 2 && <img src="/assets/Docs/Curves/Step2.png" alt="Step 2" className="max-w-full max-h-full object-contain bg-white" />}

{line === 3 && <img src="/assets/Docs/Curves/Step1.png" alt="Step 3" className="max-w-full max-h-full object-contain bg-white" />}

{line === 4 && <img src="/assets/Docs/Curves/Step3.png" alt="Step 4" className="max-w-full max-h-full object-contain bg-white" />}

{line === 5 && <img src="/assets/Docs/Curves/Step4.png" alt="Step 5" className="max-w-full max-h-full object-contain bg-white" />}

</div>

)}

</>

)}

{part === 2 && (

<>

{line === 1 && (

<p className="text-[#EEEAD1]">Great job! Once you've identified your planet, you can share your findings with the rest of the space sailors community.</p>

)}

</>

)}

</div>

</div>

</div>

);
```
    
23. Are there any narrative-driven mechanics yet (e.g. mini cutscenes, persistent storylines)?
Not yet. Rover/tool wear & tear, progression/tech improvement using research/tech tree, and navigating and expanding the planet discoveries/classifications is in progress.
    
24. Have you experimented with lore-based delivery of research, missions, or upgrades?
No. I want to keep the current web interface relatively professional; characters and an in-game history is not a blocker to user acquisition right now.
    
25. Could AI4Mars missions involve environmental storytelling? (E.g. you find ruined stations or strange formations)
Look, if storyline & a "used universe" or backstory would improve things, then anything is possible.
    

---

### **✨ ONBOARDING & FIRST HOUR EXPERIENCE**

26. Do users always land in the same project when they first play?
No.
    
27. What determines which missions they see first?
We have a dedicated order of viewports/tools, but all of them are accessible from the home page without scrollinh.
    
28. Are new users required to deploy anything before classifying?
Yes, you can't get data without deploying a tool
    
29. Is it obvious how to navigate between projects, viewports, or dashboards?
I think I'm too close to product to be able to answer this question properly.
    
30. Does the onboarding experience feel like a chore or a discovery?
More like a chore, but that's because there's a lack of true gameplay mechanics right now, I think. TBH, it's more of an idle game right now.
    
31. Is there any onboarding cutscene/tutorial dialogue for AI4Mars?
Users have this text on the rover viewport:
```tsx
<div className="mb-4 w-full max-w-lg text-xs md:text-sm text-center text-white leading-relaxed px-4 py-3 rounded-lg bg-black/40 drop-shadow">

Mars is one of the closest planets to us, and certainly one of the most interesting. You've been given a rover and have been asked to help 'train' it to avoid obstacles. Each week, you give it a series of commands and routes; and it will explore Mars, finding objects of interest and eventually getting stuck. It's your job to help the rover identify what it has found and why it got stuck. With enough training, you'll be able to explore the surface of the planets you and other scientists discover.

</div>
```
    

---

### **🛰️ TECH, ARCHITECTURE & INTEGRATION**

32. Is the route data for AI4Mars persisted in Supabase per user?
Yes
    
33. Are anomalies aligned with route markers purely via shared coordinates?
Not a good question, doesn't *really* mean anything
    
34. Do viewports have a shared base layout/component structure?
There is not base or construction/building gameplay/mechanics yet. For all users, the UI for all pages/viewports looks the same. I have got limited customisation ideas for layouts in the future.
    
35. How reusable is the current viewport code across projects (e.g. Cloudspotting vs Planet Four)?
Semi-reusable.
    
36. How tightly coupled are the anomaly → classification → reward flows?
Very tightly integrated.
    
37. Are there any issues with Supabase RLS or syncing issues when deploying/deleting routes?
Not currently using RLS, everything just occurs via simple api calls:
```tsx
// Fetch linked anomalies

const { data: linked, error: linkedError } = await supabase

.from("linked_anomalies")

.select("*, anomaly:anomalies(*)")

.eq("author", session.user.id)

.in("automaton", ["Rover"]);
```
    
38. Have you had any lag or performance bottlenecks in satellite/rover deployments?
Not with the current version
    
39. How do you plan to serialise and sync minigame data from Godot with Supabase?
No plans yet
    

---    



**🖥️ UI, UX, RESPONSIVENESS**

46. Which viewports still have responsiveness issues on mobile?
Telescope, Satellite > Planet inspection mission
    
47. Are there any common interaction patterns that are hard to do on mobile (e.g. satellite deployment)?
Viewing all text? Some containers are extended beyond width limits
    
48. Have you benchmarked performance or load time differences between mobile and desktop?
No.
    
49. Could Godot be used for a visual mobile overlay rather than the entire scene?
    No idea. Performance and offline accessibility (PWA/caching) would be something I wouldn't now how to reconcile/introduce at an acceptable standard

---

### **🗣️ COMMUNITY & GROWTH**

50. Are there any regular users you could interview or feature in posts?
Maybe?
    
51. Have you ever posted to Reddit (e.g. r/space, r/astronomy, r/zooniverse)?
No - most of these subs have strict no-advertisement policies, and the ones that don't don't allow you to make multiple submissions. So I have been tempted to wait until product performs well e2e, for all features.
    
52. Do you have any weekly challenges, scoreboards, or social mechanics yet?
Not anymore - but it is something I have been considering
    
53. Could the planet painting mechanic be featured as a public gallery/leaderboard?
Well, users can currently download and share images of planets they paint, so, sure
    
54. Have you considered a Discord or in-app chat system for early users?
Discord - yes, I wouldn't be opposed to it
    
55. Have you done a teardown of Zooniverse’s most popular projects to compare hooks/features?
Yes
    

---

  






### **🎮 GODOT INTEGRATION**

40. What kind of state/data does your farming base scene in Godot store (e.g. plot status, hydration)?
    
41. Do you plan to sync actions (e.g. “watered crop”) in real-time, or sync when the scene exits?
    
42. Could you reskin the farming loop as “storm seeding,” “ice mining,” or “exoplanet colony tending”?
    
43. Would Godot scenes be embedded in <iframe> or in a custom canvas element?
    
44. How will you handle login/auth and session between Next.js and Godot scenes?
    
45. Would Godot only be used for interactive scenes, or would it eventually handle UI/navigation too?

## Navigation
- [[content/Categories/_Index|Categories Index]]
- [[content/Categories/Tasks/index|Tasks Index]]
- [[content/Categories/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Star-Sailors-Web/Sprints/QuestionsAndAnswers/index.md|Tasks - Star-Sailors-Ecosystem/Star-Sailors-Web/Sprints/QuestionsAndAnswers Index]]
