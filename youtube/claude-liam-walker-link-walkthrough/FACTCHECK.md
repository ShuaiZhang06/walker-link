# FACTCHECK — claude-liam-walker-link-walkthrough

Every number and claim spoken in the film, with where it comes from. Sources
are: **log** (`capture/<take>-inputs.jsonl`, written by the driver during the
recorded run), **check** (an assertion in `godot/tests/test_game.gd`, re-run
green at this revision), **source** (a line of the game's own code) or
**record** (`CHANGE-BRIEF.md` / `TEST-REPORT.md`, the project's written history).

Anything not verifiable is marked **NOT CHECKED** and is spoken as opinion or
as an open question, never as a result.

## Identity and provenance

| claim (beat) | value | source |
| --- | --- | --- |
| Starter is `nikbearbrown/walker-jumpman`, "First Steps" (B00, B01) | — | record — `README.md` fork note; `git remote -v` shows `upstream git@github.com:nikbearbrown/walker-jumpman.git` |
| Fork is `ShuaiZhang06/walker-link` (B00) | — | `git remote -v` `origin` |
| Revision demonstrated (B00, BVDT) | `19a7ddd` (`19a7dddb9ab30fa7f386878b05ef63a018928069`) | `git rev-parse HEAD`, tree clean |
| Source snapshot (BVDT card) | `5e772438…` | computed in `CAPTURE.md`; its 25 per-file hashes match `evidence/build-manifest.json` |
| Engine (B01) | Godot 4.7.2.stable.official.ed1daf0bf | log `boot` row of every take; `project.godot` targets 4.7 |
| Two changes only: character + Section 03 (B00, B01, B03, B06) | — | record — `CHANGE-BRIEF.md` §1–§3; `tuning.gd` and the `_ready()` collider are unmodified in the diff |
| "movement tuning, collider, controls, retry loop, original geometry belong to the starter" (B01) | — | source — `tuning.gd` (speed 160, accel 1280, decel 1920, jump −320, gravity 960, coyote 6, buffer 6); `player.gd::_ready()` 18×28 at (0,−14); `session.gd::_setup_input()`; `levels/first_steps.json` solids 1–5 unchanged |
| The B00 prompt is a reconstruction (B00, said out loud; also on the card) | — | it is. No transcript of an original prompt exists in the repository |

## Measurements spoken in the film

| claim (beat) | value | source |
| --- | --- | --- |
| Capture is native 3840×2160 (B02) | 3840×2160 | `ffprobe` on all seven `capture/*.mp4`; Godot reported "recording movie in 3840×2160 @ 30 FPS" |
| Logical canvas is 640×360 (CAPTURE.md, not spoken) | 640×360 | `project.godot`; log `boot` row `logical` |
| Ground ends at x = 448 (B04) | 448 | source — `first_steps.json` solid `[0,320,448,64]` |
| Floor lost at tick 164, x = 459.55; jump pressed 2 ticks later (B04) | 2 ticks | log `run-07` f86 `floor-ran-out`, f87 `keydown Space`, check row `coyote-jump-after-the-edge` |
| Coyote window is 6 ticks ≈ 0.1 s (B04) | 6 | source — `tuning.gd coyote_ticks = 6`; 6/60 s |
| Coyote jump cleared the 64 px gap, landed x = 566.92 (B04, implied) | — | log `run-07` check `coyote-jump-cleared-the-gap` |
| Second mid-air press does nothing (B05) | jumps unchanged at 3 | log `run-07` check `no-double-jump` |
| Buffer is 6 ticks; this press fired 6 ticks later (B05) | 6 / 6 | source `buffer_ticks = 6`; log `run-07` check `buffered-jump-fires-on-landing` |
| Body stops at 983 against a face at 992 (B06) | 983.0 / 992 | log `run-06` check `step-blocks-the-walk`; source — block rect `[992,296,32,24]` |
| Spikes inset 4 px a side (B06 implied, B07 spoken) | hazard `[996,280,24,16]` in block `[992,296,32,24]` | source — `first_steps.json` |
| Step take-off window 940.6–964.6, ≈ 24 px (B08) | 940.6–964.6 | record — `CHANGE-BRIEF` "Section 03 as built"; consistent with the film's own take-off at 948.26 (log `run-06`) |
| Six sweep take-offs land on the step zero times (B08) | 0 | check `step-is-jumped-not-stood-on` — re-run green today: `{"cleared":4,"died":2,"stood_on_step":0}` |
| Stone is 40 px (B09) | `[1152,280,40,16]` | source — `first_steps.json` |
| Chasm is 144 px (B09) | 1112 → 1256 | source — ground ends 960+152 = 1112, far platform starts 1256 |
| Maximum leap measured at 112 px (B09) | 112 | record — `CHANGE-BRIEF` "Section 03 as built" |
| Jump rise 56 px (BVDT) | 56.0 | log `run-05` check `one-jump-53px` (`rise_px: 56.0`); BUILD-REPORT records 56.07 |
| Auto-retry ≈ 0.57 s (B10, BVDT) | 17 frames = 0.567 s | log `run-02` check `auto-respawn-at-spawn`; source `retry_remaining = 0.55` + 2 settle ticks |
| Spike death at x = 318.21, reason "Watch the spikes" (B10) | — | log `run-02` check `spikes-kill` |
| Fall line is y = 430; died at 435.93 (B11) | 430 / 435.93 | source `fall_y` in `first_steps.json`; log `run-03` check `fall-kills` |
| Body pinned at 1246.93 against a face at 1256 (B11) | — | log `run-03` state rows f237–f243 |
| Pause froze position and `elapsed` at 3.0 s (B12) | — | log `run-04` check `pause-freezes-position-and-clock` |
| R restarts with the retry counter unchanged (B12) | deaths 0 → 0 | log `run-04` check `r-restarts-without-a-death` |
| The focus loss is a real app switch (B12) | `/usr/bin/open -a Finder` | log `run-04` `os-focus-change` row, then check `focus-loss-auto-pauses` |
| Completion 8.82 s, 0 retries, 8 jumps (B13) | — | log `run-01` check `complete-at-the-flag` (`seconds: 8.82`, `deaths: 0`, `marks_used: 8`) |
| Body overlaps the finish rect `[1420,264,24,56]` (B13) | position (1416.85, 319.93) | log `run-01` check `complete-at-the-flag` |
| 34 mechanics checks + 9 keyboard checks, 0 failures (BVDT) | 34 / 9 / 0 | re-run today at this revision: `WALKER TESTS: 34 checks / 0 failures`, exit 0; keyboard run 9/0 recorded in `TEST-REPORT.md` and `evidence/build-manifest.json` |
| "My own arithmetic was wrong by more than a factor of two" (BHTF) | predicted ≈11 px, measured 24 px | record — `TEST-REPORT.md` §3B and `CHANGE-BRIEF` revision log 2026‑09‑19 |

## Claims deliberately marked as not settled

| claim (beat) | status |
| --- | --- |
| Whether the sword and shield read as props rather than hitbox (B03, BVDT) | **NOT CHECKED** — stated in the film as a human judgment no check can make. `CHANGE-BRIEF` F6 is open |
| Whether a nine-tick take-off window is fair (RIFF only, not spoken) | **NOT CHECKED** — hypothesis, kept out of the narration |
| Whether the game is fun, readable or well-paced | **NOT CHECKED** — one playtester, the author; said out loud in BVDT |
| 8.82 s as a completion time (B13) | spoken as what *this scripted route* did. It is not a first-time-player time and the film does not present it as one |

## Things the film is careful **not** to claim

* That this is a human playtest. It is a scripted-input capture, labelled on
  screen, in narration, and in `coverage.json`.
* That the recording proves real-time frame rate. Godot's Movie Maker renders
  offline; `CAPTURE.md` says so.
* That the game's logical resolution is 4K. It is 640×360, re-rasterised at
  3840×2160 by `canvas_items` stretch.
* That the pointer start is a documented control. The film says the HUD
  advertises Enter and flags the click path as undocumented.
* That anything was published, exported or pushed. Nothing was.
