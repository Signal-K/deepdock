## Notifications and Timed Unlocks

Notification improvements required:

1. Notifications about unclassified discoveries should be per-user, not broadcast to all.
2. They should only occur once per `linked_anomalies` entry.
3. Mission unlocks should happen gradually over time — for example, one anomaly unlocked per day, per viewport.

This logic may require a microservice beyond the Next.js frontend, to handle weekly timing and per-user progress reliably. Consider using Supabase CRON or a Go runner.