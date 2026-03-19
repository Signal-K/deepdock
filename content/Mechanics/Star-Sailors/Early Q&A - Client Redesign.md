---
tags:
  - Redesign
  - Design
  - Frontend
  - Client
  - 2-2
  - Questions
---
 I. Vision & Brand Strategy
   1. Core Objective: What is the single most important action a user should take when they arrive? (e.g., "Sign up for the Web Client," "Play Experiment 1," or "Understand the ecosystem.")
Signing up for the web client - that's what this is.

   2. Brand Persona: If the redesign were a character, what are three adjectives that describe its personality? (e.g., "Clinical and Scientific," "Playful and Gamified," or "Minimalist and High-Tech.")
I'd say a combination of minimal and playful. It should feel like a portrait-mode game, very high-tech, strong sci-fi elements. I like playing around with minimal colour combinations and textures (e.g. star textures, sunburst, etc)

   3. Primary Audience: Are we designing for "Citizen Scientists" who want depth, "Gamers" looking for quick entertainment, or "Researchers" looking for data?
Casual gamers with an interest in citizen science, and then going up from there. The idea is that Star Sailors client is a central part of the "universe", and users can either enter from there (so the web client is the entry point to the main game, where the user meets all the characters and builds up "their world"), or from the "experiments" (the minigames), which give the user a small entry point where the narrative in that game can be standalone, or integrated into the narrative & multiplayer world for the overall game.

   4. Value Proposition: How does the redesign communicate why someone should choose Star Sailors over a standard space game or a different crowdsourced science platform?
It's a unified experience for both environments.

   5. Emotional Response: What is the specific feeling we want to evoke in a first-time visitor? (e.g., Awe, Curiosity, or Efficiency.)
Curiosity


  II. User Experience & Flow
   7. The "Golden Path": What is the ideal click-path for a new user from the landing page to their first "science contribution"?
Finding their favourite projects, setting up their game for those projects, and getting started

   8. Onboarding Integration: Should the redesign include an "Interactive Guide" or "Quiz" to help users choose between the Web Client, Saily, and Experiment 1?
If they're visiting the web client, we want them to play the web client, but we still want them to see the other games (so the idea is that if they really like a game/project in the web client, recommend moving them to the experiment dedicated to that project.)


   9. Navigation Philosophy: Are we moving toward a centralized "Hub" navigation (common across all sub-apps) or keeping each experience isolated with unique navigation?
Web client should be more centralised. 

   10. Mobile First vs. Desktop First: Given the different session lengths (5 min Saily vs. 90 min Web Client), which device type takes precedence for the redesign?
Mobile-first for everything.

   11. Return User Experience: How does the landing page change for a logged-in user? (e.g., Do they see a "Resume Session" dashboard instead of marketing cards?)
They see the structures/entities they're working on (e.g. their rovers and the environment, or the telescope cards, etc).



  III. Visual Language & UI Design
   13. Color Systems: Beyond the current Teal/Amber/Sky palette, should we introduce a "Core" brand colour that unifies the ecosystem?
I like these colours

   14. Dark/Light Mode: Is this redesign strictly Dark Mode (space-themed) or do we need a high-contrast Light Mode for accessibility in different environments?
High-contract - no. But I do want light/dark mode options.

   15. Motion & Feedback: Where should micro-interactions be used to indicate progress? (e.g., Loading bars for science data, hover effects on project cards.)
Anywhere, as long as we don't clog it up

   16. Typography: Does the project need a "Technical" font (Monospace for data) paired with a "Humanist" font for readability?
Let's do a little more curly but not too much

   17. Visual Metaphor: Should we lean into literal space imagery (Planets/Ships) or abstract data-visualization patterns?
Bit more abstract. Bit more sci-fi.


  IV. Content & Information Architecture
   18. Hierarchy of Information: In the project cards, what comes first: the "Session Length," the "Scientific Goal," or the "Gameplay Style"?
Identify the flow, how structures/deployments work, and go from there

   19. Click-A-Coral Messaging: How do we transition this from a "Teaser" to an "Active Beta" without cluttering the current layout?
It's purely a teaser - it should navigate the user to the Coral experiment after they complete the teaser

   20. Social Proof: Where and how should we display community stats? (e.g., "10,000 Discoveries Made," "500 Active Sailors.")
Focus on active users.

   21. Terminology Audit: Are terms like "Anomalies," "Mechanics," and "Ecosystem" clear to outsiders, or do we need to simplify the language?
Maybe need to simplify the language

   22. Accessibility Standards: Are there specific WCAG 2.1 AAA requirements for the data-heavy sections (like the Web Client) that we need to bake in now?
I'm open



  V. Technical & Performance Requirements
   23. Performance Budgets: What is the target "Time to Interactive" (TTI) for the new landing page, especially on 3G/Mobile?
Fast. 

   24. Framework Alignment: Will the redesign leverage new Next.js 15+ features (like Server Actions or PPR) to reduce client-side JS?
