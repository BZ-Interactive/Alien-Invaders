extends Node

var current_score: int = 0
var highest_score: int = -1 # -1 means no highscore

var survived_bonus: int = 1000
var time_bonus: int = 10000

class ScoreData:
	var enemy:int = 0
	var survived: int = 0
	var time: int = 0
	var total: int = 0
	
	func _init(e:int, s: int, t: int, final: int):
		enemy = e
		survived = s
		time = t
		total = final

func reset_current_score():
	current_score = 0

func add_points(score: int):
	current_score += score

func calculate_level_score(survived: bool, time: float, level: Level) -> ScoreData:
	var enemy_result = current_score
	var survived_result: int = 0
	var time_result: int = 0
	
	if survived:
		survived_result = survived_bonus
	
	if survived and level.expected_time > 1 and time > 0:
		time_result = clampi(int(time / level.expected_time * time_bonus), 0, Vector3i.MAX.x)
	
	current_score += (survived_result + time_result)
	
	if current_score > highest_score:
		highest_score = current_score
		GameManager.main_menu.highest_score.set_highest_score(current_score)
	
	var result = ScoreData.new(enemy_result, survived_result, time_result, current_score)
	return result
