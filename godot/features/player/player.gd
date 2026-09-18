extends CharacterBody2D

const Tuning = preload("res://features/player/tuning.gd")
var tuning = Tuning.new()
var enabled: bool = false
var tick: int = 0
var last_floor_tick: int = -1000
var jump_request_tick: int = -1000
var opportunity_consumed: bool = false
var require_jump_release: bool = true
var facing: float = 1.0
var jumps: int = 0
var test_control: bool = false
var test_axis: float = 0.0
var test_jump_pressed: bool = false
var test_jump_held: bool = false

func _ready() -> void:
	name = "Player"
	collision_layer = 2
	collision_mask = 1
	floor_snap_length = 1.0
	var shape := RectangleShape2D.new()
	shape.size = Vector2(18, 28)
	var collider := CollisionShape2D.new()
	collider.shape = shape
	collider.position = Vector2(0, -14)
	add_child(collider)

func reset_at(spawn: Vector2) -> void:
	position = spawn
	velocity = Vector2.ZERO
	last_floor_tick = -1000
	jump_request_tick = -1000
	opportunity_consumed = false
	require_jump_release = true
	test_jump_pressed = false
	jumps = 0
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	tick += 1
	var axis := test_axis if test_control else Input.get_axis("move_left", "move_right")
	var held := test_jump_held if test_control else Input.is_action_pressed("jump")
	var pressed := test_jump_pressed if test_control else Input.is_action_just_pressed("jump")
	test_jump_pressed = false
	if not held:
		require_jump_release = false
	if is_on_floor() and velocity.y >= 0.0:
		last_floor_tick = tick
		opportunity_consumed = false
	if pressed and not require_jump_release:
		jump_request_tick = tick
	var rate: float = tuning.acceleration if not is_zero_approx(axis) else tuning.deceleration
	velocity.x = move_toward(velocity.x, axis * tuning.speed, rate * delta)
	if not is_zero_approx(axis):
		facing = signf(axis)
	velocity.y = minf(velocity.y + tuning.gravity * delta, tuning.terminal_velocity)
	if not opportunity_consumed and tick - last_floor_tick <= tuning.coyote_ticks and tick - jump_request_tick <= tuning.buffer_ticks:
		velocity.y = tuning.jump_velocity
		opportunity_consumed = true
		jump_request_tick = -1000
		jumps += 1
	move_and_slide()
	position.x = maxf(position.x, 10.0)
	queue_redraw()

func _mirror(points: Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in points:
		out.append(Vector2(p.x * facing, p.y))
	return out

func _mpoint(p: Vector2) -> Vector2:
	return Vector2(p.x * facing, p.y)

func _mrect(x: float, y: float, w: float, h: float) -> Rect2:
	return Rect2(x if facing > 0.0 else -x - w, y, w, h)

func _blade(base: Vector2, tip: Vector2, half_base: float, half_shoulder: float) -> PackedVector2Array:
	# Tapered blade: a straight base edge, a shoulder at 72% of the length, then a
	# single point at the tip. Convex, so it mirrors without a winding problem.
	var axis := tip - base
	var side := Vector2(-axis.y, axis.x).normalized()
	var shoulder := base + axis * 0.72
	return _mirror([
		base + side * half_base,
		shoulder + side * half_shoulder,
		tip,
		shoulder - side * half_shoulder,
		base - side * half_base,
	])

func _draw() -> void:
	# Original geometric drawing. Visual only: no tuning value and no collider is
	# touched here. Cap, head, tunic and legs stay inside the 18x28 collider
	# (x in [-9, 9], y in [-28, 0]), so what reads as the body is what collides.
	# The sword and the shield are held props: they reach past that box by at most
	# 4.5px (the blade tip) and use lighter secondary colours, so they
	# read as carried objects rather than as hitbox. Props get no collision shape.
	var ink := Color("25354a")
	var tunic := Color("287c68")
	var tunic_dark := Color("1d5c4d")
	var skin := Color("f0c19a")
	var ear := Color("dfab81")
	var hair := Color("e3bc6a")
	var steel := Color("8fa0b0")
	var steel_dark := Color("44566b")
	var steel_light := Color("d7dfe5")
	var brass := Color("8a7a52")
	var grounded := is_on_floor()
	var stride := sin(float(tick) * 0.7) * 2.0 if grounded and absf(velocity.x) > 8 else 0.0
	# A foot lifts instead of the leg stretching, so the feet never leave the box.
	var lift_back := maxf(stride, 0.0)
	var lift_front := maxf(-stride, 0.0)
	# Sword, behind the body, angled up and back along the trailing side. A dark
	# tapered blade with a lighter one inside it: the point stays readable against
	# the pale backdrop, which a single light shape does not.
	var blade_base := Vector2(-6.8, -12.0)
	var blade_tip := Vector2(-13.5, -22.6)
	draw_colored_polygon(_blade(blade_base, blade_tip, 1.9, 1.45), steel_dark)
	draw_colored_polygon(_blade(blade_base, blade_tip.lerp(blade_base, 0.07), 1.0, 0.7), steel_light)
	draw_line(_mpoint(Vector2(-9.6, -10.0)), _mpoint(Vector2(-4.4, -13.4)), brass, 3.0)
	draw_rect(_mrect(-7.1, -11.1, 3, 3), brass)
	# In the air both legs tuck, so the jump pose is not the standing pose.
	var tuck := 0.0 if grounded else 1.5
	draw_rect(Rect2(-5, -4, 4, 4 - lift_back - tuck), ink)
	draw_rect(Rect2(1, -4, 4, 4 - lift_front - tuck), ink)
	# Tunic: narrow shoulders, hem flared to the full width of the collider.
	draw_colored_polygon(PackedVector2Array([Vector2(-5, -14), Vector2(5, -14), Vector2(9, -4), Vector2(-9, -4)]), ink)
	draw_colored_polygon(PackedVector2Array([Vector2(-4, -13), Vector2(4, -13), Vector2(7.6, -5), Vector2(-7.6, -5)]), tunic)
	draw_rect(Rect2(-7.4, -6.5, 14.8, 1.5), tunic_dark)
	draw_rect(Rect2(-6, -10, 12, 2), Color("ef875f"))
	# The cap tail lifts in the air. Drawn before the head so the ear stays visible.
	var tail_tip := -23.0 if not grounded else -16.5
	draw_colored_polygon(_mirror([Vector2(-6, -20), Vector2(-6, -15), Vector2(-9, tail_tip)]), tunic_dark)
	draw_rect(Rect2(-6, -20, 12, 7), ink)
	draw_rect(Rect2(-5, -19, 10, 5), skin)
	draw_rect(Rect2(-5, -19, 10, 2), hair)
	draw_colored_polygon(_mirror([Vector2(-6, -18.5), Vector2(-6, -15.5), Vector2(-8.6, -17.0)]), ear)
	draw_rect(_mrect(2, -17.5, 2, 3), ink)
	draw_rect(Rect2(-8, -21.5, 16, 2.5), tunic_dark)
	draw_colored_polygon(PackedVector2Array([Vector2(-6.5, -21), Vector2(6.5, -21), Vector2(-4.0 * facing, -28.0)]), tunic)
	# Shield, in front of the body, on the leading arm.
	draw_rect(_mrect(5.5, -13.5, 7, 9), Color("5d7185"))
	draw_rect(_mrect(6.5, -12.5, 5, 7), steel)
	draw_rect(_mrect(8.0, -10.5, 2, 3), steel_light)
