extends Node

const TITLE_SCENE = preload("res://ui/title.tscn")
const STAGE1_SCENE = preload("res://Scene/Main.tscn")


func  load_title_scene():
	get_tree().change_scene_to_packed(TITLE_SCENE)

func load_stage1_scene():
	get_tree().change_scene_to_packed(STAGE1_SCENE)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
