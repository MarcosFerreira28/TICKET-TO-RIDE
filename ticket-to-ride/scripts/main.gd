extends Node

var current_player = 0
var total_players = 2
var player_scores = [0, 0]
var player_hands = [[], []]
var claimed_routes = {}
var ticket_selection_phase = true
var player_tickets = [[], []]
var colors = ["Vermelho", "Azul", "Verde", "Amarelo", "Preto", "Roxo", "Branco", "Coringa"]
var all_tickets = [
	{ "from": "Rio Centro", "to": "Barra da Tijuca", "points": 8 },
	{ "from": "Cidade de Deus", "to": "Niteroi", "points": 12 },
	{ "from": "Itacoatiara", "to": "Botafogo", "points": 20 },
	{ "from": "Buzios", "to": "Petrópolis", "points": 16 },
	{ "from": "Buzios", "to": "Rio Centro", "points": 24 },
	{ "from": "Niteroi", "to": "Rio Centro", "points": 18 },
	{ "from": "Buzios", "to": "Tijuca", "points": 22 },
	{ "from": "Itacoatiara", "to": "Ipanema", "points": 26 },
	{ "from": "Buzios", "to": "Angra dos Reis", "points": 28 },
	{ "from": "Angra dos Reis", "to": "Duque de Caxias", "points": 16 },
]

@onready var board = $Board
@onready var ui = $UI
@onready var action_panel = $ActionSelectionPanel
@onready var player_label = board.get_node("PlayerTurnLabel")
@onready var score_label = board.get_node("ScoreLabel")
@onready var hand_label = ui.get_node("HandLabel")
@onready var draw_button = action_panel.get_node("DrawCardsButton")
@onready var place_train_button = action_panel.get_node("PlaceTrainButton")  # Aqui adicionamos o PlaceTrainButton
@onready var ticket_panel = $TicketSelectionPanel
@onready var ticket_boxes = [
	ticket_panel.get_node("TicketOption1"),
	ticket_panel.get_node("TicketOption2"),
	ticket_panel.get_node("TicketOption3")
]
@onready var confirm_button = ticket_panel.get_node("ConfirmButton")
@onready var open_cards = [$UI/CardPanel/OpenCard1, $UI/CardPanel/OpenCard2, $UI/CardPanel/OpenCard3]
@onready var closed_deck_button = $UI/CardPanel/DeckClosedButton
@onready var buy_tickets_button = action_panel.get_node("BuyTicketsButton")
@onready var end_game_button = action_panel.get_node("EndGameButton")
@onready var cancel_action_button = action_panel.get_node("CancelActionButton")

var route_requirements = {
	"Route1": {"color": "red", "length": 3},
	"Route2": {"color": "blue", "length": 2},
	"Route3": {"color": "green", "length": 4},
}

var open_card_colors = []
var selecting_action = false

func _ready():
	draw_button.pressed.connect(show_draw_cards_mode)
	confirm_button.pressed.connect(on_ticket_selection_confirmed)
	closed_deck_button.pressed.connect(on_draw_closed_deck)
	place_train_button.pressed.connect(show_place_train_mode)  # Conectando o sinal do novo botão
	buy_tickets_button.pressed.connect(on_buy_tickets_pressed)
	end_game_button.pressed.connect(end_game)
	cancel_action_button.pressed.connect(cancel_action)
	action_panel.show()

	for i in range(open_cards.size()):
		var idx = i
		open_cards[i].pressed.connect(func(): on_draw_open_card(idx))

	for route in route_requirements.keys():
		var button = board.get_node(route.replace("Route", "RouteButton"))
		button.pressed.connect(func(): on_route_pressed(route))

	setup_open_cards()
	show_initial_ticket_selection()

func show_initial_ticket_selection():
	var tickets = get_random_tickets(3)
	for i in range(3):
		ticket_boxes[i].text = "%s - %s (%d pts)" % [tickets[i].from, tickets[i].to, tickets[i].points]
		ticket_boxes[i].set_meta("data", tickets[i])
		ticket_boxes[i].button_pressed = false
	ticket_panel.show()
	action_panel.hide()

func get_random_tickets(n):
	var pool = all_tickets.duplicate()
	pool.shuffle()
	return pool.slice(0, n)

func on_ticket_selection_confirmed():
	var selected = []
	for box in ticket_boxes:
		if box.button_pressed:
			selected.append(box.get_meta("data"))
	var min_required = 2 if ticket_selection_phase else 1
	if selected.size() < min_required:
		print("Selecione ao menos %d bilhetes." % min_required)
		return
	player_tickets[current_player] += selected
	ticket_panel.hide()
	if ticket_selection_phase:
		ticket_selection_phase = false
		start_turn()
	else:
		next_turn()
	action_panel.show()

