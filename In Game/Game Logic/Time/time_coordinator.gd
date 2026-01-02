extends Node
class_name TimeCoordinator

signal tick_passed(delta, speed)
signal new_date_calculated(date_string : String)

@export var ticks_per_day : int = 8

var current_date_string : String

var current_speed : int = 0
var speed_settings : Dictionary = { #Dict of speed settings, value is days per second
	0 : 0,
	1 : 1,
	2 : 4,
	3 : 70
}

enum MONTHS {Jan = 1, Feb, Mar, Apr, May, Jun, Jul, Aug,Sep, Oct, Nov, Dec}
var days_in_months : Dictionary = {
	MONTHS.Jan : 31,
	MONTHS.Feb : 28,
	MONTHS.Mar : 31,
	MONTHS.Apr : 30,
	MONTHS.May : 31,
	MONTHS.Jun : 30,
	MONTHS.Jul : 31,
	MONTHS.Aug : 31,
	MONTHS.Sep : 30,
	MONTHS.Oct : 31,
	MONTHS.Nov : 30,
	MONTHS.Dec : 31
}

@export var start_year : int = 2026
@export var start_month : MONTHS = MONTHS.Jan

var cur_year : int = start_year
var cur_month : MONTHS = start_month
var cur_day : int = 1

var elapsed_years : int = 0
var elapsed_months : int = 0
var elapsed_days : int = 0

var elapsed_real_seconds : float
var elapsed_ticks : int

func _ready():
	update_text()
	SETTINGS.settings_updated.connect(update_text)

func _process(delta):
	if current_speed == 0:
		return
	elapsed_real_seconds += delta
	var tick_time : float = 1.0/(speed_settings.get(current_speed,1)*ticks_per_day)
	var safety_check : int = 1
	while elapsed_real_seconds > tick_time:
		elapsed_ticks += 1
		tick_passed.emit()
		elapsed_real_seconds -= tick_time
		assert(safety_check < 10000, "Tick calculation far exceeded expected value. Did you make an infinite loop?")
		safety_check += 1
	while elapsed_ticks >= ticks_per_day:
		tick_up_day()
		elapsed_ticks -= ticks_per_day
		assert(safety_check < 10000, "Tick calculation far exceeded expected value. Did you make an infinite loop?")
		safety_check += 1
	update_text()

#region Calculate date
func tick_up_day():
	if cur_day == get_days_in_month(cur_month):
		tick_up_month()
		cur_day = 1
	else:
		cur_day += 1

func tick_up_month():
	if cur_month == MONTHS.Dec:
		tick_up_year()
		cur_month = MONTHS.Jan
	else:
		cur_month += 1

func tick_up_year():
	cur_year += 1

func get_days_in_month(month : MONTHS) -> int:
	if cur_month == MONTHS.Feb and ((cur_year % 4 == 0 and cur_year % 100 != 0) or cur_year % 400 == 0):
		return 29
	return days_in_months[cur_month]
#endregion Calculate Date

func update_text():
	var day_string : String = str(cur_day)
	var month_string : String = str(cur_month)
	var year_string : String = str(cur_year)
	if len(day_string) == 1:
		day_string = "0" + day_string
	if len(month_string) == 1:
		month_string = "0" + month_string
	match SETTINGS.settings_data["region"]["date_format"]:
		SETTINGS.DATE_FORMATS.US:
			current_date_string = month_string+"/"+day_string+"/"+year_string
		SETTINGS.DATE_FORMATS.EU:
			current_date_string = day_string+"/"+month_string+"/"+year_string
		SETTINGS.DATE_FORMATS.IS:
			current_date_string = year_string+"/"+month_string+"/"+day_string
	emit_signal("new_date_calculated", current_date_string)
