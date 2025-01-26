extends Control


@onready var korzen : Korzen = $".."
@onready var menu = $Menu
@onready var hud = $HUD
@onready var przegranko = $Przegranko

@onready var button_continue = $"Menu/Panel/ButtonContinue"
@onready var button_new_game = $"Menu/Panel/ButtonPlay"
@onready var nazwa = $"Menu/Panel/Nazwa"

var lose : bool = false

func _ready() -> void:
	hud.hide()
	refresh()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("go_back") and not menu.visible:
		make_pause()
	if korzen.is_game() and korzen.current_player and korzen.current_player.gun:
		refresh_colour_bar()


func refresh() -> void:
	if lose:
		menu.hide()
		hud.hide()
		przegranko.show()
		return
	var is_game : bool = korzen.is_game()
	przegranko.hide()
	button_continue.visible = is_game
	nazwa.visible = not is_game
	button_new_game.text = \
		"New\ngame" if is_game else "Play"
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


func refresh_colour_bar():
	var selection : int = korzen.current_player.gun.choice
	var bar = hud.get_node("ColourBar")
	var limit = bar.get_child_count()
	for i in limit:
		var num : BarNumber = bar.get_child(i)
		num.selected = i == selection
		num.ile = korzen.current_player.gun.get_ammo(i)


func quit() -> void:
	get_tree().quit()


func revive() -> void:
	korzen.revive()
	korzen.go_to_game()
