extends StaticBody2D


@export var dimension:Events.Dimension=Events.Dimension.MATERIAL

func _ready():
	Events.dimension_changed.connect(_on_dimension_changed)


func _on_dimension_changed(_dimension):
	visible = _dimension == dimension
	$CollisionShape2D.disabled = _dimension != dimension

