extends RefCounted
## Fixed input route through the real level. No position/velocity edits.
## Marks 1-5 are the starter's original route; 6-9 cross Section 03:
## 932 the platform -> the Section 03 ground, 1052 over the spiked step,
## 1200 up onto the high stone, 1294 the stone -> the far platform. Take-off x
## only; the same keys a player presses, never a position edit.
var jump_marks: Array[float] = [138.0, 292.0, 424.0, 548.0, 712.0, 932.0, 1052.0, 1200.0, 1294.0]
var next_jump: int = 0

func step(player: CharacterBody2D) -> void:
	player.test_control = true
	player.test_axis = 1.0
	player.test_jump_held = false
	if next_jump < jump_marks.size() and player.position.x >= jump_marks[next_jump] and player.is_on_floor():
		player.test_jump_pressed = true
		next_jump += 1
