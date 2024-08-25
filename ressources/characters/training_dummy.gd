extends StaticBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var hurtbox = $Hurtbox
@onready var hitboxes = $Hitbox
@onready var healthbar = $CanvasLayer/Healthbar

@export var player_nb : int = 2
@export var facing : String = "left"
@export var export_info = "nothing"
@export var max_hp = 1000
@export var hp = 500

signal hit

func update_animation_parameters():
	pass

func setup_collisions():
	if player_nb == 1:
		# collision layer
		hurtbox.set_collision_layer_value(2, true)  # set layer to player1
		hitboxes.set_collision_layer_value(4, true)  # set layer to player1
		# collision mask
		hurtbox.set_collision_mask_value(3, true)
	elif player_nb == 2:
		hurtbox.set_collision_layer_value(3, true)  
		hitboxes.set_collision_layer_value(5, true)
		# collision mask
		hurtbox.set_collision_mask_value(2, true)

func _ready() -> void:
	animation_tree.active = true
	setup_collisions()
	hp = max_hp
	healthbar.init_health(hp)
	
func _process(delta: float) -> void:
	if facing == "left":
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
	update_animation_parameters()
	export_info = healthbar.value
	animation_tree["parameters/conditions/idle"] = true



func _on_healthbar_health_zero() -> void:
	hp = 1000
