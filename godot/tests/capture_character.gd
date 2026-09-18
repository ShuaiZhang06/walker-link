extends SceneTree
## Pose sheet for the player drawing, with the real collider outlined on top.
## Evidence for CHANGE-BRIEF F6: the sword and the shield overhang the collider
## on purpose. Rendering script, not headless; it changes no game value.
const Game = preload("res://game/session.gd")

class ColliderOutline extends Node2D:
	var target: Node2D
	func _process(_delta: float) -> void:
		queue_redraw()
	func _draw() -> void:
		if not is_instance_valid(target):
			return
		# Exactly the shape built in player.gd::_ready(): 18x28 at local (0, -14).
		draw_rect(Rect2(target.position.x - 9.0, target.position.y - 28.0, 18, 28), Color("d24e42"), false, 0.5)

var game: Node2D
var outline: Node2D
var output: String

func _initialize() -> void:
	call_deferred("run")

func step() -> void:
	await physics_frame
	await process_frame

func pose(label: String) -> void:
	game.set_paused(true)
	game.hud.hide()
	game.camera.zoom = Vector2(5, 5)
	game.camera.position = game.player.position + Vector2(0, -14)
	await step()
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(output + "/" + label + ".png")
	assert(error == OK)
	print("%s  facing=%d  on_floor=%s  position=%s" % [label, int(game.player.facing), game.player.is_on_floor(), game.player.position])
	game.set_paused(false)
	game.camera.zoom = Vector2.ONE

func run() -> void:
	output = ProjectSettings.globalize_path("res://../evidence/screens/character")
	DirAccess.make_dir_recursive_absolute(output)
	game = Game.new()
	game.test_mode = true
	root.add_child(game)
	for i in range(3): await step()
	game.start_session()
	game.player.test_control = true
	outline = ColliderOutline.new()
	outline.target = game.player
	outline.z_index = 100
	game.add_child(outline)
	game.player.test_axis = 1.0
	for i in range(14): await step()
	await pose("character-facing-right")
	game.player.test_axis = -1.0
	for i in range(14): await step()
	await pose("character-facing-left")
	game.player.test_axis = 1.0
	game.player.test_jump_pressed = true
	for i in range(14): await step()
	await pose("character-mid-jump")
	# Feet on the last pixels of the starting ground, which ends at x = 448.
	game.player.test_axis = 0.0
	game.player.velocity = Vector2.ZERO
	game.player.position = Vector2(440, 320)
	for i in range(8): await step()
	await pose("character-ledge-edge")
	game.queue_free()
	await process_frame
	quit()
