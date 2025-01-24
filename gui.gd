extends Control


@onready var korzen : Korzen = $".."
@onready var menu = $Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("go_back") and not menu.visible:
		make_pause()


func make_pause() -> void:
	korzen.go_to_menu()


func drop_game() -> void:
	korzen.drop_game()
	korzen.go_to_menu()


func play() -> void:
	korzen.play()
	korzen.go_to_game()
