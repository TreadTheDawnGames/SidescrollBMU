#meta-default: true
# File:
# Date:
# Author:

extends Destructable
class_name Dummy

@onready var shape: CollisionShape2D = $HurtBoxComponent2D/CollisionShape2D
@onready var repeat_attack_timer: Timer = $RepeatAttack
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	shape.disabled = true
	repeat_attack_timer.timeout.connect(timeout)
	pass

func timeout():
	var tween : Tween = create_tween()
	tween.tween_property(sprite_2d, "modulate", Color.RED, 0)
	tween.tween_property(shape, "disabled", false, 0)
	tween.tween_property(shape, "disabled", false, 0.2)
	tween.tween_property(shape, "disabled", true, 0)
	
	tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0)
	#repeat_attack_timer.wait_time = randf() * 5
	
	pass

func _process(delta: float) -> void:
	pass
