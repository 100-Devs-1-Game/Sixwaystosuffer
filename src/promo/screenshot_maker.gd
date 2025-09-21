class_name ScreenshotMaker
extends Node

@export var viewport: SubViewport
@export var screenshot_name: String

func _ready() -> void:
	get_viewport().transparent_bg = true
	get_window().size = viewport.size
	await RenderingServer.frame_post_draw
	take_transparent_screenshot()

func take_transparent_screenshot():
	viewport.transparent_bg = true
	var viewport_texture = viewport.get_texture()
	var image = viewport_texture.get_image()
	image.convert(Image.FORMAT_RGBA8) 
	image.save_png("res://promo/%s.png" % screenshot_name)
