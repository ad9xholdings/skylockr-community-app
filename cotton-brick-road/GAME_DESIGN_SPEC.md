# Cotton Brick Road Game Page

## 🎮 Game Architecture: Anti-Addiction + Daily Progression

### Core Philosophy
**Small daily updates, not endless scrolling.**

Players make meaningful progress through daily encounters, not marathon sessions. The road has gates, lockouts, and natural stopping points.

---

## 🚫 Anti-Addiction Mechanics (The "Right Road")

### Daily Energy System
| Feature | Limit | Reset |
|---------|-------|-------|
| **Creature Encounters** | 5 per day | 9 AM EST |
| **AR Exploration Time** | 20 minutes/day | Midnight local |
| **Cotton Brick Road Progress** | 1 "brick" per day | Daily trigger |
| **Ask Cuz Questions** | 10 per day | 9 AM EST |

### Weekly Caps
| Feature | Weekly Limit |
|---------|--------------|
| **Total Bricks Traveled** | 7 bricks max (1/day) |
| **Boss Encounters** | 1 per week |
| **Live Mode Sessions** | 3 per week |

### Session Lockouts
```
After 20 minutes of AR play:
→ "Time to rest, young explorer!"
→ Avatar goes to sleep animation
→ Lockout: 4 hours before next session
→ Encourages: "Come back tomorrow for new creatures!"
```

### Weekend Bonus (Controlled)
- Saturday: +2 bonus encounters
- Sunday: Special "Cotton Castle Preview" (5 min)
- Still capped at 1 brick progress per day

---

## 🧙‍♂️ "Ask Cuz" AI Assistant

### Embedded in Game Page
```html
<div id="ask-cuz-widget">
  <div class="cuz-avatar">
    <!-- AR-ready 3D avatar that evolves with player -->
  </div>
  <div class="cuz-chat">
    <input type="text" placeholder="Ask Cuz anything..." />
    <button>Ask</button>
  </div>
  <div class="daily-limit">
    Questions today: <span id="questions-used">0</span>/10
  </div>
</div>
```

### Cuz Personality
- **Name**: Cuz (short for "Because" - always has answers)
- **Role**: Guide, tutor, friend on the road
- **Knowledge**: Phonics, creatures, Cotton Castle lore
- **Limit**: 10 questions per day (prevents over-reliance)

### Sample Cuz Interactions
```
Player: "Why is the frog yellow and blue?"
Cuz: "Great question! That Gold Ember frog uses warning colors - 
      bright yellow says 'I'm toxic!' to predators. The blue?
      That's structural color - tiny structures in its skin 
      reflect light like a prism! Want to see a diagram?"

Player: "How do I get to Cotton Castle?"
Cuz: "One brick at a time! You've traveled 3 bricks today.
      Come back tomorrow for brick #4. The castle waits 
      for patient explorers! 🏰"

Player: [After daily limit reached]
Cuz: "My voice needs rest too! Ask me again tomorrow 
      when the sun rises on Cotton Brick Road. 
      Your brain needs sleep to remember all we've learned!"
```

---

## 🐸 Daily Creature Triggers

### Auto-Generated Each Day at 9 AM EST

**Cron Job:** `0 14 * * *` (14:00 UTC = 9:00 AM EST)

```javascript
// Daily creature spawn system
const dailyCreatures = {
  generate: async (dayNumber, playerProgress) => {
    // 1. Select creature type based on road location
    const location = getLocation(playerProgress);
    const creatureType = selectCreature(location);
    
    // 2. Generate realistic AR model
    const realism = calculateRealism(dayNumber);
    const model = await generateARModel(creatureType, realism);
    
    // 3. Create challenge
    const challenge = generateChallenge(creatureType, playerLevel);
    
    // 4. Push to game page
    await updateGamePage({
      creature: model,
      challenge: challenge,
      expires: tomorrow9am()
    });
  }
};
```

### Daily Spawn Rules

**Days 1-7: Bugs & Insects**
- Ant, Beetle, Butterfly, Dragonfly, Bee
- Cartoonish (realism 1-2/10)
- Simple phonics challenges

**Days 8-14: Amphibians**
- Dart frogs, Tree frogs, Toads
- Semi-realistic (realism 3-5/10)
- Color + biology learning

**Days 15-21: Birds**
- Robin, Blue Jay, Owl, Eagle
- Realistic (realism 6-8/10)
- Species identification

