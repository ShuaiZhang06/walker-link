# CAPTURE.md — how the gameplay in this film was recorded

**Film:** `claude-liam-walker-link-walkthrough` · **Game:** `walker-link` ·
**Recorded:** 2026‑09‑20 · **Skill:** `godot-waikthrough`, `walker` modifier.

## The build being demonstrated

| | |
| --- | --- |
| Repository | `ShuaiZhang06/walker-link` (fork of `nikbearbrown/walker-jumpman`) |
| Revision | `19a7dddb9ab30fa7f386878b05ef63a018928069` (`19a7ddd`), working tree clean at capture time |
| Source snapshot | `5e7724383ac2b2d076f47e34851dbf80bbb940b0e0f62071efd707f4bfc8a311` |
| Engine | Godot **4.7.2.stable.official.ed1daf0bf**, Compatibility / OpenGL, 60 Hz physics |
| Logical canvas | 640 × 360 · `stretch/mode = canvas_items` |
| Machine | Apple M3, macOS (Darwin 24.1.0), 5120 × 2880 display |

**`build_id` method.** SHA‑256 over a JSON object mapping every git‑tracked game
source path to its own SHA‑256, keys sorted, serialised with
`json.dumps(..., separators=(',', ':'), sort_keys=True)`. The file list is
`git ls-files godot walker-jumpman.command` — 25 files:

```
godot/.gitignore, godot/features/player/{player.gd,player.gd.uid,tuning.gd,tuning.gd.uid},
godot/game/{main.tscn,session.gd,session.gd.uid}, godot/levels/first_steps.json,
godot/project.godot, godot/tests/{capture_character,capture_game,capture_level,route_driver,
test_game,test_keyboard}.gd(+.uid), godot/ui/{hud.gd,hud.gd.uid}, walker-jumpman.command
```

This is the same hashing recipe the game's own `scripts/record-build.cjs` uses,
minus `godot/.DS_Store` — a Finder artefact, gitignored, not source. All 25
source hashes match `evidence/build-manifest.json`; only the `.DS_Store` entry
differs, which is why this film's `build_id` is not the manifest's `399cb7b6…`.

## What was run, and where

The game was **copied** to a scratch directory before anything was recorded.
`walker-link/godot/` was never modified, and the running game instance was never
touched. The copy excludes `.godot/` and `.DS_Store`; a separate `HOME` gave the
capture process its own user‑data directory.

Two changes were made **to the copy only**, both harness, neither gameplay:

1. `project.godot`: `window_width_override` 1280 → **3840**,
   `window_height_override` 720 → **2160**. `viewport_width/height` stay
   640 × 360 and the stretch mode stays `canvas_items`, so the window is an exact
   6× integer scale of the logical canvas and every vector shape and glyph is
   **rasterised natively at 3840 × 2160**. This is not a 720p recording enlarged;
   it is also not a claim that the game's logical resolution is 4K — the logical
   canvas is 640 × 360 and the crispness comes from re‑rasterising it, as
   `canvas_items` is designed to do.
2. `tests/capture_walkthrough.gd` was added — the driver below. No existing
   script, scene, level or tuning value was edited.

```bash
HOME="$SCRATCH/userdata" /Applications/Godot.app/Contents/MacOS/Godot \
  --path "$SCRATCH/capture-project" \
  --script res://tests/capture_walkthrough.gd \
  --write-movie "$SCRATCH/takes/run-01.avi" --fixed-fps 30 --quit-after 2000 \
  -- --take run-01 --log "$SCRATCH/takes/run-01.jsonl"
```

Godot's **Movie Maker** (`--write-movie`) renders offline at a fixed 1/30 s
timestep with physics still at 60 Hz, so two physics ticks fall inside every
recorded frame and in‑game timing is preserved. Movie Maker is *not* evidence of
real‑time frame rate; the recorder reported 54–63 % of real‑time speed while
encoding. The AVI (MJPEG) takes were transcoded once to H.264
(`-preset slow -crf 14 -pix_fmt yuv420p -r 30 -fps_mode cfr -an`); frame counts
were verified identical before and after, take by take.

## The driver: input only

