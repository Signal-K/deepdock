---
tags:
  - Mapping
sticker: lucide//facebook
icon: lucide//lightbulb
---

![[Pasted image 20260110141054.png]]

*  [ ] Come up with logo
*  [ ] Come up with name
*  [ ] Define development scope for MVP (prototype) (whats gonna be included and whats not)

Come up with logo:
- Ideas
	- The logo for this app should be very minimalistic, over complex, as complexity reduces clarity and visual impact. ( a good example of simple logos is terraria)
	- A good idea would be to make a logo reminiscent of the age of exploration so this could include a  old compass logo, and old map logo, or a old colonial style ship. An older map logo would be the way to go in my opinion. 
	- 
Come up with name:
- Mapify
- Traverse
- Roamify
- Realm
- GeoQuest (this one is more intune with the vibe I like)
- Wayfarer (the definition for this word is right in tune with the vibe of this app)
- Nomad (I'm not so sure about this )
- Cartographer (this has a old feel to it)
- Voyager (this also has a old feel to it)
- Atlas
Taglines:
- Explore the world, one zone at a time.
- Every place is a level.
- Your map. Your journey.
- Turn the world into a game.
- The world is live. Go explore.

Define development scope for MVP (prototype) (whats gonna be included and whats not): 
- Outline
	- **App Development Plan (Numbered Steps)**

	Step 1: Planning

	- Choose final app name

	- Write a short app description (1–2 sentences)

	- A gamified map application which allows users to find POI which are in line with their interests, personality and preferences. The POI’s are recommended to the user via an ai which collates data about the user, and recommends to them the best possible POI’s for the user.

	- Define target users (locals, explorers, tourists)

	- Target users is for people who want to find POI’s in different countries or even the same country which most appeal to them.
	- This app is also for lazy people and people who don’t like to venture outside of their comfort zone who just want to quickly find a place to eat or visit, which they would probably enjoy. Thankfully this is a huge demographic, so once we get some users, they can then spread the word.

	- Decide platform (iOS)

	- IOS, Android.
	- IOS will be the first OS that the app is tested on, as its easier to cater an app for IOS.

	- Define MVP scope (what features are included)

	- AI filter, in which the AI can suggest new places to visit based on the history of places visited and preferences of the user. That is a must. The preferences include times the person usually goes out to eat (this is useful as it can give restaurants which aren’t in rush hour), the foods the person eats, the interior design/vibes the person likes. And then it would be similar for non-food POI’s.
	- There also is a social aspect in the app where users can view their friends orders and favourites. This can also be used by people who are indecisive.
	- There will also be an onboarding system where the user will be given a survey/data collection method, in which they will have to give answers and pick between options, so the app knows what they like.
		
		-List of features not included in the MVP
		- Teams
		- XP
		- Gamified aspects (will be added later)

---

	    Step 2: MVP Feature List

	- Interactive map
	- User location using GPS
	- Points of Interest for areas and places
	- Tap POIs to view basic information
	- Mark locations as visited
	- Simple exploration progress tracking
	- Minimal user profile

---

	**Step 3: App Flow**

	- Open app to map view
	- Display user’s live location
	- Show nearby Points of Interest
	- Tap POI to open detail view
	- Visiting a POI marks it as discovered
	- Profile displays exploration progress (this one is contested)

	·       Sidenotes

	  There is also an AI chat in which the user can tell the AI the plans for the day, and the AI can recommend a restaurant.

	- There is also a portion of the app where you can swipe to the left, and it will show you recommendations of POI for you. This will simply be recommendations. For specific recommendations the user would go to the AI chat, in which they can put all of their specifics, eg the time they want to visit, the price they want to pay,  the food they want to eat and the interests of the company they want to bring.
	- The app must be extremely simple to navigate, to the point where somebody who has minimal technology experience can easily navigate through the app. Because a huge selling point of apps is the simplicity of them. If the app is useful but it’s extremely hard to navigate then it’s automatically a bad app, and users won’t want to use it because they won’t even get past the tutorial stage because they will quite because it’s too much effort to use.

---

	**Step 4: Design**

	- Sketch basic wireframes:

	- Map screen
	- POI detail screen
	- Profile screen

	- Choose a minimalist colour palette
	- Use system font (SF Pro)
	- Design a simple, map-based app icon

---

	**Step 5: Technical Setup**

	- Choose map provider (MapKit)
	- Choose backend (Supabase)
	- Set up iOS project using SwiftUI
	- Enable location permissions
	- Create basic database structure (users and POIs)

---

	**Step 6: Development (MVP Build)**

	- Build the main map screen
	- Implement GPS tracking
	- Load POIs onto the map
	- Enable POI tap interactions
	- Save visited locations to backend
	- Build profile screen
	- Connect frontend to backend

|     |                                                                                                                                                                                                |                                                                                                                                                                                           |     |     |     |                                                                                                                                        |     |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- | --- | --- | -------------------------------------------------------------------------------------------------------------------------------------- | --- |
|     |                                                                                                                                                                                                |                                                                                                                                                                                           |     |     |     |                                                                                                                                        |     |
|     |                                                                                                                                                                                                | ![Text Box: V1](file:////Users/thomasroshin/Library/Group%20Containers/UBF8T346G9.Office/TemporaryItems/msohtmlclip/clip_image003.png)                                                    |     |     |     | ![Text Box: V2](file:////Users/thomasroshin/Library/Group%20Containers/UBF8T346G9.Office/TemporaryItems/msohtmlclip/clip_image004.png) |     |
|     |                                                                                                                                                                                                |                                                                                                                                                                                           |     |     |     |                                                                                                                                        |     |
|     | ![A paper with writing on it<br>AI-generated content may be incorrect.](file:////Users/thomasroshin/Library/Group%20Containers/UBF8T346G9.Office/TemporaryItems/msohtmlclip/clip_image005.png) |                                                                                                                                                                                           |     |     |     |                                                                                                                                        |     |
|     |                                                                                                                                                                                                | ![A sketch of a website<br>AI-generated content may be incorrect.](file:////Users/thomasroshin/Library/Group%20Containers/UBF8T346G9.Office/TemporaryItems/msohtmlclip/clip_image006.png) |     |     |     |                                                                                                                                        |     |
|     |                                                                                                                                                                                                |                                                                                                                                                                                           |     |     |     |                                                                                                                                        |     |

 

  

---

	Step 7: Testing

	- Test location accuracy
	- Test map performance
	- Test POI interactions
	- Test UI clarity and simplicity
	- Fix bugs
	- Simplify any confusing flows

---

	Step 8: Beta Release

	- Create TestFlight build
	- Test with a small group
	- Collect feedback
	- Make usability improvements
	- Final polish

---

	Step 9: Launch

	- Prepare App Store assets
	- Write App Store description
	- Upload screenshots
	- Submit app
	- Release version 1.0

---

	Step 10: Post-Launch (Future Work)

	- Add achievements or badges
	- Add challenges or events
	- Add social features
	- Optional AR features
	





Liam's tasks:
* [x] Set up development environment ✅ 2026-01-10

## Navigation
- [[content/Categories/_Index|Categories Index]]
- [[content/Categories/Ideas/index|Ideas Index]]
- [[content/Categories/Projects/Other-Projects/Ideas/Map-App/index.md|Ideas - Map-App Index]]
