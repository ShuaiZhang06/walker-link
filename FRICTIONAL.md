# FRICTIONAL — walker-link

An honest log of how this change actually got made: what I tried, what I expected, what happened,
what I checked or changed in response, and which part of it was mine rather than the AI's.

**How this file was written (label, as required).** It is **retrospective**. I did not keep a live
diary while working. I wrote it on **2026-09-19**, after the work up to commit `9586f41`, by going
back through the Claude Code session transcripts, the fourteen commits on
`link-character-and-section-03`, and the files in `evidence/`. Every number quoted here comes from a
commit message, a named check, or an evidence file — not from memory. Where an entry records an
impression of mine rather than a measurement, it says so. Nothing here is invented: where the record
did not tell me something, I answered it myself rather than letting the AI guess, and where nobody
knows the answer it is in §5 as an open question.

**Tools and roles.** Claude Opus 5 in Claude Code (desktop) did the editing; I directed, played,
judged and approved. Engine: Godot 4.7.2 on a MacBook Air M3 (macOS 15.1). The split is in §4.

---

## 1. How I set the work up

My first working prompt asked for a plan and forbade editing:

> Read this project's README, build report, and my CHANGE-BRIEF.md. Use Walker's brief → build →
> playtest → inspect → revise workflow. First locate the character drawing and collider, level data,
> drawing code, camera bounds, finish logic, and relevant tests. Propose the smallest plan for my
> character replacement and level extension. **Do not edit yet.** After I approve a step, implement
> only that step, show the diff, run the relevant checks, and tell me what still requires human
> playtesting.

That shape held for the whole assignment: four bounded steps (A character, B drawing
parameterization, C level, D copy/evidence), one step per approval, a commit at every step, and
"what still needs a human" reported at the end of each. It is the reason the failures below are
recoverable and visible in the history instead of buried in one big diff — and the reason Step C
took seven commits rather than one.

---

## 2. The log

### 2.0 Before any of my code: the editor rewrote the engine file

**What happened.** I imported the starter into Godot and opened the editor myself, before writing
anything. A later read-only inspection pass caught it: `git diff` showed `godot/project.godot` had
been rewritten — the starter author's one-line header comment replaced by Godot's default template,
a blank line added after every `[section]`, and `window/stretch/aspect="keep"` plus
`[physics] common/physics_ticks_per_second=60` deleted. One of the seventeen source hashes in
`evidence/build-manifest.json` no longer matched.

**What I expected.** That opening a project to look at it changes nothing.

**What I asked, and what came back.** I asked whether I had to commit this and whether the record
was worth keeping, then asked the sharper question: *if I restore the comment, will running the
project just wipe it again?* Instead of guessing, Claude reproduced it in a scratch project — run
the game: not rewritten; run it repeatedly: not rewritten; open and close the editor: not rewritten;
**change any Project Setting: whole file rewritten**, and every comment in it is lost, not just the
header. The two deleted settings were verified to equal the engine defaults, so behaviour was
unchanged.

**What I did.** Committed the normalized file together with the four `godot/tests/*.gd.uid` files
Godot generated (`efcd71f`), and accepted that `project.godot` is an engine-owned file. Honest cost:
the starter's one-line description comment is gone and I did not relocate it anywhere.

**Learned.** "It changed by itself" is testable in four commands. Also that a build manifest full of
source hashes is only useful if you actually look at which hash moved.

**Same session, separate friction:** renaming the GitHub repo. `gh repo rename` failed because two
remotes existed and no default repo was set; after `gh repo set-default` the interactive
confirmation prompt collided with my terminal and fed escape sequences to zsh
(`zsh: command not found: 1R`). Claude did not assume the rename had gone through — it checked, found
the repo still named `walker-jumpman`, and had me `reset` the terminal and re-run with `--yes`. It
then split the 35 remaining `walker-jumpman` strings into "yours, change them" and "upstream's or
quoted history, changing them would create dead links or falsify a quote". I accepted that split.

### 2.1 Predict — the brief (`3ea2044`, baseline `028d3f4`)

**Mine:** the character concept (a Link-styled adventurer) and the level idea (a spiked step and a
chasm).