`capture_walkthrough.gd` instantiates the **real main scene**
(`res://game/main.tscn`) and drives it with synthetic `InputEventKey` and
`InputEventMouseButton` objects pushed through `Input.parse_input_event` — the
same path a physical key takes, reaching `_unhandled_input` and
`Input.is_action_pressed` exactly as a player's keyboard does.

The driver **reads** `position`, `velocity`, `is_on_floor()`, `state` and `tick`
to decide *when* to press a key. It never:

* writes a position, velocity or state;
* sets `COMPLETE`, clears a death, or calls `resolve_contacts`;
* disables or resizes a collision shape;
* uses the player's `test_control` / `test_axis` / `test_jump_pressed` hooks
  (those exist for the unit fixtures; they are not used here);
* runs with `test_mode = true` — the real main scene's default `false` is kept,
  which is why the focus‑loss auto‑pause is live in every take.

Jump marks are pressed from a `_physics_process` node ahead of the player in
tree order, so a take‑off x is tick‑accurate rather than frame‑rounded. Every
take asserts its own outcome and the process exits non‑zero on failure;
exhausting `--quit-after` would be a failure, not a pass. All seven takes exited
0 with zero failed assertions.

**This is a scripted‑input capture, not a human playtest.** It is labelled as
such on screen (`SCRIPTED INPUT · NATIVE 4K ENGINE CAPTURE`, top right of every
gameplay frame), said out loud in beat B02, and recorded in `coverage.json` as
`"method": "scripted-input"`. It cannot speak to fairness, difficulty or fun.

## The input logs

`capture/<take>-inputs.jsonl` is one JSON object per line and doubles as the
event log. Every rendered frame emits a `state` row (`f`, `t`, `x`, `y`, `vx`,
`vy`, `on_floor`, `facing`, `tick`, `jumps`, `state`, `deaths`, `elapsed`,
`camera_x`); every key or mouse event emits an `input` row; `mark` and `check`
rows carry the driver's own assertions. Frame `f` maps to capture time as
`t = f / 30`, so any timecode in `coverage.json` can be read straight back to a
physics tick. The coyote and buffer claims in B04 and B05 rest on these tick
numbers, not on what a frame looks like.

## The takes

| take | frames | seconds | what it contains |
| --- | ---: | ---: | --- |
| `run-01` | 470 | 15.667 | Menu → Enter → the whole course → flag → results card → Enter replays |
| `run-02` | 222 | 7.400 | Pointer start; walk into the ground spikes; auto‑retry; clear them |
| `run-03` | 302 | 10.067 | Into Section 03; land on the stone; run off its end into the chasm |
| `run-04` | 367 | 12.233 | Esc pause, Enter resume, R restart, real app switch, M to menu |
| `run-05` | 209 | 6.967 | Stand, run to the cap, stop, turn to the wall, A+D, one jump |
| `run-06` | 338 | 11.267 | Walk into the spiked step (blocked, alive); back up; hop it |
| `run-07` | 197 | 6.567 | Late jump off the edge (coyote); refused mid‑air press; buffered press |

`run-04` causes a genuine focus loss by launching another macOS application
(`/usr/bin/open -a Finder`) from the driver. The game window really loses the
keyboard, the engine really emits `focus_exited`, and `session.gd` pauses. No
signal was emitted by hand. The cause is off‑screen, so the narration says so.

## Audio

The game has **no audio of any kind** — no music, no effects, no UI sound. There
was nothing to mute and nothing was added. Narration is local Kokoro `am_onyx`
(Liam, in for Bear). No sound effect was invented for any gameplay event.

## Labels burned into the film

| label | where | means |
| --- | --- | --- |
| `SCRIPTED INPUT · NATIVE 4K ENGINE CAPTURE` | top right, every gameplay frame | the provenance of the footage |
| `REPLAY 0.xx× — …` | under it, during a slowed segment | the same action again, slowed, outside its real‑time interval |
| `HELD FINAL FRAME · N.Ns · no gameplay` | under it, at the tail of a beat | narration is still running; the game is not |

Every `1.0×` segment is copied frame for frame from the hashed capture. No
gameplay was sped up, slowed down, or center‑cut to fit narration: where a beat
needed more time than its action, it got a labelled held frame instead.