Yes, go very in-depth there.

   25. Asset Strategy: How will we handle high-quality imagery? (e.g., SVGs for icons, WebP for photos, or Lottie animations for the hero section?)
I'm open

   26. SEO & Meta-Data: What specific keywords or "Open Graph" (OG) image strategies are needed to make project shares look premium on social media?
I'm open

   27. Third-Party Integrations: Do we need to plan for new PostHog event tracking points or Sentry error boundaries as part of the UI rebuild?
Yeah, I want to track as much as possible


  VI. Success Metrics & Future-Proofing
   29. Conversion KPIs: What percentage increase in "CTA Clicks" are we targeting compared to the current 2.2 version?
Just get people playing the game

   30. Bounce Rate: Is the goal to keep users on the landing page longer to learn, or to get them off the page and into a game as fast as possible?
Into the game

   31. Scalability: How easily can the layout accommodate a 5th, 6th, or 10th project card in the future?
I think pretty easily.

   32. User Feedback Loop: Should the redesign include an integrated survey (PostHog) or feedback widget to capture real-time reactions?
Make a bunch of micro-surveys that sort of fit into the game flow (UI and flow-wise) so that we can get a lot of segmented feedback - rather than users having to do a 5 minute survey

   33. Maintenance: Who will be responsible for updating the "Science Project" stats on the page—is it hardcoded, or do we need a CMS/Prisma-backed admin view?
Prisma




### Bigger q&a
  1. The spec lists Inter/DM Sans for body text, but tailwind.config.ts maps both font-sans and font-display to Nunito. Is body-weight Nunito the final call, or is a second body font still planned?
I just want something slightly playful and curly, but still more formal.
  2. --tracking-normal: 0.025em is applied globally to body — does this intentionally bleed into font-mono elements (monospace fonts typically need 0 tracking), or should mono be explicitly reset?
I have no idea
  3. Nunito is loaded with weights 400–900. Are all of them actually used? (400, 500, 600, 700, 800, 900 adds up to significant font payload.)
Let's keep it simple
  ---
  Dark Mode / Theme
  4. The dark class is toggled by UseDarkMode() on the client — but <html> renders without it initially on the server, causing a flash of light mode before hydration. Is there a plan to initialize dark mode SSR-side (cookie or next-themes)?
yes, we need to have SSR for everything that would be relevant

  5. apple-mobile-web-app-status-bar-style is set to "default" (white bar) in both the meta tag and metadata. In dark mode, does the status bar match the dark background, or is it always white?
Ideally it should match.

  6. The --panel-bg and --glow-primary tokens are only defined in :root and .dark but not inside @layer base — is this intentional, or should they be part of the base layer reset?

It's not intentional - I have no idea what's best. 

  ---
  Safe Area / Mobile / PWA

  7. viewportFit: "cover" is set but no env(safe-area-inset-*) CSS vars appear in globals.css or the layout. Is safe-area-inset-bottom handled inside StationNav or somewhere else, or is it missing?
Ideally, figure out everything like this that's missing/half-completed. I have no idea about any of this.

  8. The game view uses pb-24 md:pb-8 to clear the bottom nav. Is pb-24 (96px) the measured height of StationNav + iPhone home bar, or was it eyeballed?
It's just been done by claude, so I have no idea

  9. survey-panel uses @apply fixed bottom-0 left-0 right-0 p-4 — no padding-bottom: env(safe-area-inset-bottom) — will it be clipped under the iPhone home indicator?
Ideally everything is tailored to work within the screen sizes

  10. apple-touch-startup-image only references Captn.jpg at one resolution. Are per-viewport splash screens needed for the PWA, or is this deliberately minimal?
I think it's pretty straightforward, we only need one splash screen

  11. userScalable: false / maximumScale: 1 is set globally. Is this a deliberate accessibility trade-off for the game viewport, or should the landing page (/apt) allow pinch-zoom?

The landing page should have pinch-zoom, I guess. 

  ---
  RootLayout Structure

  13. RootLayoutClient wraps everything in <div className="flex min-h-screen w-full"><main className="flex-1 min-w-0">. Is the min-w-0 there as an overflow guard for flex children? Is it ever load-bearing, or can it be removed?
