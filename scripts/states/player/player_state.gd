extends StateAbstract
class_name PlayerState

var player : Player

func _enter() -> void:
	self.player = self.get_owner()

func handle_damaged(area : Area2D):
	player.velocity = (player.global_position - area.global_position).normalized()
	transition_to(player.state_damaged)
