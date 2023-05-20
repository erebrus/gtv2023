extends Node2D

var dimension = Globals.Dimension.SPECTRAL
@onready var spectral_canvas = $spectral_canvas

func _ready():
	Events.dimension_changed.emit(dimension)
	Events.dimension_changed.connect(_on_dimension_changed)


func _on_dimension_changed(_dimension):	
	if dimension == _dimension:
		return
	dimension = _dimension
	spectral_canvas.visible = dimension == Globals.Dimension.SPECTRAL
#	if dimension == Globals.Dimension.MATERIAL:
#		$AnimationPlayer.play("to_material")
#	else:
#		$AnimationPlayer.play("to_spectral")
#
