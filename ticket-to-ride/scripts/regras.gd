extends Control

func _ready():
	# Garantir que a tela ocupa toda a área
	anchors_preset = Control.PRESET_FULL_RECT

	# === Criar o ScrollContainer com o texto de regras ===
	var scroll := ScrollContainer.new()
	scroll.anchor_left = 0.1
	scroll.anchor_right = 0.9
	scroll.anchor_top = 0.05
	scroll.anchor_bottom = 0.85
	scroll.offset_left = 0
	scroll.offset_top = 0
	scroll.offset_right = 0
	scroll.offset_bottom = 0
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(scroll)

	# Texto das regras
	var regras := RichTextLabel.new()
	regras.text = """
	Ticket to Ride – Regras do Jogo:

Objetivo:
Conquistar o maior número de pontos ao reivindicar rotas ferroviárias entre cidades, completar bilhetes de destino e construir a maior estrada contínua.

Como jogar:
- Cada jogador começa com 45 vagões e 3 cartas de destino (deve manter pelo menos 2).
- No seu turno, você pode fazer uma das seguintes ações:
  1. Comprar 2 cartas de trem (do monte ou das 5 visíveis).
  2. Reivindicar uma rota entre duas cidades (descartando cartas de trem da mesma cor).
  3. Comprar novos bilhetes de destino (escolher ao menos 1 de 3).

Reivindicando rotas:
- Cada rota requer um número específico de cartas de trem da mesma cor.
- Rotas cinzas podem ser completadas com qualquer cor, desde que todas as cartas sejam da mesma cor.

Curingas (locomotivas):
- Podem ser usadas como qualquer cor.
- Se você comprar uma locomotiva das cartas visíveis, essa é sua única compra naquele turno.

Pontuação:
- Cada rota reivindicada dá pontos conforme seu comprimento.
- Bilhetes de destino completados dão pontos extras.
- Bilhetes não completados subtraem pontos.
- Bônus de +10 pontos para a maior rota contínua.

Fim do jogo:
- Quando um jogador tiver 2 ou menos vagões, cada jogador joga mais uma vez.
- Após isso, contam-se os pontos.

Boa sorte e divirta-se!
"""
	regras.fit_content = true
	regras.autowrap_mode = TextServer.AUTOWRAP_WORD
	regras.size_flags_vertical = Control.SIZE_EXPAND_FILL
	regras.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(regras)

	# === Criar botão "Voltar" ===
	var botao_voltar := Button.new()
	botao_voltar.text = "Voltar"
	botao_voltar.custom_minimum_size = Vector2(200, 60)

	# Estilo visual
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color.DARK_RED

	var tema := Theme.new()
	tema.set_stylebox("normal", "Button", estilo)
	botao_voltar.theme = tema

	# Posição fixa no canto inferior esquerdo
	botao_voltar.anchor_left = 0.0
	botao_voltar.anchor_top = 1.0
	botao_voltar.anchor_right = 0.0
	botao_voltar.anchor_bottom = 1.0

	botao_voltar.offset_left = 20
	botao_voltar.offset_top = -80
	botao_voltar.offset_right = 220
	botao_voltar.offset_bottom = -20

	add_child(botao_voltar)

	# Conectar botão
	botao_voltar.pressed.connect(_on_botao_voltar_pressed)

func _on_botao_voltar_pressed():
	get_tree().change_scene_to_file("res://cenas/tela_inicial.tscn")
