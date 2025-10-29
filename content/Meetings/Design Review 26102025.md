---
aliases:
  - Design Review 26/10/2025
tags:
  - Meetings
sticker: lucide//cherry
---
Rhys & Liam

Depending on time differences, this may occur at 25/10/25 for Liam, but it will definitely be 26/10/25 AEDT.

(Copy to Obsidian for archive)

  

Basically, I'm getting to the point where I want to wrap up Star Sailors V2, do a launch, call in some remaining favours and just move to the next stage of development in Star Sailors.

  

Updates

  

Here's a highlights reel (by text, though) of what's occurred over the last ~8 weeks since we (Rhys & Liam) properly talked and did a demo:

New projects

1. SuperWASP - Variable Stars
2. Cloudspotting on Mars: Shapes
3. AI4Mars (revamped)
4. Planet Hunters: NGTS (revamped/new chapter for Planet Hunters)
5. Jovian Vortex Hunters

Plus, Are We Alone & Click-A-Coral are upcoming projects. They probably won't be added to V2, though; probably an early patch in the early days of V3. Probably the only reason I would begin integration now would be if I'm convinced that integration would improve demand or retention. And I don't think the lack of those projects is the reason for the lack of traction.

  

(I'd also recommend taking a look at the chatgpt link I sent a few days ago when you get the opportunity)

Gameplay updates

1. Users can now research technology. In fact, a lot of the mechanics now require the user to unlock them. However, the core discovery mechanics remain open from the start
2. Annotations are now the standard classification method for all projects
3. Users can find mineral deposits in clouds and on planets when they deploy their automatons (long story)
4. Users can see how much "Stardust" (the name for the in-game 'currency') they earn for each contribution

  

General/meta updates

1. Removed a LOT of code that wasn't being used
2. Everything runs in docker now
3. Push notifications were added and then (for the most part) removed. But...we got them working without relying on any third-party tools
4. Supabase now has a custom domain - api.starsailors.space . This improves the authentiction experience for users
5. Added guest/anonymous user account, with the option to "complete" your account later
6. Added a feedback button with UserJot
7. For the most part, I think the responsiveness parity/quality is close to 100%
8. Overall, the code quality has been improved with a lot of actions that are repeated frequently (e.g. pulling linked_anomalies ) moved to global handler functions

  

  

Standalone games

  

Additionally, over the last ~4 weeks I've begun work on two new minigames, built in Expo outside of the Star Sailors client codebase (however, still integrating with the same Supabase client. Why not? We're nowhere near our project usage limits so we save $40 each month).

  

  

Bumble

  

The first of these games is called "Bumble". It's basically a flower/grass planting game. Here's the user flow:

1. Water dirt
2. Till soil
3. Plant grass
4. Wait for it to grow
5. Water/feed the grass
6. 🔂🔂
7. Harvest grass - bees will pollinate two plants. This causes them to breed, harvesting the crop and giving you the two soil plots back

As part of step 7, you have to make a classification of an image and determine the type of bee that visited "your crop".

Currently, we have an entire game loop; with classifications being pushed to Supabase with the classificationtype value of bumble and all other user data being stored with react-native-async-storage/async-storage.

The next steps would be bundling for distribution (currently I have an APK but don't have the developer license to send out Testflight versions for iOS...and giving the few Android users in my network unlicensed, unsigned APKs would probably not go over that well (just spitballing here, of course).

In terms of gameplay, I think adding more plants and things to collect would be the best mechanic to add.

There is another tie-in to the Star Sailors "universe" - you can connect your SS account and for every planet you've discovered in Star Sailors, you can create additional planting plots there (and "benefit" from the unique values (e.g. gravity, growthrate, water ratio, etc) and how these affect your planting/gardening experience).

  

I started building these little minigames as a little respite from the main Star Sailors game and codebase, and also because I think that these minigames could serve as more targeted/specialised growth & user acquisition methods. The "downside" that I've realised is that this is sort of going against my initial goals with Star Sailors, to create a unified game experience & narrative/universe for ALL citizen science projects. But if it gets more users, then that's a good thing and I can build something off that.

  

  

"Roving"

  

Working title. Started this week.

Basically, a React Native build of the AI4Mars project.

Starting out with a basic Martian surface .glb file and a 3D render of the Mars rover.

Not sure how far I want to take this.

Image.png

Image.png

The basic game loop would be something like this:

Image.jpeg

1. Deploy rover
2. Rover finds something, you classify or perform an action
3. Rover needs to recharge

Design inspiration:

[https://dribbble.com/shots/10752052-Mars-Rover-AR-Navigator-App](https://dribbble.com/shots/10752052-Mars-Rover-AR-Navigator-App)

  

To write:

1. Reasons for minigames, technical discussions between RN/Expo & Godot/Unity
2. V2 goals
3. User targets
4. V3 ideas
5. Integration of projects