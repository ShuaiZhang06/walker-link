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
