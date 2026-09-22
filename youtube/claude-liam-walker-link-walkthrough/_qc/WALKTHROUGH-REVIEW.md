# Human/visual QC — claude-liam-walker-link-walkthrough

The machine gates cannot judge whether a described action happens, whether an
input log is truthful, or whether the feature inventory is complete. This is the
record of the review that can. `_qc/REPORT.md` is the automated Gate V output and
is overwritten on every build; this file is the one that is kept.

**Subject:** `exports/landscape/claude-liam-walker-link-walkthrough.mp4`
`sha256 7a1e0ab0d2464de276d02497f3bf9bd6fc901c774a3269d561bca699cfa8d366`
3840 × 2160 · 30 fps · 9285 frames · 309.53 s · H.264 + AAC 48 kHz stereo · 30.6 MB

## Automated gates, at this revision of the reel

| gate | result |
| --- | --- |
| `./art godot-waikthrough --check` | **PASS** — 18 implemented features, 20 evidence intervals, 6 planned, 7 captures, all 3840 × 2160 16:9, all hashes matching |
| `beat_lint` (GATE L) | clean |
| `gate_shape` | skipped — not a finance reel |
| Gate V frame QC (`final_frame_check.py`) | **0 BLOCKER, 0 MAJOR** across 36 sampled frames |
| `./art final` preflight + export receipt | `status: ready`; the receipt's output hash matches the file on disk |
| Godot `test_game.gd` (pre-flight, on the game itself) | 34 checks / 0 failures, exit 0 |

Two gate declarations are in `beat_sheet.json` and are deliberate, per-beat, and
narrow:

* `qc.full_bleed: true` on the eleven gameplay beats. The game renders edge to
  edge — its HUD bar is the top of the frame and its status line is the bottom —
  so ink in the title-safe margin is the game, not overflow. Only `edge-bleed` is
  waived; underfill, clustering, empty-frame and contrast still run on those
  beats and all pass.
* `qc.contrast_regions` on **B12** and **B13**, with a written
  `qc.contrast_reason`. `session.gd` paints a translucent scrim over the play
  area behind the menu/pause/results cards, which drags the whole-frame average
  down even though the text is dark ink on near-white. The declared regions are
  the state card, the HUD title/controls block and the status line; every one is
  measured locally and every one passes. Nothing was globally suppressed and
  `ART_STRICT` was never lowered.

## Timing: the film's clock against the capture's clock

Seven events were predicted from the input logs and then found at the predicted
timestamp in the finished 4K file:

| event | source | predicted in the film | found |
| --- | --- | --- | --- |
| Coyote press, 2 ticks after the floor ran out | `run-07` f87 | 63.700 s | airborne over the 448–512 gap ✓ |
| Body blocked by the step face | `run-06` f188 | 86.234 s | stopped at the step, state PLAYING, clock running ✓ |
| Spike contact | `run-02` f94 | 157.400 s | "Watch the spikes", RETRIES 01 ✓ |
| Auto-respawn 17 frames later | `run-02` f111 | 157.967 s | back at the spawn, RETRIES 01 ✓ |
| Fall past y = 430 | `run-03` f245 | 173.967 s | "Missed the landing", RETRIES 01 ✓ |
| Escape pause | `run-04` f112 | 191.966 s | "Take a breath." card, clock frozen ✓ |
| COMPLETE inside the finish rect | `run-01` f314 | 207.133 s | "Course complete. 8.8 seconds / 0 retries" ✓ |

Every slot's compositor conform ratio is exactly **1.000000** — verified for all
eighteen beats against `math.ceil(actual_duration_s * 30 - 1e-8) / 30`. No
"slowed", "center-cut" or replacement notice appeared in any compile, and
`replace_log.md` does not exist.

Two build defects were found and fixed rather than tolerated:

1. `actual_duration_s` rounded to six decimals pushed `ceil(d * 30)` up by a
   whole frame on three beats (338 → 339 etc.), which is exactly the
   "six-decimal upward-rounded probe string" the skill warns adds a frame and
   causes unintended retiming. Fixed by storing the exact float.
2. B13's container duration came out 5 ticks under `N / 30` after the concat
   step, producing a 1.000028 setpts retime on a clip that should be copied.
   Fixed with `-fps_mode cfr` plus a `-c copy` remux.

## Watching the film

Reviewed as sampled frames across the whole 309.53 s (40-point sweep plus the
targeted checks above), with per-beat audio measurement. Findings:

* **Native 4K.** Text, the HUD, the spikes and the character are crisp at
  3840 × 2160 — re-rasterised by Godot's `canvas_items` stretch from the 640 × 360
  logical canvas, not an enlarged recording. The `session.gd` code on B07 is
  legible at full size.
* **Labels.** The provenance chip sits in empty sky at the top right on every
  gameplay frame. Replay and held-frame labels appear only for their own
  segments and name their rate or their length. Checked at B02, B03, B04, B05,
  B06, B08, B09, B10, B11, B12, B13.
* **Menu text and game content** inspected by eye: the start, pause, death,
  and results cards all read correctly, and the copy fits its cards (the game's
  own `hud-copy-fits-its-card` check agrees — tightest string 269 px of 302).
* **Audio.** Narration is even across the film: mean −26.5 to −27.5 dB, peaks
  −4 to −10 dB, no clipping, no gaps at beat transitions. The outro card
  measures −91 dB — silent (see the asset blocker below). No gameplay audio
  exists and none was invented.
* **Outro.** Slug-seeded dark polarity, "Walker, Forked." with the terracotta
  period, `@NikBearBrown`, one crisp-safe mascot below the handle, **no
  subline**, no narration.

Three notes fixed during review rather than shipped:

* B03 originally ran to the end of `run-05`, which closes on an unrelated spike
  death; the character beat now stops at f186, before it.
* B09 originally ran past COMPLETE and ended on the results card, duplicating
  B13; it now stops at f312.
* The verdict was one 36-second static card; it is now two.

## Asset blocker — the outro jingle

`OUTRO-LOCK.md` specifies the existing slug-seeded jingle from
`svg/claude/mp3/`. **`svg/` is not present in this checkout** — it is
gitignored in `brutalist.art` (12 GB, never pushed), so the stock jingles are
unavailable here. Per the skill ("If stock outro assets are missing, report that
asset blocker rather than inventing a substitute"), the outro card ships
**silent**, declared with `audio_policy: "silence"`, and no substitute was
invented. The `logos/bear-brown/*.mp3` stings in the toolkit are a different
brand's logo audio, not the claude regular jingle, and were not used. To
complete the card as locked: restore `svg/claude/mp3/`, drop the slug-seeded
jingle in as `mp3/beat-BOUT.mp3`, remove `audio_policy` / `silent` from BOUT,
and re-run `./art final`.

## What this review does not certify

* That the game is fun, fair, readable to a stranger, or worth a second run.
  One person has played it, and he wrote it.
* That the feature inventory is exhaustive. It was built from reading
  `session.gd`, `player.gd`, `hud.gd`, `first_steps.json` and `test_game.gd`,
  and then from a real run of each feature — but "every implemented feature" is
  a human claim, not a machine result.
* Anything about publication. Nothing was uploaded, pushed, or exported as a
  game build.
