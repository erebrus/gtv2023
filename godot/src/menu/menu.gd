extends Control

@onready var continue_button = get_node("%Continue")

func _ready():
	continue_button.visible = Globals.can_continue()
	

func _on_start_pressed():
	Globals.start()


func _on_continue_pressed():
	Globals.continue_game()


func _on_quit_pressed():
	get_tree().quit()
