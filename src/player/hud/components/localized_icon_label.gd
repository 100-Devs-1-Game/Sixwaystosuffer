class_name LocalizedIconLabel
extends RichTextLabel

@export var icon: Texture2D
@export var locale_key: String
@export var to_upper: bool

func _ready() -> void:
	var localized_text := tr(locale_key)
	
	if to_upper:
		localized_text = localized_text.to_upper()
	
	text = "[img=26]%s[/img] %s" % [icon.resource_path, localized_text]
