class_name Snowman extends Enemy2D


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		contains_player = true


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		contains_player = false
