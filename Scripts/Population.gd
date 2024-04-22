extends Node
class_name Population

@export var Peasants: int = 0
@export var Commoners: int = 0
@export var Burghers: int = 0
@export var Nobles: int = 0
@export var Clerc: int = 0

func _init(amount: int, is_city: bool = true):
	setup_amount(amount, is_city)

func _to_string():
	return "<Pop(P%d,C%d,B%d,N%d,C%d)>" % [Peasants, Commoners, Burghers, Nobles, Clerc]

func setup_amount(amount: int, is_city: bool):
	empty()
	if amount == 0:
		return
	if is_city:
		Commoners = int(amount * 0.9)
		Burghers = int(amount * 0.07)
		Nobles = int(amount * 0.015)
		Clerc = int(amount * 0.015)
		Commoners -= total() - amount
	else:
		Peasants = int(amount * 0.99)
		Nobles = int(amount * 0.005)
		Clerc = int(amount * 0.005)
		Peasants -= total() - amount

func empty():
	Peasants = 0
	Commoners = 0
	Burghers = 0
	Nobles = 0
	Clerc = 0

func total():
	return Peasants + Commoners + Burghers + Nobles + Clerc
