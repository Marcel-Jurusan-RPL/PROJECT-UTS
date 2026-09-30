extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const COYOTE_TIME = 0.15
const JUMP_BUFFER_TIME = 0.15

const MAX_JUMPS = 2
var jumps_left: int = MAX_JUMPS
var is_double_jumping: bool = false

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var was_on_floor: bool = false
var default_scale: Vector2 = Vector2(3, 3)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	# Enforce crisp pixel art rendering (Nearest texture filter)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if animated_sprite:
		animated_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		default_scale = animated_sprite.scale


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME
		jumps_left = MAX_JUMPS
		is_double_jumping = false
		# Detect landing feedback
		if not was_on_floor:
			_apply_squash_and_stretch(Vector2(default_scale.x * 1.15, default_scale.y * 0.85))

	was_on_floor = is_on_floor()

	# Jump buffer timer logic
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	# Handle jump (1st jump with coyote time & jump buffer, 2nd jump for double jump in mid-air)
	if jump_buffer_timer > 0.0:
		if is_on_floor() or coyote_timer > 0.0:
			velocity.y = JUMP_VELOCITY
			jumps_left = MAX_JUMPS - 1
			jump_buffer_timer = 0.0
			coyote_timer = 0.0
			is_double_jumping = false
			_apply_squash_and_stretch(Vector2(default_scale.x * 0.85, default_scale.y * 1.2))
		elif jumps_left > 0 and not is_on_floor():
			velocity.y = JUMP_VELOCITY * 0.95
			jumps_left -= 1
			jump_buffer_timer = 0.0
			is_double_jumping = true
			_apply_squash_and_stretch(Vector2(default_scale.x * 0.8, default_scale.y * 1.25))

	# Get input direction (A/D or left/right arrow)
	var direction := Input.get_axis("move_left", "move_right")
	if direction == 0.0:
		direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_animation(direction)
	move_and_slide()

	# Out of bounds check (falling off level)
	if position.y > 800:
		var gm = get_node_or_null("/root/GameManager")
		if gm:
			gm.go_to_game_over()


func update_animation(direction: float) -> void:
	if not animated_sprite:
		return

	# Flip sprite according to movement direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animation based on floor state and vertical velocity
	if not is_on_floor():
		if is_double_jumping and animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("double_jump"):
			animated_sprite.play("double_jump")
		elif velocity.y < 0:
			if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("jump"):
				animated_sprite.play("jump")
		else:
			if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("fall"):
				animated_sprite.play("fall")
			elif animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("jump"):
				animated_sprite.play("jump")
	else:
		if direction != 0.0:
			if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("run"):
				animated_sprite.play("run")
		else:
			if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("idle"):
				animated_sprite.play("idle")


func _apply_squash_and_stretch(target_scale: Vector2) -> void:
	if not animated_sprite:
		return
	animated_sprite.scale = target_scale
	var tween := create_tween()
	tween.tween_property(animated_sprite, "scale", default_scale, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
