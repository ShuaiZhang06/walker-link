extends SceneTree
const Game = preload("res://game/session.gd")
const Route = preload("res://tests/route_driver.gd")
var game: Node2D
var results: Array[Dictionary] = []
var failures: int = 0

func _initialize() -> void:
	call_deferred("run")

func steps(n: int) -> void:
	for i in range(n):
		await physics_frame
		await process_frame

func check(id: String, passed: bool, observation: Dictionary) -> void:
	results.append({"id": id, "status": "PASS" if passed else "FAIL", "observed": observation})
	if not passed:
		failures += 1
	print(JSON.stringify(results.back()))

func fresh() -> void:
	if is_instance_valid(game):
		game.queue_free()
		await process_frame
	game = Game.new()
	game.test_mode = true
	root.add_child(game)
	game.start_session()
	game.player.test_control = true
	await steps(3)

## One input-driven Section 03 trial: stand at `start`, hold right, jump on the
## first tick past `mark`, and report where the body comes to rest. The player is
## placed once, before the run; nothing is repositioned in flight.
func takeoff_trial(start: Vector2, mark: float) -> Dictionary:
	await fresh()
	game.player.position = start
	game.player.test_axis = 1.0
	await steps(3)
	var jumped := false
	var airborne := false
	var takeoff_vx := 0.0
	for i in range(140):
		if not jumped and game.player.position.x >= mark and game.player.is_on_floor():
			game.player.test_jump_pressed = true
			jumped = true
			takeoff_vx = game.player.velocity.x
		await steps(1)
		airborne = airborne or (jumped and not game.player.is_on_floor())
		var resting: bool = airborne and game.player.is_on_floor()
		if game.state != Game.State.PLAYING or resting:
			return {"landed": resting and game.state == Game.State.PLAYING,
				"died": game.state == Game.State.DYING, "mark": mark,
				"takeoff_vx": snappedf(takeoff_vx, 0.1), "x": snappedf(game.player.position.x, 0.01),
				"y": snappedf(game.player.position.y, 0.01)}
	return {"landed": false, "died": false, "mark": mark, "takeoff_vx": snappedf(takeoff_vx, 0.1),
		"x": snappedf(game.player.position.x, 0.01), "y": snappedf(game.player.position.y, 0.01)}

