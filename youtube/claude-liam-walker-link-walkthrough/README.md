# Walker, Forked. — walker-link walkthrough

**5:09 · 3840 × 2160 · 30 fps · Liam, in for Bear (local Kokoro `am_onyx`) · no captions**

The required Brutalist Godot explainer for [walker-link](../../), built with the
course-provided `godot-waikthrough` skill (alias `godot-walkthrough`) and its
**`walker`** modifier: Claude prompt opening → what was actually built →
the real game played → Verdict → Your Turn → the regular outro.

```bash
open "exports/landscape/claude-liam-walker-link-walkthrough.mp4"
```

## What it shows

| | beat |
| --- | --- |
| The Walker ask — labelled an illustrative reconstruction, not a transcript | B00 |
| Starter (`nikbearbrown/walker-jumpman`), fork (`ShuaiZhang06/walker-link @ 19a7ddd`), and the two changes | B00, B01 |
| The character concept: a green-capped adventurer, mirrored on the turn, props 4.5 px past the collider | B03 |
| The level extension: Section 03 — a spiked step, a 40 px stone, a 144 px chasm | B06, B08, B09 |
| **New landings**, played: the ground beyond the step, the stone, the far platform | B08, B09 |
| **Failure and recovery**, played: the spikes → 0.57 s auto-retry; the chasm → "Missed the landing" | B10, B11 |
| **Completion**, played: the body inside the finish rect, results card, Enter replays | B13 |
| **Cause and effect**: `_spike_points()` is one function for the drawing and the trigger; the block is inset 4 px | B07, explaining B06 and B08 |
| Tested / uncertain / one concrete next improvement | BVD1, BVD2 |
| Human vs AI contributions, and the revision demonstrated | BVD2, B00 card |

Also played, because "every implemented feature" is the claim: the menu and both
ways to start it, movement and the speed cap, the left-wall clamp, the single
jump, coyote time, the jump buffer, the refused second jump, pause and resume, R
restart, M to the menu, focus-loss auto-pause, the camera clamp and the HUD.

## The evidence chain

| file | what it is |
| --- | --- |
| [`capture/run-0*.mp4`](capture) | seven unedited native-4K engine takes — the source of every gameplay frame |
| [`capture/run-0*-inputs.jsonl`](capture) | the driver's input **and** per-frame state log; `t = f / 30` maps any timecode to a physics tick |
| [`coverage.json`](coverage.json) | 18 implemented features → capture + beat + time range + observation + riff; 6 planned, with reasons |
| [`CAPTURE.md`](CAPTURE.md) | how it was recorded, the `build_id` recipe, the two harness-only changes to the isolated copy |
| [`RIFF.md`](RIFF.md) | what was looked at, what it showed, and which claims come from source rather than screen |
| [`FACTCHECK.md`](FACTCHECK.md) | every number spoken in the film, with its source |
| [`SHOTLIST.md`](SHOTLIST.md) · [`PROMPTS.md`](PROMPTS.md) · [`BUILD-PROMPT.md`](BUILD-PROMPT.md) | slots, on-screen prompts, build order |
| [`_qc/WALKTHROUGH-REVIEW.md`](_qc/WALKTHROUGH-REVIEW.md) | the human review: gate results, timing verification, the outro asset blocker |

```bash
./art godot-waikthrough --check .   # from brutalist.art, with this folder as REEL
```

## Honesty boundary

* All gameplay is **scripted input through the real engine** — labelled on
  screen, said in narration, and recorded as `"method": "scripted-input"`. It is
  not a human playtest and the film says so.
* No real-time gameplay was sped up, slowed or center-cut. Slowed passages are
  labelled replays; a beat that outran its action got a labelled held frame.
* The game has no audio; none was invented.
* The outro card is **silent**: the locked jingle lives in `svg/claude/mp3/`,
  which is not in this checkout. Reported as an asset blocker, not substituted.
* Nothing here was uploaded, published, or pushed. Media stays out of git by
  the repository's existing `.gitignore`.
