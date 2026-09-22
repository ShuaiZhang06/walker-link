# SHOTLIST — claude-liam-walker-link-walkthrough

Landscape 3840 x 2160 @ 30 fps. Gameplay slots are cut from the hashed 4K
captures in `capture/`; every `1.0x` segment is copied frame for frame, and
compile.py's conform ratio is 1.000000 for all eighteen slots.

| beat | in / duration | source | build |
| --- | --- | --- | --- |
| **B00** · cold open — the Walker ask |   0.00s + 15.53s | Remotion `ClaudeComposerAsk` | rendered 3840x2160 (--scale=2, PNG frames, crf 16) |
| **B01** · BLUF — what was actually built |  15.53s + 23.20s | Remotion `BrutalistHesitantWriter` | rendered 3840x2160 (--scale=2, PNG frames, crf 16) |
| **B02** · the starter course |  38.73s +  8.93s | run-01 f0–200 @1.0x<br>run-01 f116–134 @0.25x — REPLAY 0.25× — the first gap | 272 action frames + 0 held = 268 |
| **B03** · the character |  47.67s + 13.80s | run-05 f0–100 @1.0x<br>run-05 f56–96 @0.25x — REPLAY 0.25× — the turn, mirrored<br>run-05 f100–186 @1.0x | 346 action frames + 68 held = 414 |
| **B04** · coyote time |  61.47s + 12.60s | run-07 f20–112 @1.0x<br>run-07 f78–102 @0.15x — REPLAY 0.15× — jump pressed after the edge<br>run-07 f102–155 @1.0x | 305 action frames + 73 held = 378 |
| **B05** · no double jump, and the buffer |  74.07s +  9.90s | run-07 f86–180 @1.0x<br>run-07 f88–100 @0.2x — REPLAY 0.2× — the refused second press<br>run-07 f138–156 @0.2x — REPLAY 0.2× — buffered, then landing<br>run-07 f180–197 @1.0x | 261 action frames + 36 held = 297 |
| **B06** · Section 03 — the step is a wall |  83.97s + 11.27s | run-06 f120–240 @1.0x<br>run-06 f178–200 @0.2x — REPLAY 0.2× — blocked, not killed<br>run-06 f200–245 @1.0x | 275 action frames + 63 held = 338 |
| **B07** · cause and effect — one source change |  95.23s + 30.40s | Remotion `ClaudeCodeBeat` | rendered 3840x2160 (--scale=2, PNG frames, crf 16) |
| **B08** · Section 03 — hopping the step | 125.63s + 13.87s | run-06 f214–310 @1.0x<br>run-06 f272–302 @0.15x — REPLAY 0.15× — the hop<br>run-06 f302–338 @1.0x | 332 action frames + 84 held = 416 |
| **B09** · Section 03 — the stone, the chasm, the flag | 139.50s + 14.77s | run-01 f196–290 @1.0x<br>run-01 f242–280 @0.15x — REPLAY 0.15× — stone, then the crossing<br>run-01 f280–312 @1.0x | 379 action frames + 64 held = 443 |
| **B10** · failure and recovery — the spikes | 154.27s + 16.53s | run-02 f0–120 @1.0x<br>run-02 f84–118 @0.15x — REPLAY 0.15× — contact, card, respawn<br>run-02 f118–222 @1.0x | 451 action frames + 45 held = 496 |
| **B11** · failure and recovery — the chasm | 170.80s + 17.43s | run-03 f150–275 @1.0x<br>run-03 f214–252 @0.12x — REPLAY 0.12× — off the stone, down the cliff<br>run-03 f252–302 @1.0x | 492 action frames + 31 held = 523 |
| **B12** · pause, restart, menu, focus | 188.23s + 18.30s | run-04 f0–300 @1.0x<br>run-04 f262–284 @0.2x — REPLAY 0.2× — another app takes the keyboard<br>run-04 f284–367 @1.0x | 493 action frames + 56 held = 549 |
| **B13** · the flag, the card, and again | 206.53s + 11.63s | run-01 f296–340 @1.0x<br>run-01 f304–328 @0.2x — REPLAY 0.2× — the body meets the finish rect<br>run-01 f328–470 @1.0x | 306 action frames + 43 held = 349 |
| **BVD1** · verdict — what is settled | 218.17s + 30.50s | Remotion `ClaudeVerdictArtifact` | rendered 3840x2160 (--scale=2, PNG frames, crf 16) |
| **BVD2** · verdict — what is not, and who did what | 248.67s + 28.93s | Remotion `ClaudeVerdictArtifact` | rendered 3840x2160 (--scale=2, PNG frames, crf 16) |
| **BHTF** · your turn handoff | 277.60s + 26.93s | Remotion `ClaudeComposerAsk` | rendered 3840x2160 (--scale=2, PNG frames, crf 16) |
| **BOUT** · outro | 304.53s +  5.00s | Remotion `ClaudeTitleOutro` | rendered 3840x2160 (--scale=2, PNG frames, crf 16) |

**Total: 309.53 s** = 9286 frames at 30 fps (5:09.5).

## Labels burned into the picture

| label | where | means |
| --- | --- | --- |
| `SCRIPTED INPUT · NATIVE 4K ENGINE CAPTURE` | top right of every gameplay frame | provenance of the footage |
| `REPLAY 0.xx× — …` | under it, for the slowed segment only | the same action again, slowed, outside its real-time interval |
| `HELD FINAL FRAME · N.Ns · no gameplay` | under it, for the held tail only | narration is still running; the game is not |

No subtitles and no burned captions. No sidecar SRT was requested or written.

## What is deliberately *not* in the picture

* No invented HUD, no reconstructed interface, no mocked-up game.
* No sped-up, slowed or center-cut real-time gameplay.
* No sound of any kind over the gameplay — the game is silent and stayed silent.
