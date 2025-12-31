---
sticker: lucide//folders
tags:
  - Proposals
  - ContentReview
  - Ideas
---
> I’m thinking of building a minimal service that provides nps and other surveys and generates rewards for completing them. 
> This way when I’m begging for beta testers it’s an easy experience to provide feedback and people can see clearly the reward they get for beta testing

# **Software Project Definition & Feasibility Template**

---

## **1. Project Identity**
**Project Name:** NPS idea thing
**One-Sentence Description:** A cross-framework, embedded service that allows developers/makers to get feedback from users while causing minimal disruption in flow for users; and give users something back in the service/product as compensation for providing feedback.  

**Expanded Description (1–3 paragraphs):**
> What does this software actually do?

> What problem does it exist to solve?
1. A lot of users don't want to spend time filling in surveys or even simple NPS questions. 
2. A lot of makes (e.g. us!) don't get much traction and this makes it hard for us to determine what works, what doesn't, what to do next, etc
3. Often we need a lot of different feedback from different users, and different types of users. Different users will use different features and will use the app/product in different ways. With typical surveys or NPS flows there's no easy way to differentiate here. 


> What experience does the user have from start to finish?

So for this type of project, I have to emphasise that this will be aimed at developers(i.e. people building software). This means that it will likely be a simple web application that can be embedded via a `js` script into a full-stack application - this would be the simplest approach for starting off an MVP.
But this doesn't really address the main issue - tying the survey/feedback flow directly into the user experience. So I think building this as an MCP-type project that can be integrated into a code editor; that can learn what the project is...that would be the ideal format for this project. But, until we know a little more about how we'd do this....the best I can say is that it would be a series of questions where you describe the questions you need answered, which groups of users to target, and what you're rewarding them with (and the relevant code for all of this).

---

## **2. Target Market & Users**
### **2.1 Primary Target User**
**Who is this for?**
- Job / role / background
> Basically, anyone building a product that needs feedback

**User Context:**
- Where and how do they use this software?
> As described above, this would probably be done through the code editor, with a PWA for admin/stats
---
### **2.2 Secondary / Future Users**
- Are there adjacent user groups this _could_ serve later?
> I don't think so - it's relatively tied to makers
---
### **2.3 User Pain Points**
- What are they currently doing instead?
> Using tools like Posthog or custom forms - even Google Forms!!
- Why does that suck?
1. It takes the user out of the app
2. It feels like a chore for the user
3. Users don't get anything for their contribution (by default). And even if they do, tracking them down and assigning the reward is a nightmare

---

## **3. Relationship to Other Projects**
### **3.1 Internal Ecosystem Fit**
- Does this relate to any of your existing projects?
> Mainly helps me with Star Sailors at this point - but it could be utilised for any software....
- Shared users?
> No
- Shared data?
> No
- Shared infrastructure?
> Well, I'd look into using Supabase...but it would all be on different infra

**Explicit Connections:**
- Can it reuse auth, storage, APIs, UI components, lore, branding, etc?
> Branding - parent company yes; everything else no
- Is it upstream, downstream, or parallel?
> Not relevant here

---

## **4. Scope Definition**
### **4.1 Core Problem (MVP Scope)**
**What must exist for this project to be “real”?**
- Absolute minimum features
- No polish
- No “nice to haves”
---

### **4.2 Non-Goals**
**Explicitly not included:**
- Features you are intentionally cutting
- Markets you are not targeting
- Use-cases you are ignoring 

---

### **4.3 Future Expansion Ideas (Optional)**
- What could be added _later_?
- Only list things that feel natural extensions
---

## **5. Functional Requirements**

### **5.1 Core Features**
For each feature:
- What it does 
- Why it exists
- Who uses it

---

### **5.2 User Flows**
- First-time user experience
- Returning user experience
- Power-user workflows (if relevant)

---

## **6. Non-Functional Requirements**
**Performance Expectations:**
- Latency
- Scale (users, data, requests)

**Reliability:**
- Uptime expectations
- Offline or degraded modes

**Security & Privacy:**
- Authentication needs
- Sensitive data?

---

## **7. Technical Architecture**
### **7.1 Proposed Software Stack**
**Frontend:**
- Frameworks, languages, platforms  

**Backend:**
- Language(s)
- Frameworks
- Monolith vs services  

**Database(s):**
- Type (SQL / NoSQL / hybrid)
- Why this choice?

**Auth:**

**Storage:**

**External APIs:**

---

### **7.2 Architecture Rationale**

- Why this stack _for this project_?
- What constraints influenced the decision?
- What tradeoffs are you accepting?

---

## **8. Data Model Overview**
**Core Entities:**
- What are the main objects in the system?  

**Relationships:**
- How do they connect?  

**Growth Risks:**
- Any entities likely to explode in size?
- Any migration risks?  

---
## **9. Development Plan**
### **9.1 Milestones**
- Phase 1: MVP
- Phase 2: Polish
- Phase 3: Expansion

