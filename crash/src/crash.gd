extends Node


const quotes: Array[String] = [
	'Skill Issue', 
	'Shaggy was too strong',
	'You can now play as Luigi',
	'400 BPM',
	'if (!working) crash();',
	'Space Breaker 2%',
	'Should have used a good engine',
	'haha godot crash handler go brrr'
]

@onready var quote_label: Label = %quote_label
@onready var dump_label: RichTextLabel = %dump_label
var input_file: String


func _ready() -> void:
	# Initial size is minimum size
	get_window().min_size = get_window().size
	
	var quote: String = quotes.pick_random()
	quote_label.text = '%s\nUnfortunately, Leather Engine has crashed.' % quote
	
	for argument in OS.get_cmdline_args():
		if argument.begins_with('--crash_path='):
			input_file = ProjectSettings.globalize_path(argument.split('=')[1])
	
	if FileAccess.file_exists(input_file):
		dump_label.text = load_text()
	else:
		printerr(OS.get_cmdline_args())
		printerr('Couldn\'t find file at path %s!' % input_file)


func _on_close_pressed() -> void:
	get_tree().quit()


func load_text() -> String:
	var file := FileAccess.open(input_file, FileAccess.READ)
	return file.get_as_text()


func _on_view_crash_dump_pressed() -> void:
	OS.shell_show_in_file_manager(input_file)


func _on_restart_pressed() -> void:
	OS.execute('./Leather Engine.exe', [])
