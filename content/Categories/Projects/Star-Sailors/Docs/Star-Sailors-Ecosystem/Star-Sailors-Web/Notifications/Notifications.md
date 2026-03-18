---
icon: lucide//file-text
---

## Notifications and Timed Unlocks

Notification improvements required:

1. Notifications about unclassified discoveries should be per-user, not broadcast to all.
2. They should only occur once per `linked_anomalies` entry.
3. Mission unlocks should happen gradually over time — for example, one anomaly unlocked per day, per viewport.

This logic may require a microservice beyond the Next.js frontend, to handle weekly timing and per-user progress reliably. Consider using Supabase CRON or a Go runner.

## Navigation
- [[content/Categories/_Index|Categories Index]]
- [[content/Categories/Docs/index|Docs Index]]
- [[content/Categories/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Star-Sailors-Web/Notifications/index.md|Docs - Star-Sailors-Ecosystem/Star-Sailors-Web/Notifications Index]]
