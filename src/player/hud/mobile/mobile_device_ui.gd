class_name MobileDeviceUI
extends MarginContainer

@onready var reload_mobile_ui: ReloadMobileUI = $"Reload Mobile UI"
@onready var shopping_mobile_ui: ShoppingMobileUI = $"Shopping Mobile UI"
@onready var shop_skip_container: ShoppingMobileUI = $"Shop Skip Container"


func initialize(player: Player) -> void:
	shopping_mobile_ui.state_machine = player.state_machine
	shopping_mobile_ui.initialize()
	
	reload_mobile_ui.player = player
	reload_mobile_ui.state_machine = player.state_machine
	reload_mobile_ui.revolver = player.revolver
	reload_mobile_ui.bullet_pickup = player.bullet_pickup
	reload_mobile_ui.initialize()

func show_skip_shop_button() -> void:
	shop_skip_container.show()

func hide_skip_shop_button() -> void:
	shop_skip_container.hide()
