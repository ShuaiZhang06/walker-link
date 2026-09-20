# CHANGE-BRIEF — walker-link

**Stage 1 (Predict). Written before implementation. This record is append-only: later
revisions are added to the Revision log at the bottom, not edited into the predictions above.**

- **Project:** `walker-link` (fork of the starter, prefix `walker-` preserved)
- **Starter credit:** Extends [nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)
  — "First Steps" playable prototype, Godot 4.7 / GDScript. All engine architecture, movement
  tuning, state machine, HUD, and the original level section are the starter author's work.
- **Work happens in:** `ShuaiZhang06/walker-link` (`origin`), with the instructor repo kept as
  read-only `upstream`. No commits are pushed to `upstream`.
- **Author:** Shuai Zhang (zhang.s3@northeastern.edu)

---

## 1. Character concept — "Walker Link", the green-cap wanderer

The starter's character (`godot/features/player/player.gd::_draw()`) is a stack of five
`draw_rect` calls: a dark 18x24 box, a blue inner box, an orange belt band, two leg blocks with a
`sin()` stride, and a 5x5 eye patch that flips with `facing`. Its silhouette is a plain rectangle.

My character is a **Link-inspired adventurer** (original geometric drawing, see §5 Provenance):

| Feature | How it is drawn | Why it changes the silhouette |
| --- | --- | --- |
| Pointed green cap | Triangle polygon over the head, with a cap-tail triangle trailing *behind* the facing direction | Head stops being a square; the outline now reads as a triangle-on-a-box |
| Green tunic with flared skirt | Trapezoid body instead of the starter's inner rect: narrow shoulders, wider hem at the waist | Lower body widens, so the standing pose is no longer a uniform column |
| Pointed ear + blonde fringe | Small triangle at the trailing side of the head; light fringe rect under the cap brim | Readable face direction at 1x zoom without relying on the eye dot alone |
| Round shield on the **leading** arm | Rect + inner rect, drawn on the `facing` side at chest height | Adds a distinct bump to the leading edge of the silhouette |
| Sword on the **trailing** arm | Thin blade rect + crossguard rect + pommel, angled up-back | Adds a diagonal to the trailing edge; the pose reads as "armed" in one frame |

**Preserved for the visual change (hard constraint):** every value in
`features/player/tuning.gd`, and the collider created in `player.gd::_ready()`
(`RectangleShape2D` 18x28 at local `(0,-14)`, `collision_layer = 2`, `collision_mask = 1`,
`floor_snap_length = 1.0`). The new art is `_draw()`-only.

**Readability rules I am committing to:**
- The **torso, cap, and legs stay inside the 18x28 collider box** (x in [-9, 9], y in [-28, 0]),
  so what the player reads as "the body" is exactly what collides.
- The **sword and shield are allowed to extend past the collider** (they are held out from the
  body), but by at most ~5px, and they are drawn in a lighter/secondary color so they read as
  props rather than hitbox. Props never get a collision shape.
- Cap-tail, sword, shield, ear, and eye all mirror on `facing`, so the character is legible
  facing left and facing right.
- In the air (`not is_on_floor()`) the legs tuck (stride term already goes to 0) and the cap-tail
  lifts, so the jump pose is distinguishable from the run pose.

## 2. Level extension — Section 03, "The Spike Stair and the Chasm"

The starter level (`godot/levels/first_steps.json`) is 960px wide: ground `0..448`, platform
`512..736`, platform `784..960`, two small ledges, one ground spike cluster at x=320, finish at
x=916. Route: two gaps, one hazard, one flag.

I extend the world to **1600px** and move the finish to the far end. The original section stays
**byte-identical** in the JSON and remains the only way to reach the new section.

### Planned geometry (reach budget below; numbers may be revised, tuning may not)

