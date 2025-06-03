extends Control

func _ready():
	# Fundo
	var fundo := TextureRect.new()
	fundo.texture = preload("res://assets/tela_inicial.jpg")
	fundo.stretch_mode = TextureRect.STRETCH_SCALE
	fundo.anchors_preset = Control.PRESET_FULL_RECT
	fundo.z_index = 0
	add_child(fundo)

	# Criar botões "Jogar" e "Regras"
	var botao_jogar := Button.new()
	botao_jogar.text = "Jogar"
	botao_jogar.custom_minimum_size = Vector2(200, 80)

	var botao_regras := Button.new()
	botao_regras.text = "Regras"
	botao_regras.custom_minimum_size = Vector2(200, 80)

	# Estilo visual comum
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color.DARK_GREEN

	var tema := Theme.new()
	tema.set_stylebox("normal", "Button", estilo)
	botao_jogar.theme = tema
	botao_regras.theme = tema

	# Container horizontal para alinhar os botões lado a lado
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_child(botao_jogar)
	hbox.add_child(botao_regras)

	# CenterContainer para centralizar o HBox
	var centralizador := CenterContainer.new()
	centralizador.anchors_preset = Control.PRESET_FULL_RECT
	centralizador.add_child(hbox)
	add_child(centralizador)

	# Conectar sinais
	botao_jogar.pressed.connect(_on_botao_jogar_pressed)
	botao_regras.pressed.connect(_on_botao_regras_pressed)

func _on_botao_jogar_pressed():
	get_tree().change_scene_to_file("res://cenas/main.tscn")

func _on_botao_regras_pressed():
	get_tree().change_scene_to_file("res://cenas/regras.tscn")
