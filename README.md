# walker-link — WALKER / LINK

A small 2D platformer in Godot. It is a coursework fork of the **walker-jumpman "First Steps"**
prototype by Nik Bear Brown ([nikbearbrown/walker-jumpman](https://github.com/nikbearbrown/walker-jumpman)).
Fork by Shuai Zhang, who directed the work; Claude (Claude Code) wrote the code. The split is in
[SOURCES.md](SOURCES.md).

| | |
| --- | --- |
| Engine | Godot **4.7.2.stable.official.ed1daf0bf**, typed GDScript, Compatibility renderer. No .NET, no external assets |
| Starter | `nikbearbrown/walker-jumpman` @ `9387542`, kept as a read-only `upstream` remote. Nothing was pushed to it |
| Fork branch | `link-character-and-section-03` |

![The game, captured during a scripted jump](evidence/screens/03-jump.png)

## Run it

```bash
git clone https://github.com/ShuaiZhang06/walker-link.git
```

- **macOS:** double-click [walker-jumpman.command](walker-jumpman.command). It needs Godot in
  `/Applications`, or `godot` on the `PATH`.
- **Any platform:** open `godot/project.godot` in the Godot editor and press Play, or run
  `godot --path godot` from the cloned folder.
- **Automated checks** (expected: `34 checks / 0 failures` and `9 checks / 0 failures`):

```bash
godot --headless --path godot --script res://tests/test_game.gd
```

```bash
godot --headless --path godot --script res://tests/test_keyboard.gd
```

## Controls

| Action | Keys |
| --- | --- |
| Start / confirm | Enter |
| Move | A / D or ← / → |
| Jump | Space |
| Retry | R |
| Pause | Escape or P |

Reach the flag. Retries are unlimited.

## What changed from the starter

- **Character.** The five-rectangle player drawing is now a Link-styled adventurer with a green cap,
  sword and shield (`player.gd::_draw()`, visual only). It has a separate airborne pose. The body
  fits inside the unchanged 18 × 28 collider. The props overhang it by at most 4.5 px and have no
  collision.
- **Section 03.** The world goes from 960 px to **1480 px** wide. The new section is flat ground,
  a 40 px spiked step to jump over, one high stone across a 144 px chasm, then the finish.
- **Drawing derived from data.** The backdrop, grid, spikes, flag and HUD progress now come from the
  level data instead of hard-coded coordinates. The original section's plates came out byte-identical.
- **Copy.** The title is now WALKER / LINK, with a Section 03 label and menu text that matches the
  new route.
- **Tests.** Nine new checks (25 → 34). The route test now also requires the body to touch the
  finish, not just `state == COMPLETE`.
- **Unchanged:** `tuning.gd`, the collider, the input map, the retry loop, and the starter's original
  geometry. All are still regression-tested.

Plan, predictions and revision log: [CHANGE-BRIEF.md](CHANGE-BRIEF.md). Test results:
[TEST-REPORT.md](TEST-REPORT.md).

## The film

**Walker, Forked.** A 5:09 walkthrough of this build, made with the course's
`godot-waikthrough` skill (`walker` modifier). Every gameplay shot is a real engine capture of
this revision, driven by scripted keyboard input. The narration is a local Kokoro voice
(`am_onyx`). There are no captions.

**▶ Watch / download:** [claude-liam-walker-link-walkthrough.mp4 on Google Drive](https://drive.google.com/file/d/1srroMr4Uth61ySDMroEhkDrw4sQEe3mn/view?usp=drive_link) (kept off GitHub because MP4s are not committed)

| | |
| --- | --- |
| File name | `claude-liam-walker-link-walkthrough.mp4` |
| SHA-256 | `7a1e0ab0d2464de276d02497f3bf9bd6fc901c774a3269d561bca699cfa8d366` |
| Size / length | 30,646,281 bytes · 309.53 s (9,285 frames at 30 fps) |
| Format | H.264 3840 × 2160 + AAC 48 kHz stereo |
| Game revision shown | `19a7ddd` (the game source has not changed since) |

To confirm you have the exact file, use Drive's **Download** button (the in-browser preview is a re-encoded stream) and compare:

```bash
shasum -a 256 claude-liam-walker-link-walkthrough.mp4
```

A copy re-encoded by a streaming platform will not match. The hash identifies the original render.

The film's source files are in
[`youtube/claude-liam-walker-link-walkthrough/`](youtube/claude-liam-walker-link-walkthrough/):

| File | What it is |
| --- | --- |
| [`beat_sheet.json`](youtube/claude-liam-walker-link-walkthrough/beat_sheet.json) | Beat sheet: 18 beats with narration, shot plan and frame ranges. This is the source of truth for the script |
| [`SCRIPT.md`](youtube/claude-liam-walker-link-walkthrough/SCRIPT.md) · [`PROMPTS.md`](youtube/claude-liam-walker-link-walkthrough/PROMPTS.md) | Spoken script with timecodes, and the on-screen prompts. One prompt is a labelled reconstruction |
| [`coverage.json`](youtube/claude-liam-walker-link-walkthrough/coverage.json) | Coverage: 18 implemented features, each mapped to a capture and a timecode, plus 6 features that are not built |
| [`capture/run-0*-inputs.jsonl`](youtube/claude-liam-walker-link-walkthrough/capture/) · [`CAPTURE.md`](youtube/claude-liam-walker-link-walkthrough/CAPTURE.md) | Input and engine-state logs for all seven takes, and how they were recorded |
| [`FACTCHECK.md`](youtube/claude-liam-walker-link-walkthrough/FACTCHECK.md) · [`RIFF.md`](youtube/claude-liam-walker-link-walkthrough/RIFF.md) · [`SHOTLIST.md`](youtube/claude-liam-walker-link-walkthrough/SHOTLIST.md) | The source of every spoken number, per-beat notes, and the shot list |
| [`_qc/WALKTHROUGH-REVIEW.md`](youtube/claude-liam-walker-link-walkthrough/_qc/WALKTHROUGH-REVIEW.md) | QC record: gate results, a timing check against the input logs, and the outro blocker |

## Known limitations

- **One playtester, the author.** There are no first-time completion times, and no one else has
  judged fairness, difficulty or fun.
- **F6 is open.** No one else has checked whether the sword and shield read as props or as part of
  the hitbox.
- **Not built:** cherries, the full three-zone course, audio, a settings screen, key remapping,
  moving platforms, and a Web or desktop export.
- **The test route is scripted.** It shows the course can be finished in 514 ticks with 0 deaths.
  It does not show how a person plays.
- **Some unit tests set timing state directly.** The coyote-time and jump-buffer cases do this. The
  film shows both windows in real play instead.
- **The film's outro card is silent.** The locked jingle is not in the toolkit checkout, and no
  substitute was used.

## Documents

- **This fork:** [CHANGE-BRIEF.md](CHANGE-BRIEF.md) · [TEST-REPORT.md](TEST-REPORT.md) ·
  [FRICTIONAL.md](FRICTIONAL.md) (work log) · [SOURCES.md](SOURCES.md) (credits and human/AI split)
- **From the starter, left as written** (BUILD-REPORT only gained a fork note at the top): [BUILD-REPORT.md](BUILD-REPORT.md), [GDD.md](GDD.md),
  [GAME-BRIEF.md](GAME-BRIEF.md), [LEVEL-DESIGN.md](LEVEL-DESIGN.md),
  [PRODUCTION-PLAN.md](PRODUCTION-PLAN.md), [PLAYTEST-PLAN.md](PLAYTEST-PLAN.md),
  [ASSET-PLAN.md](ASSET-PLAN.md), [DESIGN-STATUS.json](DESIGN-STATUS.json),
  [DESIGN-REVIEW.md](DESIGN-REVIEW.md), `design/`. These describe the starter's full three-zone
  design, which is not what this build implements.
