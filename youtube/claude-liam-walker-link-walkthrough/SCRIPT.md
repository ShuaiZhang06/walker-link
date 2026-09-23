# SCRIPT — Walker, Forked.

> **The film is narrated in English throughout.** This file is a readable copy of the narration and on-screen text; editing it does not change a single frame.

> **`beat_sheet.json` is the single source of truth.** Kokoro reads `beats[].narration_text` word for word, so to change the script, edit that JSON and re-run `generate_audio_kokoro.py`.

**claude-liam-walker-link-walkthrough** · 5:09.5 · 18 beats · 1050 spoken words · voice `am_onyx` (Liam, in for Bear) · kokoro · no captions

---

## 0:00.00 · B00 — cold open — the Walker ask

`15.53s` · Remotion card `ClaudeComposerAsk`

**Narration**

> Sawubona — this is Liam, in for Bear. That prompt is an illustrative
> reconstruction. It shows you the shape of the ask; it is not a transcript of
> anything anyone typed. What is real is the thing underneath it: a starter
> platformer, a fork of it, and a build I am about to play in front of you.

| On screen | Text |
| --- | --- |
| greeting | Sawubona, Liam |
| composer | Please use Walker to convert my game design document about a small Godot platformer — a green-capped adventurer crossing a short course of ledges, gaps and spikes, one fixed-height jump, unlimited retries — into a playable Godot project I can run, read and extend. |
| running | reconstructed prompt — illustrative, not a transcript… |
| output | Starter: nikbearbrown/walker-jumpman — “First Steps”, Godot 4.7.2. |
| output | Fork: ShuaiZhang06/walker-link @ 19a7ddd — new character, new Section 03. |
| output | Played below input-only; tuning.gd and the player collider untouched. |

## 0:15.53 · B01 — BLUF — what was actually built

`23.20s` · Remotion card `BrutalistHesitantWriter`

**Narration**

> Here is the honest framing. walker-link is not a game written from nothing.
> It is a fork of nikbearbrown slash walker-jumpman — the First Steps
> prototype, Godot four point seven point two. Two things in it belong to the
> fork. The player is redrawn as a green-capped adventurer carrying a sword
> and a shield. And the course grows a third section. The movement tuning, the
> collider, the controls, the retry loop and the original geometry all still
> belong to the starter.

| On screen | Text |
| --- | --- |
| typed | walker-link is a game I wrote. / Two things in it are mine: / the character, / and one new level section. / The rest is the starter's. |
| correction | “wrote” → “forked” |

## 0:38.73 · B02 — the starter course

`8.93s` · gameplay capture · `run-01` · f0–200 @1.0×, f116–134 @0.25×

**Narration**

> Real engine, native four K. Every key here is pressed by a script — no
> teleports, no position edits. This first stretch is the starter's own
> course.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.25× — the first gap |

## 0:47.67 · B03 — the character

`13.80s` · gameplay capture · `run-05` · f0–100 @1.0×, f56–96 @0.25×, f100–186 @1.0× · hold 68 frames (2.3 s)

**Narration**

> Change one: the character. Green cap, flared tunic, a shield on the leading
> arm, a sword behind. Turn around and every piece of it mirrors — slowed down
> here so you can see it. The sword tip reaches four and a half pixels past
> the collider. It is drawn, never solid.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.25× — the turn, mirrored |

## 1:01.47 · B04 — coyote time

`12.60s` · gameplay capture · `run-07` · f20–112 @1.0×, f78–102 @0.15×, f102–155 @1.0× · hold 73 frames (2.4 s)

**Narration**

> The ground runs out at four forty-eight. The jump goes in two physics ticks
> after the floor is gone — and coyote time still pays it. Six ticks of
> forgiveness, one tenth of a second. That is the input log talking, not my
> eyes.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.15× — jump pressed after the edge |

## 1:14.07 · B05 — no double jump, and the buffer

`9.90s` · gameplay capture · `run-07` · f86–180 @1.0×, f88–100 @0.2×, f138–156 @0.2×, f180–197 @1.0× · hold 36 frames (1.2 s)

**Narration**

> Press again in the air and nothing happens. There is one jump, and it is
> spent. But press it just before you land, and the buffer holds it for six
> ticks and fires it on the touchdown tick.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.2× — the refused second press |
| label | REPLAY 0.2× — buffered, then landing |

## 1:23.97 · B06 — Section 03 — the step is a wall

`11.27s` · gameplay capture · `run-06` · f120–240 @1.0×, f178–200 @0.2×, f200–245 @1.0× · hold 63 frames (2.1 s)

**Narration**

> Change two: Section 03. First thing in it is a spiked step. Walk into it and
> the run does not end — the body stops dead at nine eighty-three, against a
> face at nine ninety-two, and nothing kills you.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.2× — blocked, not killed |

