extends Control

signal pressed()


@export var shortcut : Shortcut
@export_multiline var text : String
@export var deiameter : float = 100.0
@export var font_size : float = 24.0


@export var colour : String = "p"

@onready var actual_button = $"A/ActualButton"
@onready var texture_rect = $"A/TextureRect"
@onready var label = $"A/Text"


var textures_normal : Array
var textures_hover : Array
var textures_pressed : Array

var frame_duration : float = 0.033

var current_textures : Array = []
var current_frame : int = 0
var current_time : float = 0.0

var mouse_in : bool = false
var is_pressed : bool = false


func _ready() -> void:
	textures_normal = calc_texture(BaseButton.DrawMode.DRAW_NORMAL)
	textures_hover = calc_texture(BaseButton.DrawMode.DRAW_HOVER)
	textures_pressed = calc_texture(BaseButton.DrawMode.DRAW_PRESSED)
	refresh()


func _on_actual_button_pressed() -> void:
	pressed.emit()


func calc_texture(state : Button.DrawMode) -> Array:
	var type = 1
	var total_frames = 1
	var resources : Array = []
	match state:
		BaseButton.DrawMode.DRAW_NORMAL:
			type = 'i'
			total_frames = 1
		BaseButton.DrawMode.DRAW_HOVER:
			type = 'h'
			total_frames = 1
		BaseButton.DrawMode.DRAW_PRESSED:
			type = 'p'
			total_frames = 4
	for idx in total_frames:
		var resource = "res://buttony/bobl_%s_%s%s.png" % [ colour, type, idx+1 ]
		resources.push_back(load(resource))
		
	return resources


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
	# texture_rect.texture
	current_textures = \
		textures_hover if button_desired_state == BaseButton.DrawMode.DRAW_HOVER else \
		textures_pressed if button_desired_state == BaseButton.DrawMode.DRAW_PRESSED else \
 		textures_normal
	# $TextureRect.
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)


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
	


func _process(delta: float) -> void:
	var total_frames = len(current_textures)
	current_time += delta
	if current_time > frame_duration:
		current_frame += 1
		current_time = 0
	if current_frame >= total_frames:
		current_frame = total_frames-1
	texture_rect.texture = current_textures[current_frame]
