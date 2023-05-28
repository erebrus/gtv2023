extends PointLight2D

@onready var flame:Light2D= $flame


func _ready():
	Events.dimension_changed.connect(_on_dimension_changed)
	
func _on_dimension_changed(_dimension):
	if _dimension == Events.Dimension.MATERIAL:
		energy = 1
		texture_scale=2
		$flame.energy=3
	else:
		energy = 3
		texture_scale=4
		$flame.energy=3
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var period = Time.get_ticks_msec()/300.0
	flame.position = Vector2(0, sin(period)* 5)
	
