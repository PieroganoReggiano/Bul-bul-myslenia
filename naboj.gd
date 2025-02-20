extends RigidBody3D

const SPEED = 40.0

# Wywoływana, gdy węzeł zostaje dodany do drzewa sceny
func _ready() -> void:
	# Usuń bombelka po 5 sekundach
	await get_tree().create_timer(5).timeout
	queue_free()
	
	# Podłącz obsługę kolizji za pomocą Callable
	connect("body_entered", Callable(self, "_on_body_entered"))

# Funkcja obsługująca kolizje
func _on_body_entered(body):
	print("DOSTAŁ! ale nawet go nie zarysowalismy ", body.name)
	queue_free()


func _process(delta: float):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
