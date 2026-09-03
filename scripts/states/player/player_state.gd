extends StateAbstract
class_name PlayerState

var player : Player
var vel_buffer : Vector2

func _enter() -> void:
	self.player = self.get_owner()
	vel_buffer = player.velocity

func handle_damaged(area : Area2D):
	player.velocity = (player.global_position - area.global_position).normalized() * 500
	transition_to(player.state_damaged)
