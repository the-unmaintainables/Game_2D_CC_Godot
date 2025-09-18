extends Node

const TITLE_SCENE = preload("res://ui/title.tscn")
const STAGE1_SCENE = preload("res://Scene/Main.tscn")

# タイトルへ移動
func load_title_scene():
	get_tree().change_scene_to_packed(TITLE_SCENE)

# stage1に移動
func load_stage1_scene():
	get_tree().change_scene_to_packed(STAGE1_SCENE)
