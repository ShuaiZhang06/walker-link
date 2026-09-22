# PROMPTS — claude-liam-walker-link-walkthrough

Two prompts appear on screen. Both are shown as text inside the Claude
composer; neither is presented as a historical transcript.

## B00 — the cold open (ILLUSTRATIVE RECONSTRUCTION)

> Please use Walker to convert my game design document about a small Godot
> platformer — a green-capped adventurer crossing a short course of ledges, gaps
> and spikes, one fixed-height jump, unlimited retries — into a playable Godot
> project I can run, read and extend.

**Status: reconstruction.** No transcript of an original Walker prompt exists in
this repository. The card's running line reads "reconstructed prompt —
illustrative, not a transcript", and the narration says it out loud in its
second sentence. What *is* recorded is the starter's own authorisation, quoted
in `BUILD-REPORT.md`: **"Build a simple level for walker-jumpman."**

The three output lines under the composer are facts, not invention:

* `Starter: nikbearbrown/walker-jumpman — "First Steps", Godot 4.7.2.`
* `Fork: ShuaiZhang06/walker-link @ 19a7ddd — new character, new Section 03.`
* `Played below input-only; tuning.gd and the player collider untouched.`

No fabricated build log, progress bar, token count or tool-call receipt appears
anywhere in the film.

## BHTF — Your Turn (a real prompt, for the viewer)

> Fork walker-link, keep tuning.gd and the player collider byte-for-byte, and
> add a fourth section whose hardest jump is measured — print the take-off
> window in ticks instead of guessing it.

This is the experiment the film argues for, and it is the one the project's own
history justifies: the author's continuous-arc arithmetic predicted an ~11 px
safe take-off window over the spiked step and the engine measured 24 px.

## Generation prompts

**None.** No image, video, music or voice was generated from a prompt for this
film. Narration is local Kokoro `am_onyx` reading the beat sheet's
`narration_text` verbatim. Every non-gameplay frame is a Remotion component
already in the toolkit (`ClaudeComposerAsk`, `BrutalistHesitantWriter`,
`ClaudeWindow`, `ClaudeVerdictArtifact`, `ClaudeTitleOutro`). Every gameplay
frame came out of the Godot engine. No paid service was used.
