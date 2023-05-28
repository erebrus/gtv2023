extends Node

enum Dimension{NONE, MATERIAL, SPECTRAL, BOTH}

signal dimension_changed(dimension)

signal soul_meter_changed(percent:float)

signal change_level_requested(level_path: String, entry_point: String)
signal checkpoint_entered(checkpoint_name: String)