func start_turn():
	print("Turno do jogador %d" % current_player)
	update_ui()
	action_panel.show()

func next_turn():
	current_player = (current_player + 1) % total_players
	start_turn()

func update_ui():
	player_label.text = "Vez do Jogador %d" % (current_player + 1)
	score_label.text = "P1: %d | P2: %d" % [player_scores[0], player_scores[1]]
	hand_label.text = "Cartas: " + str(player_hands[current_player])

func show_draw_cards_mode():
	selecting_action = true
	set_route_buttons_enabled(false)
	closed_deck_button.show()
	for card in open_cards:
		card.show()
	action_panel.hide()

func show_place_train_mode():
	selecting_action = true
	set_route_buttons_enabled(true)
	closed_deck_button.hide()
	for card in open_cards:
		card.hide()
	action_panel.hide()

func cancel_action():
	selecting_action = false
	set_route_buttons_enabled(false)
	closed_deck_button.hide()
	for card in open_cards:
		card.hide()
	action_panel.show()

func set_route_buttons_enabled(enabled):
	for route in route_requirements.keys():
		var button = board.get_node(route.replace("Route", "RouteButton"))
		button.disabled = not enabled

func on_draw_open_card(index):
	if not selecting_action:
		return
	var color = open_card_colors[index]
	player_hands[current_player].append(color)
	open_card_colors[index] = colors[randi() % colors.size()]
	open_cards[index].text = open_card_colors[index].capitalize()
	print("Jogador %d comprou carta %s do baralho aberto." % [current_player, color])
	update_ui()
	cancel_action()
	next_turn()

func on_draw_closed_deck():
	if not selecting_action:
		return
	for i in range(2):
		var color = colors[randi() % colors.size()]
		player_hands[current_player].append(color)
	print("Jogador %d comprou 2 cartas fechadas." % current_player)
	update_ui()
	cancel_action()
	next_turn()

func on_route_pressed(route_name: String):
	if not selecting_action:
		return
	if claimed_routes.has(route_name):
		print("Essa rota já foi comprada!")
		return

	var req = route_requirements[route_name]
	var color_needed = req["color"]
	var length = req["length"]

	var player_hand = player_hands[current_player]
	var count = player_hand.count(color_needed)

	if count >= length:
		for i in range(length):
			player_hand.erase(color_needed)
		claimed_routes[route_name] = current_player
		player_scores[current_player] += length * 2
		var button = board.get_node(route_name.replace("Route", "RouteButton"))
		button.disabled = true
		button.modulate = Color(0.5, 0.5, 0.5)
		print("Jogador %d completou %s e ganhou %d pontos!" % [current_player, route_name, length * 2])
	else:
		print("Cartas insuficientes para essa rota! (%d/%d)" % [count, length])
	update_ui()
	cancel_action()
	next_turn()

func setup_open_cards():
	open_card_colors = []
	for i in range(open_cards.size()):
		var color = colors[randi() % colors.size()]
		open_card_colors.append(color)
		open_cards[i].text = color.capitalize()

func offer_additional_tickets():
	var tickets = get_random_tickets(3)
	for i in range(3):
		ticket_boxes[i].text = "%s - %s (%d pts)" % [tickets[i].from, tickets[i].to, tickets[i].points]
		ticket_boxes[i].set_meta("data", tickets[i])
		ticket_boxes[i].button_pressed = false
	ticket_panel.show()
	action_panel.hide()

func on_buy_tickets_pressed():
	print("Jogador %d optou por comprar novos tickets." % current_player)
	ticket_selection_phase = false
	offer_additional_tickets()

func end_game():
	print("Fim do jogo! Calculando pontuação final...")
	var longest_path_player = current_player  # substitua por lógica real
	player_scores[longest_path_player] += 10
	print("Jogador %d ganhou bônus de 10 pontos por maior linha contínua!" % longest_path_player)

	for p in range(total_players):
		for ticket in player_tickets[p]:
			var completed = is_ticket_completed(ticket, p)
			if completed:
				player_scores[p] += ticket.points
				print("Jogador %d completou bilhete %s-%s (+%d)" % [p, ticket.from, ticket.to, ticket.points])
			else:
				player_scores[p] -= ticket.points
				print("Jogador %d NÃO completou bilhete %s-%s (-%d)" % [p, ticket.from, ticket.to, ticket.points])

	print("Pontuação Final:")
	for p in range(total_players):
		print("Jogador %d: %d pontos" % [p + 1, player_scores[p]])
	get_tree().quit()

func is_ticket_completed(ticket, player):
	return randi() % 2 == 0
