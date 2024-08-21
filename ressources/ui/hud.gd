extends CanvasLayer

@export var sys_text : String = "Simulation info 2"

func show_sys_message(text):
	$SysMessage.text = text
	$SysMessage.show()

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	show_sys_message(sys_text)
