extends CharacterBody2D

@onready var hurtbox = $Hurtbox
@onready var hitboxes = $Hitboxes
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var healthbar = $CanvasLayer/Healthbar

const FALLSPEED = 1.5
const GROUND_SPEED = 300.0
const AIR_SPEED = 100.0
const JUMP_VELOCITY = -800.0

@export var attack_values = {"punch_1" : 300,}
@export var player_nb : int = 1
@export var facing : String = "right"  # direction to the opponent
@export var export_info = "nothing"
@export var max_hp = 1000
var jump_init_x_velocity = 0.0
var hp = 500

signal hit
signal damage_done

func setup_collisions():
	if player_nb == 1:
		# collision layer
		hurtbox.set_collision_layer_value(2, true)  # set layer to player1
		hitboxes.set_collision_layer_value(4, true)  # set layer to player1
		# collision mask
		hurtbox.set_collision_mask_value(5, true)
		hitboxes.set_collision_mask_value(3, true)
	elif player_nb == 2:
		# collision layer
		hurtbox.set_collision_layer_value(3, true)  
		hitboxes.set_collision_layer_value(5, true)
		# collision mask
		hurtbox.set_collision_mask_value(4, true)
		hitboxes.set_collision_mask_value(2, true)


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/walk_forward"] = false
		animation_tree["parameters/conditions/walk_backwards"] = false
	elif (velocity.x > 0 and facing == "right") or (velocity.x < 0 and facing == "left"):
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/walk_forward"] = true
		animation_tree["parameters/conditions/walk_backwards"] = false
	elif (velocity.x < 0 and facing == "right") or (velocity.x > 0 and facing == "left"):
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/walk_forward"] = false
		animation_tree["parameters/conditions/walk_backwards"] = true
	else:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/walk_forward"] = false
		animation_tree["parameters/conditions/walk_backwards"] = false
	
	if Input.is_action_just_pressed("punch_1") and is_on_floor():
		animation_tree["parameters/conditions/punch_1"] = true
	else:
		animation_tree["parameters/conditions/punch_1"] = false

func flip_char(_facing):
	if facing == "left":
		$Sprite2D.flip_h = true
		$Hitboxes/Punch1/CollisionShape2D.position.x = -72
	else:
		$Sprite2D.flip_h = false
		$Hitboxes/Punch1/CollisionShape2D.position.x = +72	


func _ready() -> void:
	animation_tree.active = true
	setup_collisions()
	hp = max_hp
	healthbar.init_health(max_hp)
	
	
func _process(delta: float) -> void:
	update_animation_parameters()
	#export_info = "hitbox layer 4: %s" % hitboxes.get_collision_layer_value(4)
	export_info = "position = %s" % $CollisionRect.position

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += FALLSPEED * get_gravity() * delta
		
	var direction := Input.get_axis("move_left", "move_right")
		
	if is_on_floor():
		flip_char(facing)
		if Input.is_action_just_pressed("move_up"):
			velocity.y = JUMP_VELOCITY
			jump_init_x_velocity = velocity.x
		# Get the input direction and handle the movement/deceleration.
		if direction:
			velocity.x = direction * GROUND_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, GROUND_SPEED)
	else:
		if direction:
			velocity.x = jump_init_x_velocity + direction * AIR_SPEED


	move_and_slide()
