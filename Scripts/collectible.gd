extends Area2D

@export var score_value: int = 10
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var collected: bool = false


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if body.is_in_group("player") or body.name == "Player":
		collected = true
		var gm = get_node_or_null("/root/GameManager")
		if gm:
			gm.add_score(score_value)

		# Feedback visual
		var tween := create_tween()
		tween.tween_property(self, "scale", Vector2(1.4, 1.4), 0.1)
		tween.tween_property(self, "modulate:a", 0.0, 0.1)
		tween.tween_callback(queue_free)
