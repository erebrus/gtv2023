extends PointLight2D

@onready var flame:Light2D= $flame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var period = Time.get_ticks_msec()/400.0
	flame.position = Vector2(0, sin(period)* 4)
	
