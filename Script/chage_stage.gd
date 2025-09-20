extends Area2D

@export var Next_Scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# プレイヤーが到着したらゴール判定を出して、画面遷移
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		SignalManager.stage_clear.emit()
		get_tree().change_scene_to_packed.call_deferred(Next_Scene)