func run() -> void:
	await fresh()
	check("launch-grounded", game.player.is_on_floor() and game.state == Game.State.PLAYING, {"position": str(game.player.position), "engine": Engine.get_version_info().string})
	game.player.test_axis = 1
	await steps(8)
	check("speed-cap", is_equal_approx(game.player.velocity.x,160), {"velocity_x": game.player.velocity.x})
	game.player.test_axis = 0
	await steps(5)
	check("neutral-stop", is_zero_approx(game.player.velocity.x), {"velocity_x": game.player.velocity.x})
	game.player.test_control = false
	Input.action_press("move_left")
	Input.action_press("move_right")
	await steps(5)
	check("simultaneous-directions", is_zero_approx(game.player.velocity.x), {"velocity_x": game.player.velocity.x})
	Input.action_release("move_left")
	Input.action_release("move_right")
	game.player.test_control = true
	game.player.test_axis = -1
	await steps(70)
	check("left-wall", game.player.position.x >= 9 and game.player.position.x <= 11, {"x": game.player.position.x})
	await fresh()
	game.player.test_jump_pressed = true
	game.player.test_jump_held = true
	var min_y: float = game.player.position.y
	for i in range(50):
		await steps(1)
		min_y = minf(min_y, game.player.position.y)
		if i == 12:
			game.player.test_jump_pressed = true
	check("fixed-jump-and-no-double", game.player.jumps == 1 and absf((320-min_y)-53.3333) < 5, {"rise_px":320-min_y, "jumps":game.player.jumps})
	await steps(30)
	check("held-jump-no-bounce", game.player.jumps == 1 and game.player.is_on_floor(), {"jumps":game.player.jumps})
	# Actual geometry fixtures at a ledge; tick ages exercise inclusive 6 / expired 7.
	for age in [5,6,7]:
		await fresh()
		game.player.position = Vector2(478, 285)
		await steps(2)
		game.player.last_floor_tick = game.player.tick + 1 - age
		game.player.opportunity_consumed = false
		game.player.test_jump_pressed = true
		await steps(1)
		check("coyote-%d" % age, (game.player.jumps == 1) == (age <= 6), {"age":age, "jumps":game.player.jumps})
	for age in [5,6,7]:
		await fresh()
		game.player.jump_request_tick = game.player.tick + 1 - age
		await steps(1)
		check("buffer-%d" % age, (game.player.jumps == 1) == (age <= 6), {"age":age, "jumps":game.player.jumps})
	await fresh()
	game._add_solid(Rect2(32,260,64,12))
	await steps(2)
	game.player.test_jump_pressed = true
	min_y = 320
	for i in range(45):
		await steps(1)
		min_y = minf(min_y,game.player.position.y)
	check("low-ceiling", min_y >= 300-0.2 and game.player.jumps == 1 and game.player.is_on_floor(), {"minimum_feet_y":min_y,"jumps":game.player.jumps})
	await fresh()
	game.player.test_jump_pressed = true
	await steps(5)
	game.set_paused(true)
	var paused_position: Vector2 = game.player.position
	var paused_time: float = game.elapsed
	await steps(10)
	check("pause-freezes", game.player.position == paused_position and game.elapsed == paused_time, {"position":str(game.player.position),"elapsed":game.elapsed})
	game.set_paused(false)
	game.test_mode = false
	game._on_focus_lost()
	check("focus-loss-pauses", game.state == Game.State.PAUSED, {"state":game.state})
	game.test_mode = true
	await fresh()
	game.player.position = Vector2(330,310)
	await steps(4)
	check("actual-spike-collision", game.state == Game.State.DYING and game.deaths == 1, {"state":game.state,"deaths":game.deaths})
	game.resolve_contacts(true,true)
	check("duplicate-death-ignored", game.deaths == 1, {"deaths":game.deaths})
	await steps(38)
	check("respawn", game.state == Game.State.PLAYING and game.player.position.distance_to(Vector2(64,320)) < 1, {"state":game.state,"position":str(game.player.position)})
	game.restart_attempt()
	check("manual-restart-not-death", game.deaths == 1, {"deaths":game.deaths})
	var largest_retry_ticks: int = 0
	for i in range(20):
		game.resolve_contacts(true,false)
		var waited := 0
		while game.state == Game.State.DYING and waited < 65:
			await steps(1)
			waited += 1
		largest_retry_ticks = maxi(largest_retry_ticks, waited)
	check("twenty-retries", game.deaths == 21 and largest_retry_ticks <= 60, {"deaths":game.deaths,"max_retry_ticks":largest_retry_ticks})
	await fresh()
	game.resolve_contacts(true,true)
	check("death-before-finish", game.state == Game.State.DYING, {"state":game.state})
	await fresh()
	game.player.position = Vector2(415,432)
	await steps(1)
	check("fall-boundary", game.state == Game.State.DYING, {"state":game.state})
	# --- Section 03: the spiked step, the high stone, the far platform ---
	await fresh()
	var art_ok := true
	var spike_bases: Array = []
	for h in range(game.hazard_areas.size()):
		var entry: Array = game.level.hazards[h]
		var rect := Rect2(entry[0], entry[1], entry[2], entry[3])
		var area: Area2D = game.hazard_areas[h]
		art_ok = art_ok and area.position == rect.position and area.get_child_count() == 3
		for i in range(area.get_child_count()):
			var triangle: CollisionPolygon2D = area.get_child(i)
			# _draw() paints _spike_points(size, i) under the same origin, so equal
			# points here means the painted triangle is the triangle that kills.
			art_ok = art_ok and triangle.polygon == game._spike_points(rect.size, i)
			art_ok = art_ok and is_equal_approx((area.position + triangle.polygon[0]).y, rect.end.y)
			art_ok = art_ok and is_equal_approx((area.position + triangle.polygon[1]).y, rect.position.y)
		spike_bases.append(rect.end.y)
	# Second hazard's base is the step's top (296), not the ground (320).
	check("hazard-art-matches-trigger", art_ok and spike_bases == [320.0, 296.0], {"spike_base_y": spike_bases})
	await fresh()
	game.player.position = Vector2(956, 320)
	game.player.test_axis = 0.0
	await steps(30)
	check("step-spike-safe-strip", game.state == Game.State.PLAYING and game.player.is_on_floor() and absf(game.player.position.y - 320.0) < 0.2, {"position":str(game.player.position), "clearance_px":996-(956+9)})
	# Walking into the step's side is a wall, not a death: the spikes are inset 4px
	# from the block's edges, so a blocked body never touches a trigger.
	game.player.test_axis = 1.0
	await steps(40)
	check("step-blocks-the-walk", game.state == Game.State.PLAYING and absf(game.player.position.x - 983.0) < 1.0 and absf(game.player.position.y - 320.0) < 0.2, {"position":str(game.player.position), "step_face_x":992})
	# The step must be jumped over, never stood on: sweep the hop's take-off range
	# and count how many trials come to rest on the step's surface (y = 296).
	var hop := {"cleared":0, "died":0, "stood_on_step":0, "cleared_marks":[], "died_marks":[]}
	for mark in [932.0, 940.0, 946.0, 952.0, 958.0, 966.0]:
		var trial: Dictionary = await takeoff_trial(Vector2(888, 320), mark)
		if bool(trial["landed"]) and absf(float(trial["y"]) - 296.0) < 0.2:
			hop["stood_on_step"] += 1
		elif bool(trial["landed"]):
			hop["cleared"] += 1
			hop["cleared_marks"].append(mark)
		else:
			hop["died"] += 1
			hop["died_marks"].append(mark)
	check("step-is-jumped-not-stood-on", hop["stood_on_step"] == 0 and hop["cleared"] >= 3 and hop["died"] >= 1, hop)
	var stone: Dictionary = await takeoff_trial(Vector2(1035, 320), 1080.0)
	check("high-stone-reachable", bool(stone["landed"]) and absf(float(stone["y"]) - 280.0) < 0.2 and float(stone["x"]) > 1152.0 and float(stone["x"]) < 1192.0, stone)
	# The stone is the only way across the 144px chasm, and only from the last
	# stretch of ground: an early take-off falls instead of clearing it.
	var reach := {"on_stone":0, "fell":0, "stone_marks":[], "fell_marks":[]}
	for mark in [1044.0, 1053.0, 1062.0, 1071.0, 1080.0, 1089.0, 1098.0]:
		var trial: Dictionary = await takeoff_trial(Vector2(1035, 320), mark)
		if bool(trial["landed"]) and absf(float(trial["y"]) - 280.0) < 0.2:
			reach["on_stone"] += 1
			reach["stone_marks"].append(mark)
		else:
			reach["fell"] += 1
			reach["fell_marks"].append(mark)
	check("stone-takeoff-sweep", reach["on_stone"] > 0 and reach["fell"] > 0, reach)
	await fresh()
	game.player.position = Vector2(1380, 320)
	await steps(3)
	var plateau_camera: float = game.camera.position.x
	game.player.position = Vector2(1380, 432)
	await steps(1)
	var died_on_plateau: bool = game.state == Game.State.DYING
	await steps(38)
	check("plateau-death-respawn", died_on_plateau and game.state == Game.State.PLAYING and game.player.position.distance_to(Vector2(64,320)) < 1 and is_equal_approx(game.camera.position.x, 320.0) and is_equal_approx(plateau_camera, float(game.level.width) - 320.0), {"camera_on_plateau":plateau_camera, "camera_after_respawn":game.camera.position.x, "position":str(game.player.position)})
	await fresh()
	var route = Route.new()
	var route_ticks := 0
	while game.state == Game.State.PLAYING and route_ticks < 900:
		route.step(game.player)
		await steps(1)
		route_ticks += 1
	var f: Array = game.level.finish
	var finish_rect := Rect2(f[0], f[1], f[2], f[3])
	var body := Rect2(game.player.position.x - 9.0, game.player.position.y - 28.0, 18, 28)
	check("complete-real-route", game.state == Game.State.COMPLETE and game.deaths == 0 and body.intersects(finish_rect), {"state":game.state,"deaths":game.deaths,"ticks":route_ticks,"position":str(game.player.position),"jump_marks_used":route.next_jump,"finish_rect":str(finish_rect)})
	game.start_session()
	game.start_session()
	check("replay-idempotent", game.state == Game.State.PLAYING and game.deaths == 0 and game.player.jumps == 0, {"state":game.state,"deaths":game.deaths,"jumps":game.player.jumps})
	var report := {"scope":"First Steps slice; not full GDD acceptance or human playtesting", "engine":Engine.get_version_info().string,"created_at":Time.get_datetime_string_from_system(true),"results":results,"failures":failures}
	var out := ProjectSettings.globalize_path("res://../evidence")
	DirAccess.make_dir_recursive_absolute(out)
	var file := FileAccess.open(out + "/mechanics-" + str(Time.get_unix_time_from_system()) + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"  "))
	file.close()
	print("WALKER TESTS: %d checks / %d failures" % [results.size(), failures])
	game.queue_free()
	await process_frame
	quit(1 if failures else 0)
