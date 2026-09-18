extends SceneTree
## Static plates of the level drawing, tiled across the whole world.
##
## The pixel regression for CHANGE-BRIEF step B: deriving session.gd::_draw()
## from the level data instead of hard-coded 960/1400 literals must not move a
## single pixel while the level JSON is unchanged. The game is paused and the
## player and the HUD are hidden, so nothing animates and two runs of this
## script produce byte-identical files.
const Game = preload("res://game/session.gd")
var game: Node2D
var output: String

func _initialize() -> void:
	call_deferred("run")

func step() -> void:
	await physics_frame
	await process_frame

func plate(label: String, camera_x: float) -> void:
	game.camera.position = Vector2(camera_x, 180)
	await step()
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png("%s/%s.png" % [output, label])
	assert(error == OK)
	print("%s  camera_x=%d" % [label, int(camera_x)])

func run() -> void:
	output = ProjectSettings.globalize_path("res://../evidence/screens/level")
	DirAccess.make_dir_recursive_absolute(output)
	game = Game.new()
	game.test_mode = true
	root.add_child(game)
	for i in range(3): await step()
	game.start_session()
	await step()
	game.set_paused(true)
	game.hud.hide()
	game.player.hide()
	# The camera's own clamp range, tiled so the plates cover x = 0 .. level.width.
	var left := 320.0
	var right := maxf(float(game.level.width) - 320.0, left)
	var count := 1 + int(ceil((right - left) / 512.0))
	for i in range(count):
		var x := left if count == 1 else left + (right - left) * float(i) / float(count - 1)
		await plate("level-%02d" % i, x)
	print("LEVEL PLATES: %d for width %d" % [count, int(game.level.width)])
	game.queue_free()
	await process_frame
	quit()
