# TEST-REPORT — walker-link

Record of using and checking the modified game: the Link-styled character and the Section 03
extension. The design predictions being tested are in [CHANGE-BRIEF.md](CHANGE-BRIEF.md); the
starter author's own build record is [BUILD-REPORT.md](BUILD-REPORT.md) and is left untouched.

| | |
| --- | --- |
| **Source revision** | `b9b34d6` on `link-character-and-section-03` (tree clean apart from the two evidence files the runs below wrote and the regenerated manifest) |
| **Engine** | Godot **4.7.2.stable.official.ed1daf0bf**, Compatibility/OpenGL, 60-Hz physics |
| **Machine** | MacBook Air 15" (`Mac15,13`), Apple M3, 16 GB, macOS 15.1 build 24B83 (Darwin 24.1.0 arm64); 1280 × 720 window, 640 × 360 logical |
| **Build manifest** | [evidence/build-manifest.json](evidence/build-manifest.json) — `build_id 399cb7b6…`, 26 source hashes, 43 machine checks |
| **Level under test** | `width 1480`, spawn `[64, 320]`, `fall_y 430`, finish `[1420, 264, 24, 56]` |
| **Played by** | Shuai Zhang (author), 2026-09-19, on the final Step D build. No second playtester — see §4 |

---

## 1. Hand playtest

Launched with [walker-jumpman.command](walker-jumpman.command), which runs the normal main scene,
not a test driver, and played with the normal keyboard controls. The *Exercised* column lists what
that pass covered; the *Result* column is the author's own observation. Where a row cites a number,
the number comes from the named capture or automated check, not from eyeballing the screen.

| Check | Exercised | Result | Supporting evidence |
| --- | --- | --- | --- |
| **Startup and controls** | Enter to start; A/D and arrows to move; Space to jump; Esc/P to pause and Enter to resume; R to restart mid-run | Project runs and every control behaves as before the change; no console errors | [01-menu.png](evidence/screens/01-menu.png); `enter-start`, `keyboard-move`, `keyboard-jump`, `escape-pause`, `enter-resume`, `r-retry` |
| **Character appearance** | Standing, running and mid-jump poses, facing both ways, on flat ground and at a ledge edge | Facing is readable at 1× without relying on the eye dot; the airborne pose is distinct from standing; the sword and shield read as held props, not as hitbox | Four plates with the 18 × 28 collider outlined: [facing-left](evidence/screens/character/character-facing-left.png), [facing-right](evidence/screens/character/character-facing-right.png), [ledge-edge](evidence/screens/character/character-ledge-edge.png), [mid-jump](evidence/screens/character/character-mid-jump.png). Measured prop overhang: sword tip 4.5 px, shield 3.5 px, crossguard 1.42 px, all inside the ≤5 px commitment |
| **Extended route** | The whole course by normal play: sections 01 and 02 unchanged, then Section 03 — hop the spiked step at x 992, take off for the high stone at 1152, cross to the far platform at 1256, touch the flag at 1420 | A normal route reaches both new landings and the relocated finish; the original section is still the only way in and plays as before | [03-jump.png](evidence/screens/03-jump.png), [04-complete.png](evidence/screens/04-complete.png); `complete-real-route` ends at `(1416.88, 319.93)` inside the finish rect |
| **Failure and recovery** | Hit the spikes; fell into the 144 px chasm; pressed R; finished and replayed from the results screen | Both hazards kill and the automatic retry puts the player back at `(64, 320)`; R restarts without counting as a death; replay after completion starts a clean run | `actual-spike-collision`, `fall-boundary`, `plateau-death-respawn`, `twenty-retries` (longest retry 34 ticks ≈ 0.57 s), `manual-restart-not-death`, `replay-idempotent`, `enter-replay`; [02-failure.png](evidence/screens/02-failure.png) |
| **Camera and presentation** | Camera behaviour across the new stretch and at the right clamp; HUD progress bar; section label and finish label | The camera keeps its 100 px forward lead and clamps to 1160 (`width − 320`) instead of stopping at the old edge; the next landing is visible before each jump; the "03 / STEP AND STONE — Jump the step. Then the stone." label sits in the hill-free 960–1200 stretch and the FINISH label sits over the flag; the progress bar now runs to the real finish | `plateau-death-respawn` (camera 1160 on the plateau, 320 after respawn); `hud-copy-fits-its-card` (tightest string 269 px of a 302 px card); [level plates](evidence/screens/level/) |

## 2. Automated checks

