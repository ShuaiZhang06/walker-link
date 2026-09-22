# BUILD-PROMPT — how this reel was asked for and built

## The request

Make one required Brutalist Godot explainer for `walker-link` using the
course-provided `godot-walkthrough` workflow with the `walker` modifier
(original skill spelling: `godot-waikthrough`), reading the installed skill
instructions rather than assuming a standalone executable. One landscape film
that identifies the starter, the character concept and the level extension;
shows the modified game actually played, including the new landings, a
failure/recovery and a completion; explains at least one cause-and-effect link
between a source change and on-screen behaviour; states what was tested, what
remains uncertain and one concrete next improvement; and identifies the human
and AI contributions and the revision demonstrated. Native 4K, quality checks,
then watch the export. No Short, no paid generation, no publication.

## Where each requirement is discharged

| requirement | beat |
| --- | --- |
| starter, character concept, level extension | B00 output lines, B01, B03 (character), B06/B08/B09 (Section 03) |
| the modified game actually played | B02–B06, B08–B13 — all real engine capture |
| the new landings | B08 (ground beyond the spiked step), B09 (the stone, then the far platform) |
| a failure and a recovery | B10 (spikes → auto-retry → cleared), B11 (chasm → "Missed the landing" → respawn) |
| a completion | B09 into B13 (COMPLETE, body inside the finish rect, results card, replay) |
| cause and effect: source change → behaviour | B07 (`_spike_points()` and the 4 px inset) explaining B06 and B08 |
| tested / uncertain / next improvement | BVDT |
| human vs AI contributions, and the revision | BVDT (spoken and on the card); revision also on the B00 card |

## The build, in order

```bash
# 0. confirm the build is green before filming anything
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot \
  --script res://tests/test_game.gd            # 34 checks / 0 failures, exit 0

# 1. isolated capture copy (never the original project)
rsync -a --exclude .godot --exclude .DS_Store walker-link/godot/ "$SCRATCH/capture-project/"
#    window override -> 3840x2160; add tests/capture_walkthrough.gd

# 2. seven input-only takes, native 4K, Movie Maker at a fixed 30 fps
for T in run-01 … run-07; do
  HOME="$SCRATCH/userdata" Godot --path "$SCRATCH/capture-project" \
    --script res://tests/capture_walkthrough.gd \
    --write-movie "$SCRATCH/takes/$T.avi" --fixed-fps 30 --quit-after 2000 \
    -- --take $T --log "$SCRATCH/takes/$T.jsonl"
done
#    AVI -> H.264, frame counts verified identical

# 3. author beat_sheet.json, then measure the voice
python3 runtime/scripts/generate_audio_kokoro.py REEL

# 4. cut each gameplay slot to exactly ceil(narration * 30) frames
#    (1.0x action, labelled replays, labelled held tail)

# 5. render the Claude bookends and cards
python3 runtime/scripts/remotion_scenes.py REEL

# 6. gates, then the master
./art godot-waikthrough --check REEL
./art final REEL --height 2160 --fps 30 --out REEL/exports/landscape
./art godot-waikthrough --check REEL
```

## Standing constraints honoured

* The original `walker-link/godot/` was not modified. The only file the film run
  added to the game repository is a new `evidence/mechanics-*.json` from the
  pre-flight test run, which is that project's own documented convention.
* No `test_control` hook, teleport, state write or collision change was used to
  produce a played result.
* No gameplay was sped up, slowed down or center-cut to fit narration.
* Nothing was uploaded, exported to a game build, published, or pushed.
