extends Node2D


@export var action: String
@export var secondary_action: String
@export_multiline var hint: String

@export var fade_in_seconds:= 0.5
@export var fade_out_seconds:= 0.5

@onready var tip_panel = get_node("%Content")

@onready var action_icon = get_node("%ActionIcon")
@onready var hint_label = get_node("%Hint")

@onready var secondary = get_node("%SecondaryAction")
@onready var secondary_icon = secondary.find_child("Icon")

var tween: Tween

func _ready():
	if not action.is_empty():
		action_icon.action_name = action
		action_icon.show()
	
	hint_label.text = hint
	
	if action.is_empty() and hint.is_empty():
		action_icon.get_parent().hide()
	
	secondary.visible = not secondary_action.is_empty()
	secondary_icon.action_name = secondary_action
	
	tip_panel.modulate = Color.TRANSPARENT
	

func _on_trigger_area_body_entered(_body):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.tween_property(tip_panel, "modulate", Color.WHITE, fade_in_seconds)
	

func _on_trigger_area_body_exited(_body):
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.tween_property(tip_panel, "modulate", Color.TRANSPARENT, fade_out_seconds)
	
