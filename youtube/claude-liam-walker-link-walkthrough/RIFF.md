# RIFF.md — what was looked at, what it showed, what to say about it

Commentary pass for `claude-liam-walker-link-walkthrough`, per
`skills/make/riff/SKILL.md`. Voice: **Liam, in for Bear**, local Kokoro
`am_onyx`, Teardown register. Every row was written **after** probing the
capture and reading its input log — never from a filename or a beat plan.

Columns: *artifact + range* | *visible observation* | *interpretation, and
where it comes from* | *narration* | *next experiment*.

Observations are what the pixels and the logged engine state show.
Interpretations that come from reading `session.gd` / `player.gd` rather than
from the screen are marked **(source)**. Untested judgments are marked
**(hypothesis)**. Nothing here is a human playtest result.

---

## B02 · `capture/run-01.mp4` 0.00–6.67 s — the menu and the starter's course

**Observed.** The start card reads "First steps. Real jumps." over "Two gaps, a
spiked step, a stone, then the flag." Enter at frame 49 flips MENU → PLAYING on
frame 50. Five take-offs follow at logged x = 140.62, 294.21, 424.88, 550.22,
712.88; the progress bar in the HUD advances with x.

**Interpretation.** This whole stretch is the starter's geometry, byte-identical
in `levels/first_steps.json` **(source)** — which makes it the control for
everything after it.

**Narration.** "Real engine, native four K. Every key here is pressed by a
script — no teleports, no position edits. This first stretch is the starter's
own course."

**Next experiment.** Re-shoot the same five marks against the pre-fork commit
and diff the frames; the original section should be pixel-identical.

## B03 · `capture/run-05.mp4` 0.00–6.20 s — the character

**Observed.** Standing, the figure faces right: pointed green cap with the tail
behind, blonde fringe, pointed ear on the trailing side, shield on the leading
arm, sword angled up and back. Holding D reaches exactly 160.0 px/s in 10 frames;
release stops it in 3 frames at x = 113.96. Holding A flips `facing` to −1 and
every one of those parts swaps sides. At the left wall the body clamps at
x = 10.0. A and D held together gives velocity_x 0.0. One Space press rises
56.0 px and the legs tuck in the air.

**Interpretation.** `player.gd::_draw()` is the only file the character change
touched — `draw_rect` and `draw_colored_polygon`, no sprite, no imported asset
**(source)**. Prop overhang past the 18×28 collider measures 4.5 px at the sword
tip, 3.5 px at the shield **(source: CHANGE-BRIEF revision log)**.

**Narration.** "Change one: the character. Green cap, flared tunic, a shield on
the leading arm, a sword behind. Turn around and every piece of it mirrors —
slowed down here so you can see it. The sword tip reaches four and a half pixels
past the collider. It is drawn, never solid."

**Next experiment.** Show a player the ledge-edge pose with the collider hidden
and ask where they think the hitbox ends. That is the only way F6 gets settled.

## B04 · `capture/run-07.mp4` 2.60–3.90 s — coyote time

**Observed.** The ground ends at x = 448. The body leaves the floor at frame 86
(tick 164, x = 459.55). Space goes down at frame 87 — **two ticks after** the
floor is gone. `jumps` goes 2 → 3, the arc clears the 64 px gap and lands at
x = 566.92 on the platform at 512–736.

**Interpretation.** `coyote_ticks = 6` **(source)**. The same input without the
window is a death, because the jump never happens.

**Narration.** "The ground runs out at four forty-eight. The jump goes in two
physics ticks after the floor is gone — and coyote time still pays it. Six
ticks of forgiveness, one tenth of a second. That is the input log talking, not
my eyes."

**Honesty note.** A tenth of a second is not visible. The film shows it at
0.15× and labels the replay; the claim rests on the tick numbers in
`run-07-inputs.jsonl`, which is why they are quoted out loud.

**Next experiment.** Sweep the press from 0 to 9 ticks after the edge and record
the first tick that fails. The unit fixture seeds `last_floor_tick` directly;
this would be the same boundary found by walking.

## B05 · `capture/run-07.mp4` 2.87–6.57 s — one jump, and the buffer

**Observed.** A second Space press at frame 91, airborne at y = 266.33, leaves
`jumps` at 3 — nothing happens. Later, Space goes down at frame 145 while still
falling (tick 282, y = 305.53, not on the floor) and the jump fires 6 ticks
later, on the touchdown tick.

**Interpretation.** `opportunity_consumed` blocks the second jump with a boolean
rather than a timer, so it cannot drift **(source)**. `buffer_ticks = 6`, and
this press landed exactly on the outer edge of the window **(source + log)**.

**Narration.** "Press again in the air and nothing happens. There is one jump,
and it is spent. But press it just before you land, and the buffer holds it for
six ticks and fires it on the touchdown tick."

**Next experiment.** Press at 7 ticks before touchdown and confirm the jump is
dropped — the outer edge measured by play, not by seeding state.

