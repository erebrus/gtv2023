extends Camera2D


signal moved


func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		moved.emit()
	