## 1:35.23 · B07 — cause and effect — one source change

`30.40s` · Remotion card `ClaudeCodeBeat`

**Narration**

> That is a source change you can watch. In the starter, the spikes were
> painted at a hard-coded y of three hundred and twenty, while the trigger
> polygon was built from the hazard rect's own size. On flat ground nobody
> notices. Put spikes on a step twenty-four pixels up and the picture and the
> kill zone stop agreeing. Both now come out of one function, spike points, so
> the triangle you see is the triangle that kills. And the block is inset four
> pixels under the spikes on each side — which is exactly why walking into it
> stopped the run instead of ending it.

| On screen | Text |
| --- | --- |
| spark | The drawing is the hitbox. |
| code | `godot/game/session.gd` — see `beat_sheet.json` |

The card shows the real code from `godot/game/session.gd`:

* `# Before: the picture and the kill zone were computed separately.`
* `#   _draw()     -> spikes painted at a literal y = 320, spaced i * 8`
* `#   _add_area() -> trigger polygons built from rect.size.x / 3.0`
* `# Agreed on flat ground. Disagreed on a step 24 px above it.`
* `func _draw() -> void:   # what you see`
* `func _add_area(...) -> Area2D:  # what kills you`
* `# hazard [996, 280, 24, 16] stands on block [992, 296, 32, 24]:`
  `# inset 4 px a side, so a body stopped by the face never reaches it.`

## 2:05.63 · B08 — Section 03 — hopping the step

`13.87s` · gameplay capture · `run-06` · f214–310 @1.0×, f272–302 @0.15×, f302–338 @1.0× · hold 84 frames (2.8 s)

**Narration**

> So you back up and hop it. Take off inside a twenty-four pixel window —
> measured, nine forty point six to nine sixty-four point six — and you land
> on the ground beyond. Never on the step: six take-offs across the range land
> on it zero times.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.15× — the hop |

## 2:19.50 · B09 — Section 03 — the stone, the chasm, the flag

`14.77s` · gameplay capture · `run-01` · f196–290 @1.0×, f242–280 @0.15×, f280–312 @1.0× · hold 64 frames (2.1 s)

**Narration**

> Then the part the section is really about. A forty pixel stone, and behind
> it a hundred and forty-four pixel chasm against a measured hundred and
> twelve pixel leap. You cannot jump the gap. You have to use the stone. Step
> up, step across, and the flag is on the far plateau.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.15× — stone, then the crossing |

## 2:34.27 · B10 — failure and recovery — the spikes

`16.53s` · gameplay capture · `run-02` · f0–120 @1.0×, f84–118 @0.15×, f118–222 @1.0× · hold 45 frames (1.5 s)

**Narration**

> Failure. This run starts from a click on the START button instead of Enter —
> the engine's recorder does not draw the cursor, so watch the card, not the
> pointer. Then I walk into the starter's spikes on purpose. Watch the spikes.
> Retries goes to one, and nought point five seven seconds later I am back at
> the start and clearing them.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.15× — contact, card, respawn |

## 2:50.80 · B11 — failure and recovery — the chasm

`17.43s` · gameplay capture · `run-03` · f150–275 @1.0×, f214–252 @0.12×, f252–302 @1.0× · hold 31 frames (1.0 s)

**Narration**

> The other way to lose. This take lands on the stone and then simply runs off
> the end of it — forty pixels is a step, not a place to stand. It clips the
> cliff face at twelve fifty-six, slides down, crosses the fall line at four
> hundred and thirty, and the game says: missed the landing. Same retry, same
> spawn, camera back to three twenty.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.12× — off the stone, down the cliff |

## 3:08.23 · B12 — pause, restart, menu, focus

`18.30s` · gameplay capture · `run-04` · f0–300 @1.0×, f262–284 @0.2×, f284–367 @1.0× · hold 56 frames (1.9 s)

**Narration**

> Everything around the run still works. Escape freezes the position and the
> clock — watch the timer stop. Enter resumes. R restarts the attempt and the
> retry counter does not move, because a restart is not a death. And when
> another application takes the keyboard — that is a real app switch, not a
> faked signal — the game pauses itself. M goes back to the menu.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.2× — another app takes the keyboard |

## 3:26.53 · B13 — the flag, the card, and again

`11.63s` · gameplay capture · `run-01` · f296–340 @1.0×, f304–328 @0.2×, f328–470 @1.0× · hold 43 frames (1.4 s)

**Narration**

> And the end of it. The body overlaps the finish rect, the card reports the
> time and the retries, and Enter plays the whole thing again from a clean
> spawn. Eight point eight two seconds, zero retries, eight jumps.

