extends Node

var cena_main := preload("res://cenas/main.tscn")
var cena_regras := preload("res://cenas/regras.tscn")
var cena_opcoes := preload("res://cenas/opcoes_jogo.tscn")

func _ready():
	var botao_jogar := $VBoxContainer/ButtonJogar
	var botao_regras := $VBoxContainer/ButtonRegras

	botao_jogar.text = "Jogar"
	botao_regras.text = "Regras"

	botao_jogar.pressed.connect(_on_botao_jogar_pressed)
	botao_regras.pressed.connect(_on_botao_regras_pressed)

func _on_botao_jogar_pressed() -> void:
	get_tree().change_scene_to_packed(cena_opcoes)

func _on_botao_regras_pressed() -> void:
	get_tree().change_scene_to_packed(cena_regras)
