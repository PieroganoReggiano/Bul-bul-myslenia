extends Control

signal pressed()


@export var shortcut : Shortcut
@export_multiline var text : String
@export var deiameter : float = 100.0


@export var colour : String = "p"


@onready var actual_button = $"A/ActualButton"
@onready var texture_rect = $"A/TextureRect"
@onready var label = $"A/Text"


var texture_normal : Texture2D
var texture_hover : Texture2D
var texture_pressed : Texture2D

var mouse_in : bool = false
var is_pressed : bool = false


func _ready() -> void:
	texture_normal = calc_texture(BaseButton.DrawMode.DRAW_NORMAL)
	texture_hover = calc_texture(BaseButton.DrawMode.DRAW_HOVER)
	texture_pressed = calc_texture(BaseButton.DrawMode.DRAW_PRESSED)
	refresh()


func _on_actual_button_pressed() -> void:
	pressed.emit()


func calc_texture(state : Button.DrawMode) -> Texture2D:
	var number = 1
	match state:
		BaseButton.DrawMode.DRAW_NORMAL: number = 1
		BaseButton.DrawMode.DRAW_HOVER: number = 2
		BaseButton.DrawMode.DRAW_PRESSED: number = 3
	var resource = "res://bobl_%s%s.png" % [ colour, number ]
	return load(resource)


func calc_button_state() -> BaseButton.DrawMode:
	if is_pressed:
		return BaseButton.DrawMode.DRAW_PRESSED
	if mouse_in:
		return BaseButton.DrawMode.DRAW_HOVER
	return BaseButton.DrawMode.DRAW_NORMAL


func refresh() -> void:
	actual_button.shortcut = shortcut
	actual_button.custom_minimum_size = Vector2.ONE * deiameter
	texture_rect.custom_minimum_size = Vector2.ONE * deiameter
	texture_rect.pivot_offset = Vector2.ONE * 0.5 * deiameter
	texture_rect.scale = Vector2.ONE * 2.0
	var button_desired_state = calc_button_state()
	texture_rect.texture = \
		texture_hover if button_desired_state == BaseButton.DrawMode.DRAW_HOVER else \
		texture_pressed if button_desired_state == BaseButton.DrawMode.DRAW_PRESSED else \
 		texture_normal
	# $TextureRect.
	label.text = text


func _on_actual_button_mouse_entered() -> void:
	mouse_in = true
	refresh()


func _on_actual_button_mouse_exited() -> void:
	mouse_in = false
	refresh()


func _on_actual_button_button_down() -> void:
	is_pressed = true
	refresh()


func _on_actual_button_button_up() -> void:
	is_pressed = false
	refresh()


func _on_actual_button_focus_entered() -> void:
	mouse_in = true
	refresh()


func _on_actual_button_focus_exited() -> void:
	mouse_in = false
	refresh()
