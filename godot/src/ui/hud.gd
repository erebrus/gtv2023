extends Control

@onready var soul_meter_bar := $MarginContainer/HBoxContainer/SoulMeter

func _ready():
	Events.soul_meter_changed.connect(_on_soul_meter_changed)
	
func _on_soul_meter_changed(percent:float):
	soul_meter_bar.value = percent
