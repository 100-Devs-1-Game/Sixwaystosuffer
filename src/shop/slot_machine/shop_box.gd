class_name ShopBox
extends Node3D

@export var open_offset: float = 0.42
@export var switch_duration: float = 0.25
@export var is_blocked: bool = false

@onready var product_position: Marker3D = $"Product Position"
@onready var clickable_area_3d: ClickableArea3D = $ClickableArea3D

@onready var open_audio_player: AudioStreamPlayer = $"Open AudioPlayer"
@onready var close_audio_player: AudioStreamPlayer = $"Close AudioPlayer"

@onready var digital_label_3d: Label3D = %"Digital Label3D"
@onready var clickable_sounds: ClickableSounds = $ClickableSounds
@onready var error_label_3d: ErrorLabel3D = %ErrorLabel3D

var product: ShopProduct

var base_offset: float
var is_opened: bool

var _tween: Tween

func _ready() -> void:
	base_offset = position.z

func show_not_enough() -> void:
	error_label_3d.alert()

func open() -> void:
	_stop_tween_if_needed()
	
	if is_blocked or is_opened:
		return
	
	if product is EmptyProduct:
		clickable_sounds.is_enabled = false
	else:
		clickable_sounds.is_enabled = true
	
	_tween = _create_box_tween(open_offset, switch_duration, Tween.EASE_OUT)
	is_opened = true
	open_audio_player.play()
	clickable_area_3d.enable()
	
	if product.cost != 0:
		digital_label_3d.text = "%s$" % product.cost

func close() -> void:
	_stop_tween_if_needed()
	
	if is_blocked or not is_opened:
		return
	
	_tween = _create_box_tween(base_offset, switch_duration, Tween.EASE_IN)
	is_opened = false
	close_audio_player.play()
	clickable_area_3d.disable()
	digital_label_3d.text = ""

func _create_box_tween(target_position: float, duration: float, easing: Tween.EaseType) -> Tween:
	var tween := create_tween()
	tween.tween_property(self, "position:z", target_position, duration).set_trans(Tween.TRANS_BACK).set_ease(easing)
	return tween

func _stop_tween_if_needed() -> void:
	if _tween != null and _tween.is_running():
		_tween.kill()
		_tween = null
