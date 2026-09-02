extends RigidBody2D
class_name Destructable

@onready var health: HealthComponent = %HealthComponent
@onready var hitbox: HitBoxComponent2D = %Hitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.Hit.connect(_on_hitbox_hit)
	health.Died.connect(queue_free)
	pass # Replace with function body.

func _on_hitbox_hit(area : Area2D):
	if area.owner == owner:
		return
	print("hit")
	apply_central_impulse(((global_position - area.global_position).normalized() + (Vector2.UP)) * 200)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