## B06 · `capture/run-06.mp4` 4.00–8.17 s — the step is a wall

**Observed.** Walking right without jumping, the body stops dead at x = 983.0,
y = 320.0. The state stays PLAYING. The timer keeps running. Nothing happens.

**Interpretation.** The block is `[992, 296, 32, 24]`; the spike hazard on top of
it is `[996, 280, 24, 16]` — inset 4 px on each side **(source)**. A body halted
by the block's face is 9 px from its own centre, so it never reaches a trigger.

**Narration.** "Change two: Section 03. First thing in it is a spiked step. Walk
into it and the run does not end — the body stops dead at nine eighty-three,
against a face at nine ninety-two, and nothing kills you."

**Next experiment.** Walk into it at every sub-pixel offset the accel curve can
produce and confirm the stop x never varies enough to touch 996.

## B07 · `media/B07.mp4` — the source change behind B06 and B08

Not gameplay: a Claude-skinned code card (`ClaudeCodeBeat`) showing the actual
GDScript. It states the cause the two step beats show the effect of. It replaced
a `ClaudeWindow` artifact card, which measured 29 % of the safe area and set the
code too small to read.

**Interpretation (source).** `_spike_points(size, index)` returns one triangle in
the hazard rect's own coordinates. `_draw()` paints exactly those points and
`_add_area()` builds the `CollisionPolygon2D` from the same call. Before the
refactor, `_draw()` used a literal `y = 320` with `i*8` spacing while the trigger
used `size.x / 3.0`: the two agreed on flat ground and disagreed the moment a
hazard sat on a raised step. The project's own `hazard-art-matches-trigger`
check asserts both hazards' painted triangles *are* their trigger polygons and
that the new hazard's base is 296, the step top, not 320, the ground.

**Narration.** See `beat_sheet.json` B07 — spoken over the function itself.

**Next experiment.** Add a third hazard at a third height and watch the check
either hold or catch it.

## B08 · `capture/run-06.mp4` 7.13–11.27 s — hopping the step

**Observed.** Take-off logged at x = 948.26 (tick 557). The body lands at
x = 1062.93, y = 319.93 — the ground beyond the step, not the step top at
y = 296.

**Interpretation.** The measured take-off window is 940.6–964.6, about nine
ticks; six sweep take-offs across the range land on the step **zero** times
**(source: `step-is-jumped-not-stood-on`)**. The author's continuous-arc
arithmetic predicted an 11 px window and the engine measured 24, because the
spikes are triangles and a body clears their sloped ends earlier and later than
a box would allow **(source: TEST-REPORT §3B)**.

**Narration.** "So you back up and hop it. Take off inside a twenty-four pixel
window — measured, nine forty point six to nine sixty-four point six — and you
land on the ground beyond. Never on the step: six take-offs across the range
land on it zero times."

**Next experiment.** Whether a nine-tick window reads as fair is a human
question; nobody but the author has tried it **(hypothesis: it is the hardest
input in the level)**.

## B09 · `capture/run-01.mp4` 6.53–10.40 s — the stone and the chasm

**Observed.** Take-off at x = 1080.86 (tick 403) lands on the 40 px stone at
(1152, 280); take-off at x = 1174.19 (tick 438) crosses to the far platform at
(1256, 320). The camera holds its forward lead and stops at 1160. The progress
bar reaches the end as the flag comes into frame. The beat stops two frames
short of COMPLETE on purpose — the completion is B13's.

**Interpretation.** The chasm is 144 px against a measured 112 px maximum leap
**(source: CHANGE-BRIEF §Section 03 as built)**, so the stone is not optional
decoration — it is the only crossing.

**Narration.** "Then the part the section is really about. A forty pixel stone,
and behind it a hundred and forty-four pixel chasm against a measured hundred
and twelve pixel leap. You cannot jump the gap. You have to use the stone. Step
up, step across, and the flag is on the far plateau."

**Next experiment.** Try the chasm directly from the ground at every take-off x
and confirm that none of them reaches 1256.

## B10 · `capture/run-02.mp4` 0.00–7.40 s — the spikes, and getting up again

**Observed.** A click at logical (320, 232) starts the session on frame 37 — the
cursor is not in the recording, so what you see is the card responding. Walking
into the ground spikes at x = 318.21 gives DYING, `deaths` 1 and the card "Watch
the spikes". 17 frames — 0.57 s — later the player is back at (64.36, 319.93),
and the same spikes are cleared on the next attempt with a take-off at 294.21.

**Interpretation.** `retry_remaining = 0.55` plus a two-tick contact settle
**(source)**; the longest retry the project's own fixture recorded is 34 ticks,
≈ 0.567 s, which is what this capture reproduces by playing.

**Narration.** "Failure. This run starts from a click on the START button
instead of Enter — the engine's recorder does not draw the cursor, so watch the
card, not the pointer. Then I walk into the starter's spikes on purpose. Watch
the spikes. Retries goes to one, and nought point five seven seconds later I am
back at the start and clearing them."

