extends PointLight2D

@onready var flame:Light2D= $flame
@export var material_energy:float=1
@export var spectral_energy:float=3
@export var material_scale:float=2
@export var spectral_scale:float=4

func _ready():
	Events.dimension_changed.connect(_on_dimension_changed)
	
func _on_dimension_changed(_dimension):
	if _dimension == Events.Dimension.MATERIAL:
		energy = material_energy
		texture_scale=material_scale
		$flame.energy=3
	else:
		energy = spectral_energy
		texture_scale=spectral_scale
		$flame.energy=3
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var period = Time.get_ticks_msec()/300.0
	flame.position = Vector2(0, sin(period)* 5)
	
