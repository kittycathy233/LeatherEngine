extends Node2D

var quotes:Array[String] = [
	"Skill Issue", 
	"Shaggy was too strong",
	"You can now play as Luigi",
	"400 BPM",
	"if (!working) crash();",
	"Space Breaker 2%",
	"Should have used a good engine",
	"haha godot crash handler go brrr"
]

func _ready():
	$"Crash Dump".text = load_text()
	$"Crash Quote".text = "[center]%s[/center]" % (quotes[randi() % quotes.size()] + "\nUnfortunately, Leather Engine has crashed.")

func _on_close_pressed():
	get_tree().quit()

func load_text():
	var file = FileAccess.open("res://" + OS.get_cmdline_args()[0], FileAccess.READ)
	var content = file.get_as_text()
	return content

func _on_view_crash_dump_pressed():
	OS.execute("res://" + OS.get_cmdline_args()[0], [])


func _on_restart_pressed():
	OS.execute('res://"Leather Engine.exe"', [])
