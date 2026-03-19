---
sticker: lucide//file-question
tags:
  - Notifications
icon: lucide//file-text
---

#### Checkback Reminders
From #SSG-281 sprint
> _As a player, I want timely notifications when new actions are available so I return regularly._
- **Tasks**
    - Extend notifications to satellites (ready to redeploy / completed scan)
    - Implement pipeline for gradual linked_anomalies unlock
        - Subtask: Backend schedule logic (unlock X anomalies/day per user)
        - Subtask: Display “Next anomaly in: Xh Ym” countdown in viewport
    - Weekly notification for telescope redeploy (already working for structures — extend scope)


I'm not going to set up a go server and deploy it for a while, as we can probably have everything run fine with cron jobs via Github Actions for now. So that's one commitment/resolution.

When we unlock anomalies, we should send a notification. So here's a commitment:
https://github.com/Signal-K/client/actions/workflows/unlock-solarhealth-anomalies.yml
I'll update the above action so that it also sends a notification - "A new Sunspot on {$starName} has been identified and is available for classification". - #SSB-3 

Similarly, we'll have an action that will run to unlock anomalies in #AI4Mars project, but it will be a bit different -
1. Identify the time since the deploy event was created, how many route markers would have been passed since, e.g. 5 minutes, 10 minutes, 3 hours, 5 hours.
2. Do not send a notification if one was sent < 1 hour ago or if the interim between markers is < 1 hour
3. Identify if a route has been classified - #SSF-3

Because the #AI4Mars project is not being integrated this week, we can skip this step today.

For the Satellite #Viewport , we currently have an arbitrary countdown over the satellite icon; I think we need to figure some more things out with regards to what the satellites are "discovering" and the time period/process to do so before we can properly figure out a good notification pipeline. So I'm putting this on the meeting agenda [[30 August 2025]].

#PLanetHunters can easily have a simple function like #AI4Mars that can unlock anomalies over time, but there's not enough content right now to be able to feasibly lock content behind a "time-wall", and Planet Hunters is our flagship project, so I'll also postpone this.

## Navigation
- [[Projects/_Index|Categories Index]]
- [[Projects/Docs/index|Docs Index]]
- [[Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Star-Sailors-Web/Notifications/index.md|Docs - Star-Sailors-Ecosystem/Star-Sailors-Web/Notifications Index]]