| New element | Rect `[x, y, w, h]` | Jump it asks for |
| --- | --- | --- |
| `P1` spike stair | `[1008, 288, 176, 32]` | From the end of the starter's last platform (x=960, top y=320): **gap 48px, rise 32px** |
| `H2` spikes **on P1's surface** | `[1088, 272, 24, 16]` | Splits P1 into an 80px landing strip and a 72px take-off strip; the player must hop the spikes, and the hop shortens the runway for the next jump |
| `P2L` low stone (route B) | `[1248, 304, 40, 16]` | From P1 (y=288): **gap 64px, drop 16px**, onto a narrow 40px stone |
| `P2H` high ledge (route A) | `[1240, 248, 40, 16]` | From P1 (y=288): **gap 56px, rise 40px** — deliberately close to the engine's 53.3px ceiling |
| `P3` cliff top / finish plateau | `[1352, 288, 248, 96]` | From `P2L`: gap 64px, rise 16px. From `P2H`: gap 72px, drop 40px |
| `finish` (moved) | `[916, 264, 24, 56]` → `[1540, 232, 24, 56]` | Sits on `P3`, so the new section must be completed to win |

New landings that require a jump: **P1, P2L/P2H, P3** — three, against the required minimum of two.

### The decision the extension asks for

At the right edge of `P1` (x≈1184) the chasm to `P3` is **168px wide** — larger than the engine's
~106px maximum leap, so it cannot be cleared directly. The player must choose:

- **Route B (low stone):** two modest jumps, but the take-off strip is only the 72px of `P1` left
  of the spikes, and the mid-point is a narrow 40px stone over the fall boundary.
- **Route A (high ledge):** one near-maximum vertical jump (40px rise, vs a 53.3px ceiling) to a
  small ledge, rewarded with a safe descending 72px glide to the plateau.

So: *precision-at-height* versus *precision-at-distance*, plus a secondary micro-decision about
where to take off relative to the spikes on `P1`. It is not an empty stretch of floor.

### Reach budget this geometry is derived from (measured from the starter's own tuning)