**Next experiment.** The undocumented pointer start is either a feature to
document in the HUD or a handler to delete. A player who never reads the source
cannot know it exists.

## B11 · `capture/run-03.mp4` 5.00–10.07 s — off the end of the stone

**Observed.** This take takes off at x = 1067.52 and **does** land on the stone
at x = 1158 — then keeps walking and runs off its right end at x = 1206, because
the scripted route has no jump left. The body scrapes down the far platform's
face (x pinned at 1246.93 against a face at 1256), crosses y = 430 at y = 435.93,
and the card says "Missed the landing". Respawn at (64, 320), camera re-clamped
from 1160 to 320.

**Interpretation.** Forty pixels of stone is a step, not a place to stand. The
fall boundary is read after the slide, not at the edge, which is why the death
reads as consequence rather than as an invisible wall **(source: `fall_y = 430`
tested each physics step).**

**Honesty note.** The intent of this take was a short jump into the chasm. What
actually happened is better and is what the narration describes: the route ran
out of jumps on a 40 px stone. Nothing was re-shot to make the original
prediction true.

**Narration.** "The other way to lose. This take lands on the stone and then
simply runs off the end of it — forty pixels is a step, not a place to stand. It
clips the cliff face at twelve fifty-six, slides down, crosses the fall line at
four hundred and thirty, and the game says: missed the landing. Same retry, same
spawn, camera back to three twenty."

**Next experiment.** Ask whether the stone should be lethal-on-overshoot at all,
or whether a 56 px stone would still force the same decision with less feel-bad.

## B12 · `capture/run-04.mp4` 0.00–12.23 s — everything around the run

**Observed.** Escape at frame 111 → PAUSED at (555.55, 319.93); over the next 60
frames the position does not move and `elapsed` stays at 3.0 s. Enter at 175
resumes. R at 219 puts the player at (64, 320) with `deaths` still 0. At frame
270 another application takes the keyboard and the game pauses itself on 271. M
at 316 returns to the menu.

**Interpretation.** Freezing `elapsed` as well as position is a deliberate
choice **(source: `set_paused` gates the whole `_physics_process` branch)**. R
calls `restart_attempt()` rather than `resolve_contacts(true, …)`, which is why
the retry counter does not move **(source)**.

**Narration.** "Everything around the run still works. Escape freezes the
position and the clock — watch the timer stop. Enter resumes. R restarts the
attempt and the retry counter does not move, because a restart is not a death.
And when another application takes the keyboard — that is a real app switch, not
a faked signal — the game pauses itself. M goes back to the menu."

**Honesty note.** The cause of the auto-pause is outside the frame by
definition. The driver launched a real macOS application; no signal was emitted
by hand.

## B13 · `capture/run-01.mp4` 9.87–15.67 s — the flag, and again

**Observed.** The body reaches (1416.85, 319.93); its 18×28 rect intersects the
finish rect (1420, 264, 24, 56); state COMPLETE on frame 314 with 0 deaths and
8 jumps; the card reports 8.8 seconds and 0 retries. Enter on frame 419 replays
from (64, 320) with jumps and deaths reset.

**Interpretation.** The completion assertion requires the body to overlap the
finish rect read from the level JSON, not merely `state == COMPLETE` **(source:
`complete-real-route`)** — which is how moving the finish from 916 to 1420 was
prevented from quietly passing.

**Narration.** "And the end of it. The body overlaps the finish rect, the card
reports the time and the retries, and Enter plays the whole thing again from a
clean spawn. Eight point eight two seconds, zero retries, eight jumps."

**Next experiment.** 8.8 s is a known-route time from a script. A first-time
human number is missing and is the single most useful thing anyone could add.

---

## Renders attempted, and their results

| beat | component | result |
| --- | --- | --- |
| B00 | `ClaudeComposerAsk` | rendered |
| B01 | `BrutalistHesitantWriter` | rendered |
| B07 | `ClaudeCodeBeat` | rendered at `durationSeconds` 30.4. A first pass used `ClaudeWindow`; it measured 29 % of the safe area and was replaced |
| BVD1 | `ClaudeVerdictArtifact` | rendered at `durationSeconds` 30.5 |
| BVD2 | `ClaudeVerdictArtifact` | rendered at `durationSeconds` 28.9. The verdict was one 36 s card in the first cut; splitting it gave the viewer a beat change and each half five lines |
| BHTF | `ClaudeComposerAsk` | rendered at `durationSeconds` 26.9 |
| BOUT | `ClaudeTitleOutro` | rendered; **silent** — see the asset blocker in `_qc/REPORT.md` |

No render failed and none was silently omitted.

## What this riff cannot tell you

It is one scripted route through a build, plus six targeted takes. It shows that
the features work and what they do. It does not show whether any of it is fun,
fair, readable to a stranger, or worth playing twice. Those are human calls and
one person has made them — the author, who also wrote the code.