Run today at revision `b9b34d6`, from the repository root:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/test_game.gd
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/test_keyboard.gd
```

| Run | Result | Evidence |
| --- | --- | --- |
| Mechanics | `WALKER TESTS: 34 checks / 0 failures`, exit 0 | [mechanics-1789868989.17936.json](evidence/mechanics-1789868989.17936.json) |
| Keyboard | 9 checks / 0 failures, exit 0 | [keyboard-1789868995.46207.json](evidence/keyboard-1789868995.46207.json) |

`node scripts/record-build.cjs` then re-recorded the manifest against these two runs: 26 source
hashes, 43 machine checks. Every earlier run is kept in `evidence/`, including the starter's
original failing run [mechanics-1789078423.29998.json](evidence/mechanics-1789078423.29998.json)
(4 failures) and the pre-change baseline taken before this fork's first edit. Nothing was deleted.

**One inaccurate field, left as the script writes it:** `human_playtest_sessions` in the manifest is
hard-coded to `0` by `scripts/record-build.cjs:32`. It is not a measurement. This report is the
human playtest record.

### What changed in the route fixture, and why

`godot/tests/route_driver.gd` was authored for the 960 px level: five jump marks ending at 712,
for a finish at x 916. With the finish moved to 1420 it would have walked the player into Section
03's spiked step and stopped there — the route would have failed, and "fixing" it by trimming the
expectation would have tested nothing.

- **Marks 1–5 are untouched** (138, 292, 424, 548, 712): the original section is regression-tested
  exactly as the starter wrote it.
- **Three marks added** for the extension: 948 (hop the spiked step), 1080 (up onto the high
  stone), 1174 (stone → far platform).
- The fixture still only sets a take-off *x* and presses the same keys a player presses. No
  position or velocity edit, in this change or the original.
- The route now takes **514 ticks** (≈ 8.6 s) with **0 deaths**, against 325 ticks before. The
  900-tick cap is unchanged.

**The completion assertion was strengthened, not relaxed.** It used to accept `state == COMPLETE`
with 0 deaths. It now also requires the 18 × 28 body rect to intersect the finish rect read from
the level JSON (`test_game.gd:261-264`), so a win cannot be reported at the old finish position or
at a flag drawn somewhere the goal is not.

### Checks added for the extension

Nine new cases, on top of the starter's 25 (all of which still run and pass):

| Check | What it pins down |
| --- | --- |
| `hazard-art-matches-trigger` | Both hazards' painted triangles *are* their trigger polygons, and the new spikes' base is the step top (296), not the ground — the "ghost spikes" failure cannot happen |
| `step-is-jumped-not-stood-on` | Six take-offs across the hop range: 4 clear, 2 die, **0** land on the step — it is an obstacle, never footing |
| `step-blocks-the-walk` | Walking into the step stops the body at x 983 against the face at 992, with no hazard contact |
| `step-spike-safe-strip` | Standing 36 px short of the step gives 31 px of clearance and no death |
| `high-stone-reachable` | Input-only jump from the ground lands on the stone at `(1167.62, 279.93)` |
| `stone-takeoff-sweep` | Sweeps the take-off window: 5 landings, 2 falls, so the window's edges are recorded rather than assumed |
| `plateau-death-respawn` | Dying on the far platform respawns at `(64, 320)` and re-clamps the camera from 1160 back to 320 |
| `hill-row-clear-and-whole` | The backdrop hills do not overlap and the last one is whole, not cut by the world edge |
| `hud-copy-fits-its-card` | All thirteen HUD strings measured against the cards they are centred in, so new copy cannot silently overflow |

No assertion was deleted and no expected value was loosened. `tuning.gd` and the player collider
were never touched, so the starter's movement and jump assertions are testing the same numbers.

## 3. Inspect-and-revise cycles

Each one is an observation first, then a change, then a re-check.

**A. The spiked step was the wrong shape (usability, no crash).** Looking at the rendered level,
Section 03's "spike stair" was a raised stretch of floor with spikes on top — something to walk
along, not the short step the design meant the player to *jump over*, and the fork it fed into was
never really a choice. Revised: all Section 03 ground dropped to y 320, the same height as the
starter's, with the spikes on a 32 × 24 block standing on it, inset 4 px per side so a body stopped
by the block's face cannot touch a trigger. Re-checked: `step-is-jumped-not-stood-on` = 0 stands on
the step across six take-offs, and `step-blocks-the-walk` stops the body at 983.

**B. My arithmetic was wrong and the measurement corrected it.** Raising the obstacle to 40 px
(24 block + 16 spikes) should, by the continuous-arc formula, have shrunk the safe take-off window
to about 11 px. Measured input-only, it is **24 px (~9 ticks)**: the spikes are triangles, so near
each end their outline is far below the apex and a body clears them earlier and later than a
24 × 40 box would allow. The window is now a recorded measurement (940.6–964.6), not a prediction.

**C. Two flat stretches made the section read as empty floor (clarity).** The step moved to 992,
the entry ground went from 272 px to 152 px, and the stone, platform and finish moved left with it,
shrinking the world from the planned 1600 to **1480**. Route marks dropped from 9 to 8. The earlier
entry pit was removed in the same pass so the section has exactly one fall hazard, the 144 px chasm.

**D. Character revisions found by looking, not reasoning.** From the pose plates: the cap tail
covered the ear, the sword was invisible against the light backdrop, and the airborne pose was
identical to standing — the brief's "legs tuck" was wrong, because the stride term going to 0
leaves the legs at *full* length, so an explicit tuck was added. After playing, the flat blade read
as a stick and became a five-point tapered polygon.

**E. A fix that was rejected after review.** Deriving the backdrop hills from an even 320 spacing
removed an overlap in front of the finish, but it moved two of the starter's own hills and changed
the original section's backdrop for the first time. That trade was refused. Final: the starter's
three hills exactly where they were, plus one whole hill at 1200–1480. Verified by diffing against
the pre-hill commit — `01-menu`, `02-failure`, `03-jump` and `level-00.png` came out
byte-identical. Accepted cost: 960–1200 has no hill, which is where the Section 03 label now sits.

## 4. Playtester

**None besides the author.** No other person has played this build, so no third-party feedback is
recorded here. The author's own playtest above is the only human session.

## 5. What this report does not cover

- One hand playtest, one person, one machine. No first-time-player completion times, and no
  fairness or enjoyment verdict from anyone but the author.
- The 8-mark route is a fixed input fixture. It shows the course is completable with 0 deaths; it
  is not a model of how a person plays, and it does not replace the hand playtest.
- The coyote and buffer boundary cases seed controller timing state directly. They are unit
  fixtures, not a claim to cover every naturally occurring landing sequence.
- No export, Web build, publication or push to `upstream`. The starter repository is unmodified.