| On screen | Text |
| --- | --- |
| label | REPLAY 0.2× — the body meets the finish rect |

## 3:38.17 · BVD1 — verdict — what is settled

`30.50s` · Remotion card `ClaudeVerdictArtifact`

**Narration**

> Verdict. Settled by machine: thirty-four mechanics checks and nine keyboard
> checks, zero failures, on Godot four point seven point two. Settled by
> playing: every implemented feature in this build, input-only, at revision
> one nine a seven d d d. The numbers are measured, not estimated — a
> fifty-six pixel jump, a nought point five seven second retry, a twenty-four pixel
> window over the step. And the starter's half is regression-tested unchanged:
> the tuning, the collider, the original geometry, all exactly as they were.

| On screen | Text |
| --- | --- |
| heading | What is settled |
| line | Machine-checked at this revision: 34 mechanics checks + 9 keyboard checks, 0 failures, Godot 4.7.2. |
| line | Shown here input-only at walker-link 19a7ddd (source snapshot 5e772438…): every implemented feature, no teleports, no state writes. |
| line | Measured, not guessed: 56 px jump rise, 0.57 s auto-retry, 940.6–964.6 take-off window over the step, 144 px chasm against a 112 px leap. |
| line | The starter's half is regression-tested unchanged: tuning.gd, the 18×28 collider, the five original solids, the ground hazard and the spawn keep their exact values. |
| line | Both new landings and both failure modes were played on camera — the step hop, the stone, the spikes, the chasm — and the flag, with 0 retries. |

## 4:08.67 · BVD2 — verdict — what is not, and who did what

`28.93s` · Remotion card `ClaudeVerdictArtifact`

**Narration**

> Not settled: one playtester, and he wrote the thing. Nobody has told us
> whether the sword and the shield read as props or as hitbox, and no check
> can. Not built, and not claimed: cherries, the three-zone course, sound,
> settings, moving platforms, a web export. So the next improvement is not
> code. Put this in front of somebody who has never seen it, and write down
> where they die. The human owns intent, scope, art direction and every
> judgment of feel. The A I implemented the authorised work, measured it,
> captured it, and narrated it.

| On screen | Text |
| --- | --- |
| heading | What is not settled, and who did what |
| line | Uncertain: one playtester, the author. No first-time completion times, and no fairness or fun verdict from anyone else. |
| line | Whether the sword and shield read as props rather than hitbox is prediction F6, still open — no automated check can settle it. |
| line | Not built, and not claimed: cherries, the three-zone course, sound, settings and remapping, moving platforms, the Web export. |
| line | Next improvement: a first-time player, unobserved, with their death positions written down — not another automated check. |
| line | Human owns intent, scope, art direction and every judgment of feel. AI implemented the authorised work, measured it, captured it and narrated it. |

## 4:37.60 · BHTF — your turn handoff

`26.93s` · Remotion card `ClaudeComposerAsk`

**Narration**

> Your turn. Here is the prompt — read it with me. Fork walker-link, keep
> tuning dot g d and the player collider byte for byte, and add a fourth
> section whose hardest jump is measured: print the take-off window in ticks
> instead of guessing it. The constraint is the exercise. If you cannot change
> the jump, you have to change the geometry — and then you have to measure it.
> My own arithmetic here was wrong by more than a factor of two, and the
> engine corrected me. Let it correct you. Liam, in for Bear.

| On screen | Text |
| --- | --- |
| greeting | Your turn. |
| composer | Fork walker-link, keep tuning.gd and the player collider byte-for-byte, and add a fourth section whose hardest jump is measured — print the take-off window in ticks instead of guessing it. |
| running | paste this into your own Claude session… |

## 5:04.53 · BOUT — outro

`5.00s` · Remotion card `ClaudeTitleOutro`

**No narration.** The outro card is silent: the jingle OUTRO-LOCK specifies lives in `svg/claude/mp3/`,
which is absent from this checkout, so it is recorded as an asset blocker instead of being substituted.

| On screen | Text |
| --- | --- |
| title | Walker, Forked. |
| handle | @NikBearBrown (hard-coded) |
| mascot | chosen by the slug `claude-liam-walker-link-walkthrough` |
| subline | none — never |

---

## Where the rest lives

| | |
| --- | --- |
| Narration (single source of truth) | `beat_sheet.json` → `beats[].narration_text` |
| Text on the cards | `beat_sheet.json` → `beats[].shot.remotion.props` |
| The two on-screen prompts, and what they are | `PROMPTS.md` |
| Where every spoken number comes from | `FACTCHECK.md` |
| Per beat: observation → reading → narration | `RIFF.md` |
| Which take and frames each beat uses | `SHOTLIST.md` |
| QC review, timecode check, asset blocker | `_qc/WALKTHROUGH-REVIEW.md` |