With `jump_velocity = -320`, `gravity = 960`, `speed = 160`:
- peak rise = 320² / (2·960) = **53.3px** (the starter's own test asserts 53.33 ± 5)
- full airtime = 2·320/960 = 0.667s → **~106px** horizontal reach at full speed
- at +32px of height the arc still gives a ~0.42s window → ~67px of horizontal travel
- at +16px of height, ~0.56s → ~89px

Every planned gap above sits inside these numbers with margin. **If a jump turns out to be
impossible in play, I revise the geometry (narrow the gap, lower the ledge). I do not touch
`tuning.gd` and I do not remove a collision check.**

## 3. What must remain unchanged

| Area | Commitment |
| --- | --- |
| Movement/jump tuning | `features/player/tuning.gd` unmodified: speed 160, accel 1280, decel 1920, jump −320, gravity 960, terminal 480, coyote 6, buffer 6 |
| Controls | Same `InputMap` in `session.gd::_setup_input()`: A/D + arrows, Space jump, R retry, Esc/P pause, Enter confirm, M menu. No new actions, no remapping |
| Jump feel | One jump, no double jump (`opportunity_consumed`), coyote 6 ticks, buffer 6 ticks, `require_jump_release` after unpause |
| Collision behavior | Player collider 18x28 at `(0,-14)`; world on layer 1 / player on layer 2; hazards keep **exact triangular `CollisionPolygon2D` silhouettes**, no oversized invisible boxes |
| Retry | `retry_remaining = 0.55`, auto-respawn at `spawn = [64, 320]`, `deaths` counter, `contact_settle_ticks = 2` phantom-death guard, duplicate-death guard in `resolve_contacts()`, unlimited retries |
| Pause | Esc/P toggle, focus-loss auto-pause, position/timer frozen while paused |
| Completion | Goal is an `Area2D` on layer 16 checked by `overlaps_body()`; death takes precedence over finish in the same step |
| Death boundary | `fall_y = 430` |
| Original section | All five starter `solids`, the ledges, and the ground hazard at x=320 keep their exact coordinates and stay walkable |
| Existing tests | All checks in `godot/tests/test_game.gd` must still pass, 0 failures |

### Changes I judge necessary, and why (to be tested explicitly)

These are consequences of the starter's hard-coded draw coordinates, not gameplay retunes:

1. `level.width` 960 → 1600, and the camera clamp / background rect / grid loops / hill positions
   in `session.gd::_draw()` derived from `level.width` instead of literal 960 / 1400.
2. **Hazard drawing parameterized.** `_draw()` currently draws spikes at a literal `y = 320` with
   `i*8` spacing, while `_add_area()` builds the trigger polygons from the rect's own position and
   `size.x / 3.0`. On an elevated step these disagree. Both will be generated from one shared
   helper so the drawn triangles are the collision triangles.
3. **Finish marker drawing parameterized.** The pole is currently drawn from a literal `y = 320`
   up to `250`; it will be derived from the finish rect so the flag sits on the plateau.
4. **HUD progress bar** denominator `(x - 64) / 852` (`ui/hud.gd`) derived from the finish x, or it
   pins to 100% halfway through the level.
5. **Labels:** add a "03 / ..." section label; move the "FINISH" label off x=878; update the menu
   copy "Cross two gaps. Clear the spikes. Reach the flag." to describe the real route.
6. **`tests/route_driver.gd` jump marks** extended past the old finish. This is a test fixture, not
   game tuning: it only presses the same keys a player presses.
7. `player.gd::_draw()` fully replaced (visual only; no physics line touched).

## 4. Predicted failure cases and how I will check them

**F1 — Ghost spikes: the spikes on `P1` are drawn on the ground while the trigger sits on the
step.** Cause: the hard-coded `y = 320` in `session.gd::_draw()` plus the `i*8` vs `size.x/3.0`
spacing mismatch. Symptom: red triangles painted at ground level under the step, and an invisible
kill zone on the step surface (or a harmless-looking spike). *Check:* a new automated case that
walks the player onto the on-step spike x-range and asserts `state == DYING`, plus a companion case
that stands on the safe strip 20px away and asserts no death; and a test asserting the drawn
triangle vertices equal the `CollisionPolygon2D` vertices (same helper, same numbers). Plus a
screenshot of the step.

**F2 — The world ends at x=960.** Background is `draw_rect(-400, -200, 1800, 900)` (ends at
x=1400), the grid loops are `range(0, 961, 32)` and `draw_line(..., 960, ...)`, and the hills are at
literal `[100, 470, 770]`. Symptom: the new section is played over a grey/void background with a
visible seam, and the camera stops early. *Check:* screenshot at the camera's right clamp
(`level.width - 320`) and on the plateau; assert the loops and the background rect are computed
from `level.width`; confirm the right wall `_add_solid(Rect2(level.width, 0, 32, 430))` moved with it.

**F3 — The finish flag floats or buries itself.** The pole is drawn `320 → 250` with literal
coordinates while the goal `Area2D` moves to y=232 on the plateau. Symptom: a flag drawn in mid-air
above the old platform, or a win triggered at a spot with no visible flag. *Check:* assert the drawn
pole base y equals the finish rect's bottom; run the scripted route and assert it ends
`COMPLETE` with the player x within the new finish rect (≈1540), not at 916; screenshot.

**F4 — The 40px high ledge (`P2H`) is not actually reachable.** The 53.3px ceiling is a continuous
approximation; at 60Hz with discrete steps, and with a 56px gap to cross at the same time, the arc
may not clear it — which would silently collapse my two-route decision into one route. *Check:* a
fixture that drives input (no position edits) from `P1` toward `P2H` and asserts the player ends
`is_on_floor()` with feet at y≈248; and the same for `P2L`. If route A fails, I lower `P2H` and/or
shorten its gap, re-run, and log the revision. I will not raise `jump_velocity`.

**F5 — The scripted route regression-tests nothing.** `tests/route_driver.gd` has five hard-coded
`jump_marks` ending at 712, and `check("complete-real-route", ...)` expects the old finish.
Symptom: the route test either fails outright or "passes" without ever entering Section 03.
*Check:* headless `godot --headless --path godot -s tests/test_game.gd` must report 0 failures, with
`jump_marks_used` equal to the new mark count and the recorded end position inside the new finish
rect. I will run the route for **both** branches of the fork.

**F6 — Sword and shield read as part of the hitbox.** Props extend past the 18x28 collider, so a
player may expect the shield to block a spike, or feel cheated when the blade visually overlaps a
hazard without dying. *Check:* screenshots facing left, facing right, standing at a ledge edge, and
mid-jump, comparing the art against a collider outline; keep the overhang ≤5px and the props in a
secondary color. Documented as a deliberate visual-only overhang.

**F7 — Retry/pause regressions from the wider world.** Respawn still has to land at `[64, 320]` and
the camera must re-clamp to 320 on restart from anywhere in Section 03. *Check:* the existing
`respawn`, `twenty-retries`, `pause-freezes`, and `focus-loss-pauses` cases must stay green, plus a
new case that dies on the plateau and asserts the respawn position and camera x.

## 5. Provenance and honesty notes

- **All art is original vector drawing** (`draw_rect`, `draw_colored_polygon`) written by me in
  `player.gd::_draw()`. No sprite sheet, no imported image, no Nintendo asset, no paid or
  AI-generated asset is used or required.
- The character is a **fan-styled homage** to the visual language of Nintendo's Link (green pointed
  cap, sword-and-shield pose), drawn from scratch as geometry. Link and The Legend of Zelda are
  Nintendo trademarks; this is coursework, not a distributed product, and the in-game character is
  named for this project rather than presented as Nintendo's character.
