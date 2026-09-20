extends RefCounted
## Fixed input route through the real level. No position/velocity edits.
## Marks 1-5 are the starter's original route; 6-8 cross Section 03: 948 over
## the spiked step, 1080 up onto the high stone, 1174 the stone -> the far
## platform. Section 03's ground runs straight on from the starter's last
## platform, so there is no gap to cross on the way in. Take-off x only; the
## same keys a player presses, never a position edit.
var jump_marks: Array[float] = [138.0, 292.0, 424.0, 548.0, 712.0, 948.0, 1080.0, 1174.0]
var next_jump: int = 0

func step(player: CharacterBody2D) -> void:
	player.test_control = true
	player.test_axis = 1.0
	player.test_jump_held = false
	if next_jump < jump_marks.size() and player.position.x >= jump_marks[next_jump] and player.is_on_floor():
		player.test_jump_pressed = true
		next_jump += 1
