extends Control

@export var INFO: Population:
	set(value):
		INFO = value
		set_values()

func set_values():
	$HBoxContainer/Value/Label.text = str(INFO.Peasants)
	$HBoxContainer/Value/Label2.text = str(INFO.Commoners)
	$HBoxContainer/Value/Label3.text = str(INFO.Burghers)
	$HBoxContainer/Value/Label4.text = str(INFO.Nobles)
	$HBoxContainer/Value/Label5.text = str(INFO.Clerc)
