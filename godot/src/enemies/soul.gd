extends Area2D

@export var energy:=20.0
@onready var sfx := $sfx_consume


func _on_body_entered(body):
	body.consume(self)
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color(1,1,1,0),.3)
	sfx.play()
	await tween.finished
	call_deferred("queue_free")