**Claude's:** the arithmetic and the risk list. From `tuning.gd` it derived the reach budget
— 53.3 px peak rise, 0.667 s airtime, ~106 px horizontal — and sized every planned gap inside it. It
also read the drawing code and predicted seven failure cases (the assignment asks for two), most of
them consequences of hard-coded draw coordinates: spikes painted at a literal `y = 320` while their
trigger follows the rect, a flag pole drawn `320 → 250`, a backdrop that stops at x = 1400, grid
loops ending at 960, a HUD denominator of 852.

**One thing it added that I accepted too easily.** The assignment wants "a clear player decision".
Claude proposed a fork — a high ledge (`P2H`) versus a low stone (`P2L`) — and I took it.

**One thing it warned me about that I deferred.** Before Step C, while re-reading the planned
coordinates, it flagged a risk the brief had not predicted and numbered it F8: `P2L` sits directly
under `P2H` with 12 px of headroom, and a full jump from `P1` rises above `P2H`'s top surface, so
anyone aiming for the low stone would likely bonk or land on the high ledge instead. It asked me to
decide: separate them, or keep the overlap deliberately. I answered **"keep P2L/P2H for now"** and
started Step A. That deferral is the single most expensive decision I made — see §2.4.

A pre-change baseline was recorded before the first edit: 25 checks / 0 failures, scripted route
ending at `(912.88, 319.93)` in 325 ticks (`028d3f4`).

### 2.2 Step A — the character (`7e9bd41`)

**Done:** `player.gd::_draw()` replaced; `_ready()`, `_physics_process` and `tuning.gd` untouched
(visible in the diff — no hunk before line 67). Checks stayed 25/0 and 9/0.

**What actually caught the defects: looking at rendered plates, not reasoning.** Claude built
`tests/capture_character.gd`, a pose sheet that outlines the real 18×28 collider over the drawing,
and the first sheet showed three problems — the cap tail completely covered the ear; the sword was
invisible (light steel on a light backdrop); and **the airborne pose was identical to standing**.
That last one is my brief's own error: §1 says "in the air the legs tuck (stride term already goes to
0)", but stride going to 0 leaves the legs at *full* length. An explicit `tuck` was added.

**My contribution here was playing it.** After the fixes I played the build and said one thing: the
sword needs to be pointed. Not a measurement, an impression at 1× — the flat `draw_line` blade read
as a stick. It became a five-point tapered polygon; measured tip overhang went from 4.89 px to
4.5 px, still inside the ≤5 px I committed to. I kept `capture_character.gd` in the repo when asked,
because F6 needs repeatable evidence.

**Unexplained, recorded anyway:** partway through, files showed up staged in `git status` without
anyone running `git add` (probably the editor or the desktop app). The index was reset; the working
tree was untouched.

### 2.3 Step B — parameterize the drawing (`b6b9a97`, `13ab92c`)

**The plan was to prove a refactor changed no pixels.** First attempt at a baseline: use the existing
`capture_game.gd` frames. **It failed** — `03-jump` and `04-complete` are not reproducible between
runs, because the character's `sin(tick * 0.7)` stride phase depends on which physics frame the grab
lands on. A baseline that differs from itself proves nothing.

**Response:** a new tool, `tests/capture_level.gd` — paused, player and HUD hidden, pure static art —
verified byte-identical across two runs, then committed *with its baseline as its own commit*
(`b6b9a97`) so that the refactor commit afterwards could be checked against it. It was: after
deriving the backdrop, grid, spike silhouette, flag pole and HUD denominator from the data
(`13ab92c`), the level plates came out byte-identical. `_spike_points()` became the one function both
`_draw()` and `_add_area()` call, which is what makes F1 ("ghost spikes") structurally impossible
rather than merely untriggered.

Two literals were left on purpose and handed forward: the hand-placed hills (irregular by nature) and
the section labels (copy, not geometry). Both came back to bite in Step C/D — see below.

### 2.4 Step C — Section 03 (`ad65f59` → `834af1a`, seven commits)

This is where most of the friction is. Five of the seven commits exist because I played the build and
did not like what I found.

