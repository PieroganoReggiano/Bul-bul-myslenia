extends Control


@onready var korzen : Korzen = $".."
@onready var menu = $Menu

@onready var button_continue = $"Menu/Panel/ButtonContinue"
@onready var button_new_game = $"Menu/Panel/ButtonPlay"
@onready var nazwa = $"Menu/Panel/Nazwa"

func _ready() -> void:
	refresh()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("go_back") and not menu.visible:
		make_pause()


func refresh() -> void:
	var is_game : bool = korzen.is_game()
	button_continue.visible = is_game
	nazwa.visible = not is_game
	button_new_game.text = \
		"New game" if is_game else "Play"
	button_new_game.refresh()


func make_pause() -> void:
	korzen.go_to_menu()
	refresh()


func drop_game() -> void:
	korzen.drop_game()
	korzen.go_to_menu()


func new_game() -> void:
	korzen.reset_game()
	korzen.go_to_game()


func continue_game() -> void:
	korzen.play()
	korzen.go_to_game()


func quit() -> void:
	get_tree().quit()
