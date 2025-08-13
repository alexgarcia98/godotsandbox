extends MarginContainer

@export var menu_screen: VBoxContainer
@export var open_menu_screen: VBoxContainer
@export var help_menu_screen: MarginContainer
@export var setting_menu_screen: MarginContainer

func toggle_visibility(object):
	object.visible = !object.visible

func _on_toggle_menu_button_pressed():
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)


func _on_toggle_help_menu_button_pressed():
	toggle_visibility(help_menu_screen)
	toggle_visibility(menu_screen)


func _on_toggle_setting_menu_button_pressed():
	toggle_visibility(setting_menu_screen)
	toggle_visibility(menu_screen)
