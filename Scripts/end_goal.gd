extends Area2D

var triggered: bool = false


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body.is_in_group("player") or body.name == "Player":
		triggered = true
		var gm = get_node_or_null("/root/GameManager")
		if gm:
			gm.next_level()
