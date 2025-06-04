extends Node

func _ready():
	# Conecta os sinais de ambos os botões ao método de carregamento
	$ButtonFriends.pressed.connect(_on_button_pressed)
	$ButtonBot.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var main_scene = preload("res://cenas/main.tscn")
	get_tree().change_scene_to_packed(main_scene)
