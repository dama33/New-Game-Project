extends Node3D
signal button_activated

func _on_hurtbox_component_got_hit() -> void:
	button_activated.emit()