**Days 22-28: Animals**
- Fox, Deer, Rabbit, Lion
- Photorealistic (realism 9-10/10)
- Ecosystem + definition challenges

**Days 29+: Legendary**
- Mythical creatures, Mrs. Cotton appearances
- Ultra-realistic AR
- Multi-step quests

---

## 👤 Player Avatar Progression (AR → AI → ML)

### Avatar Evolution System

```javascript
const avatarStages = [
  {
    stage: "Sketch",
    days: 1-3,
    appearance: "2D cartoon drawing",
    ar: "Flat overlay",
    unlocks: "Basic movement"
  },
  {
    stage: "Color",
    days: 4-7,
    appearance: "Colored 2D character",
    ar: "Slight depth",
    unlocks: "Expressions"
  },
  {
    stage: "Shade",
    days: 8-14,
    appearance: "3D model, simple textures",
    ar: "Full 3D in space",
    unlocks: "Custom clothing"
  },
  {
    stage: "Render",
    days: 15-30,
    appearance: "Detailed 3D, realistic materials",
    ar: "Occlusion, lighting",
    unlocks: "Emotes, dances"
  },
  {
    stage: "Alive",
    days: 31-60,
    appearance: "Photorealistic skin, hair",
    ar: "ML-driven movements",
    unlocks: "AI personality, voice"
  },
  {
    stage: "Real",
    days: 61+,
    appearance: "Indistinguishable from photo",
    ar: "Full embodiment",
    unlocks: "Live Mode streaming, teaching"
  }
];
```

### Daily Avatar Update
Each day, player's avatar receives:
- **Visual upgrade** (more detail, realism)
- **New animation** (walk cycle, expression)
- **Voice evolution** (from robotic to natural)
- **Personality growth** (AI learns player preferences)

### AR Features by Stage
| Stage | AR Capability |
|-------|---------------|
| Sketch | Basic overlay, follows camera |
| Color | Anchored to ground plane |
| Shade | Occludes behind real objects |
| Render | Reacts to lighting, shadows |
| Alive | Eye contact, gesture recognition |
| Real | Full embodiment, lip-sync to speech |

---

## 🌾 Cotton Brick Road: Limited Scroll Design

### The Road Structure
```
START (Day 1)
   │
   ▼
[Brick 1] ─── Creature Encounter #1 ─── 🐜 Ant
   │
   ▼
[Brick 2] ─── Creature Encounter #2 ─── 🐝 Bee
   │
   ▼
[Brick 3] ─── Mini Boss ─── 🦋 Monarch Butterfly Challenge
   │
   ▼
[LOCKOUT GATE: "Rest required!"]
   │
   [WAIT: Next day unlocks]
   │
   ▼
[Brick 4] ─── Creature Encounter #4 ─── 🐸 Dart Frog
   │
   ▼
... (continues 100 bricks to Cotton Castle)
```

### Lockout Gates
Physical barriers on the road that prevent progress:

```
🚧 GATE #1 (After Brick 3)
"Your avatar is tired! Time to rest and let today's 
 learning sink in. Come back tomorrow for Brick #4."

Options:
• [Review today's creatures] - Spaced repetition
• [Ask Cuz questions] (if daily limit not reached)
• [View collection] - Past encounters
• [Exit to Mrs. Cotton's Academy]

[Come Back Tomorrow] ← Only option to proceed
```

### Progress Visualization
```
Cotton Brick Road Progress
🧱🧱🧱⬜⬜⬜⬜⬜⬜⬜  3/100 bricks
     ↑
   You are here (Day 3)

Next brick unlocks: Tomorrow 9 AM EST
Time until next session: 14 hours 32 minutes
```

---

## 📱 Game Page Structure