I have no idea


  14. <Analytics /> and <SpeedInsights /> are rendered as siblings to <ActivePlanetProvider>'s children, outside its tree. Is this placement intentional, or
  should they be inside?
  15. Should RootLayoutClient grow to include <noscript> fallback content, or is the assumption that all users have JS?
  16. There's no <body className={...}> — the font variable is on <html>. In Next.js, is this the correct approach for CSS variable inheritance, or should
  the font class be on <body>?

  ---
  Landing Page (/apt)

  17. The hero H1 reads "Real astronomy. Your pace." — the spec shows "Real astronomy. Your kind of game." as the OG description, and prior designs used
  different copy. Is the current H1 the locked copy?
  18. The ActiveSailorsCount component is defined inline in apt/page.tsx. When PPR lands (Phase 2 unblocked), does it need to move to its own file to be
  wrapped in a separate <Suspense> boundary with proper streaming?
  19. The "See projects ↓" anchor links to #explore — on mobile, does the sticky nav (which is sticky top-0) obscure the target section when the anchor
  scrolls into view?
  20. The project rows use md:grid-cols-[5rem_1fr_auto] but on mobile they collapse to grid-cols-1. On mobile, the number, name, and CTA stack vertically —
  is the number meant to remain visible on mobile or hidden?
  21. The Click-A-Coral row is a ghost/faded version of the numbered row pattern. Should it look like a locked state (muted but recognizable), or is the
  current very-faded opacity (text-muted-foreground/50, text-border/40) the intended final appearance before Phase 4?
  22. The "About strip" stats (11+, 3, 3) are still hardcoded. Is there a placeholder design for how the number will animate in when Prisma data lands (Phase
   7), or will it just swap text?
  23. The bottom CTA section repeats "Launch Web Client" — same button style as the hero. Should these be differentiated (e.g., ghost button at bottom since
  it's a secondary touchpoint), or is the repetition intentional reinforcement?
  24. The LandingMobileMenu is rendered inside a relative md:hidden div. What does the mobile menu actually show — is it the same 2 links (Saily, Web Client)
   from the desktop nav?

  ---
  Game Hub (/game)

  25. GamePage is fully "use client" — the spec (Phase 2/3) says the game hub should have a "server shell + client islands." Is there a plan to split
  GamePageContent into a server wrapper + client islands, or is this deferred past the active phases?
  26. The game base view constrains content to max-w-screen-sm but viewport views (telescope, satellite, etc.) use max-w-screen-xl. Is this intentional —
  narrow column for the control station, wide for the science viewport?
  27. TelescopeBackground (the star field) is rendered as a fixed background on every view in /game. It's loaded with ssr: false and dynamic. What's the
  measured render cost — does this cause any visible delay before the star field appears?
  28. The ControlStationSkeleton has a specific height for the header (h-11) and sector bar (h-8). Do these match the actual rendered heights of
  CommandHeader and SectorBar, or could they drift?
  29. The StationSchematic replaces the previous 2×2 card grid. Is there a design for what it looks like when 0 structures are deployed (all standby) vs all
  4 deployed?
  30. The SectorRadar is rendered inside a manually styled dark box with inline style rather than using the sci-fi-panel token class. Is this intentional
  (different aesthetic for radar vs other panels), or should it be refactored to use the token?
  31. The profile-incomplete button uses entirely inline style objects rather than Tailwind or design tokens. Is this the pattern for one-off alert
  components, or should it adopt sci-fi-panel + token colors?

  ---
  ViewportShell

  32. ViewportShell hard-codes pt-20 and h-[calc(100vh-80px)]. MainHeader is 80px tall — is this height contract written down somewhere, or is it a magic
  number that could easily drift?
  33. ViewportShell uses overflow-hidden on the inner container. Does this intentionally prevent scrolling inside viewport pages, meaning all scrolling must
  happen within the content child?
  34. The TelescopeBackground inside ViewportShell receives sectorX={0} sectorY={0} hardcoded. Should these come from the active planet context, or is the
  star field always sector (0,0) regardless of where the user is in the game?

  ---
  Animations & Performance

  35. spinOrbit, pageScan, atmoPulse, moduleReveal, termCursor are defined as @keyframes in globals.css but not registered in tailwind.config.ts. Are they
  accessed via arbitrary animation-[...] utilities or via custom CSS classes only? Is this split intentional?
  36. The CRT scan-line overlay in /game base view is done with an inline repeating-linear-gradient style. Given it's a fixed-position full-screen overlay,
  is it GPU-composited (should be fine), or has it been profiled?
  37. btn-glow has a transition on box-shadow. Box-shadow transitions are not GPU-accelerated on all browsers — has this been tested on lower-end Android
  devices?

  ---
  Analytics & Providers

  38. posthog.identify runs in RootLayoutInner with user.id and email. On the landing page (/apt), where there's no auth user, does posthog.reset() get
  called correctly — and does LandingAnalytics (a separate client island on /apt) fire landing_page_viewed before or after the reset?
  39. The service worker is versioned as ?v=20260227-2. Is this version string bumped manually on every deploy, or is there a build step that injects it? If
  manual, what's the process?
  40. The PostHog API key is read from three env var names (posthog_api_key, POSTHOG_API_KEY, NEXT_PUBLIC_POSTHOG_KEY). Is this fallback chain documented
  anywhere, and is NEXT_PUBLIC_POSTHOG_KEY the one that actually ships to the browser for client-side events?

  ---
  Metadata / SEO

  41. The OG image is set to /assets/Images/landing1.jpg (1200×630) but the V3 landing has no hero image — it's typography-only. Is the OG image going to
  stay as a separately designed static asset, or will it be replaced with a @vercel/og generated image that matches the editorial style?