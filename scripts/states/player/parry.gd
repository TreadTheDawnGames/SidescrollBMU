extends PlayerState

func _enter():
	super._enter()
	player.animator.play("Parry")
	for body : Node2D in player.get_near_bodies():
		print("found ", body.name)
		if body is Destructable:
			var dummy = body as Destructable
			dummy.take_knockback((dummy.global_position - player.global_position).normalized() + (Vector2.UP), 200.0)
			print("parried ", body.name)
		
	await player.animator.animation_finished
	transition_to(player.state_attack_ground)
	
func _set_name() -> void:
	_state_name = "Parry"
