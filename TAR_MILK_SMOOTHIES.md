# TAR MILK SMOOTHIES
### *Clearwater Inc. appreciates your participation.*

---

## What Is It

First-person horror game. You wake up in a facility run by Clearwater Inc. Nothing is explained. You descend through physics gauntlets — environmental puzzles, hazards, things that want to kill you. You survive, you get paid. You spend the money on meaningless shit for your room. You sleep. You wake up. You do it again.

Godot 4.6.1. Mono.

## The Vibe

Grunge. Not sterile like Portal, not ransacked like a zombie game. Actively used. The facility has been running too long and nobody cleans. Cigarette burns on counters. Bloodstains painted over. Fluorescent tubes that flicker next to newer ones bolted beside them. Smoky air, hazy light. Everything accumulates until it becomes cancerous.

Kurt Cobain 91-93. Not the aestheticized grunge — the real kind. Slightly damp. Smells like copper and artificial sweetener.

Clearwater is the brand. Clean, trustworthy, transparent. Tar milk is what's in the pipes.

## Structure

### The Descent

Rooms stack vertically. You descend via slides — fast, committed, one-way down. Each room is a physics gauntlet. Solve it, survive it, reach the exit. A new slide opens. Deeper.

### The Stairs

Every room has stairs going up. You can climb back to the top any time you want. The exit is real. It works. It is load-bearing theatre.

There's nothing up there for you.

### The Gauntlets

Physics-based environmental puzzles and hazards. Each room is a self-contained challenge. Procedural generation keeps them different across runs. The difficulty escalates with depth.

Not combat. Not shooting. You against the geometry, the physics, the environment. Things that crush, burn, drop, flood, seal, collapse.

### The Money

You get paid for completing gauntlets. The currency buys things for your personal chambers — furniture, decorations, smoothies. Trinkets. Meaningless comfort purchased with mortal risk.

The disproportion is the point. You almost died for a lamp.

### Replayability

Endless. The descent has no bottom. Runs are different every time — procedural gauntlets, branching paths, different hazards. Your choices prune the tree. What you did three rooms ago shapes what's available now.

Cash out whenever you want. Wake up. Descend again.

### The Questions

Still on the walls. Not interactive. The facility watches you. Text appears in rooms, on screens, scratched into surfaces. The questions from the old design — personal, escalating, unsettling. They're not for you to answer. They're the facility profiling you while you jump over saw blades for smoothie money.

## What Carries Over From Applablation

- Player controller (FPS, mouse look, WASD, sprint, jump)
- Adrenaline system (blur, wobble, audio compression, desaturation)
- Sliding doors
- The questions (as ambient set dressing, not mechanics)
- func_godot / Trenchbroom pipeline (for authored geometry pieces)

## What Dies

- Hand-placed world scene
- QuestionRunner as gameplay driver
- Yes/No button switches as interaction
- The Wall (cutscene ending)
- The gas elevator (scripted ending)
- Fixed room count / linear progression
- Everything that made it a walking sim

## New Architecture

Modular room scenes instanced dynamically. Only the current room + adjacent rooms exist at any time. Vertical stacking with slide (down) and stair (up) connections. Rooms are self-contained gauntlet units — spawned on descent, freed on distance.

The facility grows downward. The player's depth is the only progression metric that matters (besides money).

## Tech

- **Engine:** Godot 4.6
- **Room geometry:** Trenchbroom → func_godot (authored pieces composed procedurally)
- **Room instancing:** Dynamic, vertical stack
- **Physics:** Jolt (gauntlet hazards, environmental puzzles)
- **Target:** itch.io, free, Windows/Linux

---

*We don't force you to participate. You choose to. And that's what we love about you.*