**(1) Built exactly as predicted — and the central claim collapsed (`ad65f59`).** Width 1600, the
spike stair, the `P2H`/`P2L` fork, the plateau, finish at 1540; 31 checks / 0 failures. F4 held:
`P2H` is reachable by input alone, landing at `(1251.95, 247.93)`. But the take-off sweep — seven
take-offs across `P1`'s strip — returned **5 landings on the high ledge, 0 on the low stone, 2
falls**. Exactly the F8 I had deferred. The cause is geometric: the arc returns to the ledge's height
80 px out and to the stone's height 114 px out, only 34 px apart, while the usable take-off strip is
40 px wide. The "precision-at-height versus precision-at-distance" decision in my brief did not
exist. It is withdrawn in the CHANGE-BRIEF revision log rather than edited out of §2.

**(2) I played it and rejected the shape (`ad73f12`).** Independently of F8, the section was wrong:
"a spiked step" to me means a short step standing on the normal floor that you must **jump over**;
what was built raised a whole stretch of floor and put spikes on top of it — something you walk along.
I told it: all ordinary ground at the same height, then add the step; and replace the two stones with
one high stone. Rebuilt on flat y = 320 ground, spikes on a block, inset 4 px per side so a body
stopped by the block's face cannot touch a trigger. New check `step-is-jumped-not-stood-on` sweeps
six take-offs: 4 clear, 2 die, **0 land on it** — the claim "it cannot be used as footing" is measured,
not asserted.

**(3) One pit, and a taller step (`f79aaf1`).** I said there should be only one pit before the spiked
step. Claude did not guess which one — it asked, listing both (the 48 px entry pit it had added, and
the 144 px chasm), and I clarified. It also asked how tall the step should be, offered 36/40 px with a
formula-based warning that higher means a narrower safe window, and recommended 36. **I chose 40.**
Then its own warning turned out to be wrong: the continuous-arc formula predicted an ~11 px take-off
window; measured, it is **24 px (~9 ticks)**, because the spikes are triangles and their outline near
both ends is far below the apex. Recorded as a prediction that measurement corrected.

**(4) and (5) Too much empty floor, twice (`a15f18b`, `f4bfa1f`).** Playing it, the run-up before the
step was a long walk with nothing in it. The step moved 1096 → 1024. In the same reply Claude
volunteered the cost rather than waiting for me to find it: the empty stretch had simply moved to the
right of the step (176 px). I played again, agreed, and asked for both sides to be cut — and asked
whether it had moved the platform; it corrected me: the ground rect never moved, the step moved
*inside* it. Final: ground 272 → 152 px, step at 992, world **1600 → 1480** (my brief's "960 → 1600"
is now wrong and says so), route 559 → 514 ticks. The measured consequence, which Claude flagged as
the thing to playtest: the hop lands at 1052–1077 and the stone's take-off window opens at 1061, so
there are only **26–51 px (10–19 ticks, plus 6 ticks of coyote)** between landing and the next
take-off. That is the tightest rhythm in the level and it is a deliberate cost of my shortening.

**(6) and (7) The hills: a fix I asked for, then rejected (`af7609f`, `834af1a`).** Playing toward the
finish I saw two background hills overlapping. Cause: the starter's hills are hand-placed at
100/470/770 with irregular gaps, each hill is 280 px wide, and the two I appended left a 230 px gap.
Claude replaced the list with a derived even 320 px spacing — which fixed it and **moved two of the
starter's own hills**, making the original section's backdrop differ for the first time on this
branch. It said so plainly and offered the fallback. **I rejected the trade:** keep the starter's
picture untouched, hills need not be even, but the hill behind the flag must be whole. Final:
hand-placed `[100, 470, 770, 1290]`, one 280 px hill standing at 1200–1480 so its right foot lands on
the world's edge. Proof, not assertion: diffed against `f4bfa1f`, `01-menu`, `02-failure`, `03-jump`
and `level-00.png` are byte-identical. Accepted cost: 960–1200 is bare backdrop, because exactly one
hill fits there.

### 2.5 Step D — copy and evidence (`b9b34d6`)

