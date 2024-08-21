extends CharacterBody2D

#@onready var _animation_player = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree

signal hitstun

const GROUND_SPEED = 300.0
const AIR_SPEED = 100.0
const JUMP_VELOCITY = -600.0
var facing = "right"  # direction to the opponent
const ATTACK_ANIMATIONS = ["punch_1",]

func _ready() -> void:
	animation_tree.active = true

func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/walk_forward"] = false
		animation_tree["parameters/conditions/walk_backwards"] = false
	elif (velocity.x > 0 and facing == "right") or (velocity.x < 0 and facing == "left"):
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/walk_forward"] = true
		animation_tree["parameters/conditions/walk_backwards"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/walk_forward"] = false
		animation_tree["parameters/conditions/walk_backwards"] = true
	
	if Input.is_action_just_pressed("punch_1") and is_on_floor():
		animation_tree["parameters/conditions/punch_1"] = true
	else:
		animation_tree["parameters/conditions/punch_1"] = false

func _process(delta: float) -> void:
	update_animation_parameters()

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction := Input.get_axis("move_left", "move_right")
		
	if is_on_floor():
		if facing == "left":
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		if Input.is_action_just_pressed("move_up"):
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		if direction:
			velocity.x = direction * GROUND_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, GROUND_SPEED)
	else:
		if direction:
			velocity.x = direction * AIR_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_SPEED)

	move_and_slide()