```html
<!DOCTYPE html>
<html>
<head>
  <title>Cotton Brick Road | Mrs. Cotton's Academy</title>
  <script src="ar-engine.js"></script>
  <script src="cuz-ai.js"></script>
  <script src="daily-creatures.js"></script>
</head>
<body>
  <!-- AR Canvas -->
  <div id="ar-scene">
    <canvas id="cotton-road-ar"></canvas>
  </div>
  
  <!-- Player HUD -->
  <div id="player-hud">
    <div class="avatar-container">
      <img id="player-avatar" src="avatar-stage-1.png" />
      <span id="avatar-stage">Sketch</span>
    </div>
    <div class="progress-bar">
      <div class="bricks">🧱🧱🧱⬜⬜⬜</div>
      <span>Brick 3 of 100</span>
    </div>
    <div class="daily-limits">
      <span>Creatures: 2/5</span>
      <span>Time: 12/20 min</span>
      <span>Ask Cuz: 3/10</span>
    </div>
  </div>
  
  <!-- Ask Cuz Widget -->
  <div id="ask-cuz-panel">
    <div class="cuz-avatar-3d"></div>
    <div class="chat-interface">
      <div id="cuz-messages"></div>
      <input type="text" id="cuz-input" placeholder="Ask Cuz..." />
      <button onclick="askCuz()">Ask</button>
    </div>
  </div>
  
  <!-- Today's Creature -->
  <div id="daily-creature">
    <h3>Today's Creature</h3>
    <div class="creature-card">
      <img src="creatures/gold-ember.png" />
      <h4>Gold Ember</h4>
      <p>Yellow + Black | Realism: 2/10</p>
      <button onclick="startEncounter()">Meet on the Road</button>
    </div>
  </div>
  
  <!-- Lockout Modal -->
  <div id="lockout-modal" class="hidden">
    <h2>🌙 Time to Rest!</h2>
    <p>Your brain needs sleep to remember what you learned today.</p>
    <p>Come back tomorrow at 9 AM EST for Brick #4!</p>
    <div class="countdown">14:32:18 until next session</div>
    <button onclick="showCollection()">Review Collection</button>
    <button onclick="exitGame()">Exit to Academy</button>
  </div>
</body>
</html>
```

---

## 🔄 Daily Update System

### What Updates Each Day at 9 AM EST

1. **New Creature Spawn**
   - Realistic AR model generated
   - Challenge created
   - 24-hour availability window

2. **Avatar Evolution**
   - Visual upgrade applied
   - New animation unlocked
   - Voice/personality refinement

3. **Road Progress**
   - Next brick unlocked
   - Previous bricks show "completed"
   - New gate appears at checkpoint

4. **Ask Cuz Reset**
   - Question count reset to 10
   - New daily fact available
   - Personality adapts to player's progress

5. **Leaderboard Update**
   - Class rankings refresh
   - Weekly challenges reset (Mondays)
   - Special events announced

---

## 🎯 Game Loop: The "Right Road"

```
1. LOGIN (Any time)
   ↓
2. Check Daily Creature
   ↓
3. Ask Cuz questions (if needed) ← 10 limit
   ↓
4. AR Mode: Walk Cotton Brick Road
   ↓
5. Encounter Creature ← 5 per day max
   ↓
6. Complete Phonics Challenge
   ↓
7. Advance 1 Brick
   ↓
8. Hit Lockout Gate OR Time Limit (20 min)
   ↓
9. Optional: Review, Collection, Ask Cuz
   ↓
10. LOGOUT ← Encouraged after 20 min
   ↓
11. Wait for 9 AM EST tomorrow
   ↓
12. REPEAT (Brick #2, #3, #4... #100)
```

---

## 📊 Success Metrics (Healthy Usage)

| Metric | Target | Why |
|--------|--------|-----|
| Avg session | 15-20 min | Prevents fatigue |
| Daily return rate | 70%+ | Habit formation |
| Creatures encountered | 3-5/day | Meaningful progress |
| Bricks/week | 7 (1/day) | Sustainable pace |
| Ask Cuz usage | 5-8/day | Engagement, not dependency |
| Castle completion | ~100 days | Long-term goal |

---

## 🔒 Safety Features

### Parent Dashboard
```
Child: [Name]
Today's Play: 18 minutes
Bricks Completed: 3/100
Creatures Met: Gold Ember, Moss Pulse
Questions Asked: 7
Learning Focus: Phonics, Biology

[Set stricter limits] [View activity] [Pause account]
```

### Automatic Safeguards
- Session timer visible at all times
- Gentle warnings at 15 min, 17 min, 19 min
- Hard stop at 20 min with positive messaging
- No "pay to continue" or "watch ad to unlock"
- Weekend bonuses are extra, not makeup for missed days

---

*Powered by SkyLockr™ | AI by Ad9x AI Engine*  
*Inspired by real Colombian poison dart frog species*  
*Mrs. Cotton's Academy — Cotton Brick Road*