I asked for the in-game title to become **WALKER / LINK**; `project.godot config/name` followed. The
Section 03 label landed at (966, 227/249) — in the bare 960–1200 stretch the hill decision created, so
that cost paid for itself. The menu line still described a level that no longer existed ("Cross two
gaps. Clear the spikes. Reach the flag.") and was rewritten. A 34th check, `hud-copy-fits-its-card`,
measures all thirteen centred HUD strings against the cards they are drawn into (tightest: the new
menu line, 269 px of 302) so copy cannot silently overflow again.

**A process decision of mine:** at Step C I told it to stop writing the CHANGE-BRIEF revision log
after each change and write it once at Step D. That kept the commits clean but means those nine
entries are retrospective-within-the-day, written from the session record rather than live. They are
accurate; they are not contemporaneous, and this sentence is the label.

### 2.6 TEST-REPORT (`9586f41`)

Claude stopped before writing and asked four questions, because the report asserts things only I can
know. I answered: the check table should describe my playtest of the **final** build, which I had
already played and found fine; **no second playtester**; re-run the automated checks now rather than
cite the old run; English. It then re-ran both suites at `b9b34d6` — **34/0** and **9/0** — and
re-recorded the manifest (26 source hashes, 43 machine checks).

**Two honesty points from that session.** `scripts/record-build.cjs:32` hard-codes
`human_playtest_sessions: 0`; it was left alone and called out in the report as not-a-measurement,
rather than edited to 1. And the first draft's **Machine** row was the starter author's machine
(M4 Pro / macOS 26.5.1) copied out of BUILD-REPORT — plausible, wrong, and mine to catch. I did, and
it was replaced with this machine's real values.

---

## 3. Predictions that measurement overturned

| Prediction | Who made it | What measurement said | Where |
| --- | --- | --- | --- |
| "In the air the legs tuck — the stride term already goes to 0" | Me, CHANGE-BRIEF §1 | Stride at 0 leaves legs at *full* length; airborne pose was identical to standing until an explicit tuck was added | Step A pose plates, `7e9bd41` |
| A high-ledge / low-stone fork gives the player a real choice | Claude, accepted by me | 7 take-offs → 5 ledge, 0 stone, 2 falls. The choice did not exist; claim withdrawn | `ad65f59`, CHANGE-BRIEF §6 |
| A 40 px obstacle leaves an ~11 px take-off window | Claude (continuous-arc formula) | **24 px, ~9 ticks** — triangular spikes are far below their apex near both ends | `f79aaf1` |
| `capture_game.gd` frames can serve as a pixel baseline | Claude | Not reproducible: stride phase depends on the capture frame. Replaced by a static plate tool | `b6b9a97` |
| Even-spacing the hills is the fix for the overlap | Claude | It works and costs the starter's own backdrop; rejected by me | `af7609f` → `834af1a` |
| The world will grow 960 → 1600 | Me, CHANGE-BRIEF §3.1 | 1480, after the section was tightened twice | `f4bfa1f` |

---

## 4. Human and AI contributions

**Mine (Shuai Zhang).** The character concept and the level idea. The working method (plan first, one
step per approval, commit per step). Forking and renaming the repository. Importing the project and
opening the Godot editor — which is what normalized `project.godot` and generated the `.uid` files, so
that piece of friction is mine, not the AI's. **Every hand playtest**: the four observations that drove
the revisions — blade not pointed, the step built as raised floor, too much empty floor on both sides,
hills overlapping with the finish hill cut — all came from playing the build with the keyboard, not
from reading diffs or plates. Every geometry decision: single stone instead of the fork, 40 px step
(against the recommended 36), one pit, both flats shortened, starter's hills restored with a whole
hill at the finish, title WALKER / LINK. Correcting the Machine row. Deferring F8, which cost a
rebuild. And reading the documents back in translation to check they said what I meant.

**Claude's.** Locating the drawing, collider, level data, camera clamp, finish logic and tests;
deriving the reach budget from `tuning.gd`; drafting CHANGE-BRIEF, TEST-REPORT, README changes and
every commit message; all GDScript edits (`player.gd::_draw()`, `session.gd` parameterization, the
level JSON, the route fixture, nine new checks); the measurement fixtures and sweeps that produced
every number quoted in this repository; `capture_character.gd` and `capture_level.gd`; running the
headless suites.

**What I accepted:** the four-step decomposition; the reach arithmetic; parameterizing the hard-coded
draw coordinates before touching the level (Step B is the reason moving the finish did not leave a
flag floating over the old platform); the byte-identical-plate method as proof a refactor changed
nothing; the 4 px spike inset so the step's face blocks without killing; the nine new checks and the
*strengthened* completion assertion (body rect must intersect the finish rect, not merely
`state == COMPLETE`); treating `project.godot` as engine-owned.

**What I modified or redirected:** the shape of Section 03 (twice); the step height; the number of
pits; the length of both flat stretches; the hill row; the report's Machine row; the timing of the
revision log; the in-game title.

**What I rejected:** the even-spaced hill row, because it moved the starter's hills — correctness of
the fix was not the point, preserving the starter's picture was; and, after measurement, the
two-route fork I had originally approved.

**Where the AI refused to speak for me, correctly:** it would not write the hand-playtest table until
I answered whether and how I had played; it did not invent a second playtester; it did not edit
`human_playtest_sessions` from 0 to 1; and it stopped to ask which pit I meant instead of guessing.
I am satisfied I can explain every line of the change, including the parts I did not type.

---

## 5. Open questions, and what is not done

1. **F6 is still unsettled by anything but my eyes.** Whether the sword and shield read as held props
   rather than as part of the hitbox is a human judgment. The overhang is measured (4.5 / 3.5 /
   1.42 px) and I have played it without being confused, but no one else has looked.
2. **The 24 px take-off window on the spiked step, and the 26–51 px chain into the stone.** Both are
   measured and both are clearable by me. Whether they are fair to a first-time player is unknown —
   there has been no second playtester.
3. **The shield visibly hangs past the platform edge when standing at a ledge.** Seen in Step A's
   plates, deliberately left alone. Still open.

---

## 6. Traceability

**Commits on this branch** (all with `Co-Authored-By: Claude Opus 5`):

| Commit | What it is |
| --- | --- |
| `efcd71f` | The editor-normalized `project.godot` + four `.uid` files (on `main`, §2.0) |
| `3ea2044` | CHANGE-BRIEF, written before any implementation |
| `028d3f4` | Pre-change baseline run: 25/0, route 325 ticks |
| `7e9bd41` | Step A — the Link-styled drawing, plus `capture_character.gd` |
| `b6b9a97` | The deterministic level-plate tool **and its baseline**, committed before the refactor |
| `13ab92c` | Step B — drawing derived from the data; plates byte-identical |
| `ad65f59` | Step C as the brief predicted — and the sweep that killed the fork (F8) |
| `ad73f12` | Rebuild after my playtest: flat ground, a step to jump over, one stone |
| `f79aaf1` | One chasm, 40 px step; the 11 px-vs-24 px correction |
| `a15f18b` | Step moved toward the entrance |
| `f4bfa1f` | Both flats tightened; world 1600 → 1480; the 26–51 px chain measured |
| `af7609f` | Hills derived evenly — the fix I then rejected |
| `834af1a` | Starter's hills restored, whole hill at the finish; pixel diff as proof |
| `b9b34d6` | Step D — WALKER / LINK, Section 03 label, copy, revision log, evidence |
| `9586f41` | TEST-REPORT, today's re-run (34/0, 9/0), re-recorded manifest |

**Checks named in this log:** `step-is-jumped-not-stood-on`, `step-blocks-the-walk`,
`step-spike-safe-strip`, `high-stone-reachable`, `stone-takeoff-sweep`, `hazard-art-matches-trigger`,
`plateau-death-respawn`, `hill-row-clear-and-whole`, `hud-copy-fits-its-card`, `complete-real-route`.

**Evidence:** every run since the starter's own is kept in `evidence/` — including the starter's
original 4-failure run (`mechanics-1789078423.29998.json`) and this fork's pre-change baseline.
Nothing was deleted. Pose plates: `evidence/screens/character/`; level plates: `evidence/screens/level/`.

**Sessions this log was reconstructed from:** the read-only inspection of the starter; the brief
session; the repo-rename / engine-file session; Step A+B; Step C+D; the TEST-REPORT session; two
translation-check sessions (CHANGE-BRIEF, TEST-REPORT); and this one, which wrote this file.

**Related documents:** [CHANGE-BRIEF.md](CHANGE-BRIEF.md) (predictions + append-only revision log),
[TEST-REPORT.md](TEST-REPORT.md) (the playtest and check record), [README.md](README.md) (what the
fork changes), [BUILD-REPORT.md](BUILD-REPORT.md) (the starter author's own build record, untouched).
