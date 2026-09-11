extends PlayerState

var cached_attack_command : bool = false

func _enter():
	super._enter()
	player.animator.play("Parry")
	var nearest_dummy : Dummy = null
	var dist_to_nearest : float = INF
	for body : Node2D in player.get_near_bodies():
		print("found ", body.name)
		if body is Destructable:
			if body is Dummy:
				if abs(body.global_position.x - player.global_position.x) < dist_to_nearest:
					dist_to_nearest = abs(body.global_position.x - player.global_position.x)
					nearest_dummy = body
				print("parried ", body.name)
			var dummy = body as Destructable
			dummy.take_knockback((dummy.global_position - player.global_position).normalized() + (Vector2.UP), 100.0)
	
	if nearest_dummy:
		player.set_facing(sign(nearest_dummy.global_position.x - player.global_position.x))
		
	await player.animator.animation_finished
	#if cached_attack_command:
	transition_to(player.state_attack_ground)
	#else:
		#transition_to(player.state_idle)

func _exit():
	cached_attack_command = false
	
func _set_name() -> void:
	_state_name = "Parry"
#
#func _physics_process(delta : float) -> void:
	#if Input.is_action_just_pressed("Attack"):
		#cached_attack_command = true
		#
