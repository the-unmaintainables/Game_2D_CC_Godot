extends GridContainer

@export var blue_bullet: PackedScene
@export var white_bullet: PackedScene
var nodes = [] # 追加したノードを管理する配列

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("update_chage", self._on_update_chage)
	add_node(1)
	add_node(1)
	add_node(1)
	add_node(1)
	add_node(1)

func _on_update_chage(count):
	remove_nodes()
	for i in range(min(count,5)):
		add_node(0)
	
	for i in range(min(count,5), 5):
		add_node(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## 画像の追加(0で青、1で白)
func add_node(type):
	var new_node
	if(type == 0):
		new_node = blue_bullet.instantiate()
	else:
		new_node = white_bullet.instantiate()
	
	#new_node.size = Vector2(200,200)
	# 子ノードに追加
	add_child(new_node)
	
	# 配列にノードを追加して管理
	nodes.append(new_node)

func remove_nodes():
	while nodes.size() > 0:
		var last_node = nodes.pop_back()
		last_node.queue_free()