- Everything not listed in §1, §2, and §3 is the starter author's work.

## 6. Revision log

*(Append only. Original predictions above are never rewritten.)*

- **2026-09-17** — Initial brief written before any implementation.

- **2026-09-18 — Step A, character.** `player.gd::_draw()` replaced; `_ready()`,
  `_physics_process` and `tuning.gd` untouched. Three defects found by looking at the
  rendered plates, not by reasoning: the cap-tail covered the ear, the sword was invisible
  against the light backdrop, and the airborne pose was identical to standing (the brief's
  "legs tuck" was wrong — the stride term going to 0 leaves the legs at *full* length, so an
  explicit `tuck` was added). Measured prop overhang: sword tip **4.5px**, shield 3.5px,
  crossguard 1.42px — all inside the ≤5px commitment of §1. Checks 25/0 and 9/0. Added
  `tests/capture_character.gd`, a repeatable pose sheet with the 18x28 collider outlined.
  After playtesting the human asked for a pointed blade; the flat blade became a five-point
  tapered polygon (F6 remains a human judgment and is still open).

- **2026-09-18 — Step B, drawing parameterized.** Backdrop, grid, spikes, finish pole and the
  HUD denominator derived from `level.width` / the rects instead of 1800 / 961 / 960 / 320 /
  250 / 878 / 852. `_spike_points()` became the single source for a spike silhouette, used by
  both `_draw()` and `_add_area()`. Verified as a pure refactor: with the JSON unchanged, the
  level plates came out byte-identical. Two literals deliberately survived — the hill row
  (irregular by hand) and the section labels (copy) — and were handed to steps C and D.

- **2026-09-19 — Step C, first implementation, exactly as §2 predicted.** width 1600, P1 spike
  stair `[1008,288,176,32]`, H2 on its surface, P2H/P2L fork, plateau, finish at
  `[1540,232,24,56]`; route marks 932/1048/1166/1260; 31 checks / 0 failures.
  **F4 held:** P2H is reachable input-only, landing `(1251.95, 247.93)`.
  **F8 happened, and it is fatal to §2's central claim:** sweeping seven take-offs across P1's
  strip gives 5 landings on the high ledge, **0 on the low stone**, 2 falls. The two-route
  decision of §2 does not exist. The cause is geometric, not tuning: from P1 the arc returns to
  the high ledge's height 80px of travel out and to the low stone's height at 114px, only 34px
  apart, while P1's usable take-off strip is 40px wide — P2H intercepts every attempt. P2L was
  also a trap (12px of headroom under P2H: jumping from it bonks the ceiling and drops back, or
  falls into the chasm). **§2's "precision-at-height versus precision-at-distance" is withdrawn.**

- **2026-09-19 — Step C, revised after review: the section is rebuilt.** The human's reading of
  "a spike stair" was a short step standing on flat ground that must be *jumped over*, not a
  raised stretch of floor with spikes on top, and they asked for a single stone instead of the
  fork. All walkable ground in Section 03 is now y=320, the same height as the starter's. The
  spikes sit on a block standing on that ground, inset 4px on each side so a body blocked by
  the block's side cannot touch a trigger. **Machine-checked:** six take-offs across the hop
  range land on the step **zero** times — it cannot be used as footing.

