class_name BarNumber
extends Control

@export var colour : Color = Color.ORANGE
@export var number : String = "q"
@export var ile : int = 10
@export var selected : bool = false


@onready var panel = self
@onready var label = $Name
@onready var ile_label = $Number

func _ready() -> void:
	refresh()


func _process(_delta: float) -> void:
	refresh()

func refresh() -> void:
	label.text = number
	ile_label.text = "%s" % ile
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = colour
	if selected:
		stylebox.border_color = Color.GHOST_WHITE
		stylebox.set_border_width_all(7)
		label.add_theme_color_override("font_color", Color.GHOST_WHITE)
		ile_label.add_theme_color_override("font_color", Color.GHOST_WHITE)
	else:
		label.add_theme_color_override("font_color", Color.BLACK)
		ile_label.add_theme_color_override("font_color", Color.BLACK)
	panel.add_theme_stylebox_override("panel", stylebox)
