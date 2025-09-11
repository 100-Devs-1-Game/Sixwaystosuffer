class_name ClickedSoundPlayer
extends AudioStreamPlayer

@export var clickable_area3d: ClickableArea3D

func _ready() -> void:
	clickable_area3d.clicked.connect(_on_clicked)

func _on_clicked() -> void:
	play()