- **2026-09-19 — Step C, three further revisions on review.** (1) The entry pit was removed:
  Section 03's ground runs on from the starter's last platform, so the section has exactly one
  fall pit, the 144px chasm. Route marks dropped from 9 to 8. (2) The step was raised to 40px
  of obstacle (24 block + 16 spike). **My own prediction was wrong here and the measurement
  corrected it:** the continuous-arc formula said the safe take-off window would shrink to
  ~11px, but it measured **24px (about 9 ticks)** — the spikes are triangles, so near both ends
  their outline is far below the apex and a body clears them earlier and later than a
  24x40 box would allow. (3) Both flat stretches around the step were cut: the step moved to
  992 and the ground from 272px to 152px, the stone, the platform and the finish moved left
  with it, and **the world shrank from 1600 to 1480** — the brief's §3.1 "960 → 1600" now reads
  960 → 1480.

- **2026-09-19 — Section 03 as built.** ground `[960,320,152,64]`, spiked step `[992,296,32,24]`
  with hazard `[996,280,24,16]`, high stone `[1152,280,40,16]`, far platform `[1256,320,224,64]`,
  finish `[1420,264,24,56]`. Measured windows, input-driven, no position edits in flight:
  step hop take-off **940.6–964.6** (early lands on the far slope, late hits the front); high
  stone take-off **1061–1103** (1058 and earlier hits the stone's left face and falls); the chain
  between them leaves **26–51px, 10–19 ticks**, between landing the hop and the next take-off.
  The chasm is 144px against a **112px** measured maximum leap, so the stone is the only way
  across. Three required jumps in the section, against the required minimum of two.

- **2026-09-19 — predicted failures, settled.** F1: `hazard-art-matches-trigger` asserts both
  hazards' painted triangles are their trigger polygons and that H2's base is the step's top
  (296), not the ground — ghost spikes cannot happen. F2: the backdrop, grid and right wall
  follow `level.width`; `level-00.png` stayed byte-identical while the world grew. F3: the pole
  and flag follow the finish rect, and `complete-real-route` now asserts the body overlaps the
  finish rect, not merely that the state is COMPLETE. F5: the route fixture reaches the new
  finish using all 8 marks in 514 ticks with 0 deaths. F7: `plateau-death-respawn` dies on the
  far platform and asserts respawn at `(64,320)` with the camera back at 320 from `width-320`.
  F4 and F8 are recorded above. **F6 is the one prediction no machine settled** — whether the
  sword and shield read as props rather than hitbox is still a human judgment.

- **2026-09-19 — hills, two reversals.** Appending to the starter's hand-placed hills
  (100/470/770) produced a pair that overlapped in front of the finish, because each hill is
  280px wide and the appended spacing was 230. Deriving the whole row from an even 320 spacing
  fixed it but moved two of the starter's own hills, which made the original section's backdrop
  differ for the first time; the human rejected that trade. Final: hand-placed
  `[100, 470, 770, 1290]`, the starter's three exactly as they were, and one whole 280px hill at
  1200..1480 whose right foot lands on the world's edge so the flag is not backed by a hill the
  screen cuts in half. Verified by diffing against the pre-hill commit: `01-menu`, `02-failure`,
  `03-jump` and `level-00.png` are byte-identical. Cost, accepted: 960..1200 has no hill,
  because only one 280px hill fits between the starter's last one and the world's edge. The
  Section 03 label now occupies that space.

- **2026-09-19 — Step D, copy and evidence.** In-game title `WALKER / JUMPMAN` → **`WALKER /
  LINK`** and `project.godot config/name` → `walker-link` (human request). Section label
  "03 / STEP AND STONE" + "Jump the step. Then the stone." added at (966, 227/249); the menu
  line became "Two gaps, a spiked step, a stone, then the flag.", which the old copy no longer
  described. New check `hud-copy-fits-its-card` measures all thirteen HUD strings against the
  boxes they are centred in (tightest is the new menu line at 269px of a 302px limit), so copy
  can no longer silently overflow a card. Evidence re-shot: four game frames, three level
  plates, four character plates; `node scripts/record-build.cjs` re-recorded 26 source hashes
  and 43 machine checks. **Final state: `test_game.gd` 34 checks / 0 failures,
  `test_keyboard.gd` 9 / 0, scripted route COMPLETE with 0 deaths.** `tuning.gd` was never
  touched, the collider was never touched, and the starter's five solids, ground hazard and
  spawn keep their exact coordinates.
