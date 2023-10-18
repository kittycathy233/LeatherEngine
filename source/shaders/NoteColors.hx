package shaders;

class NoteColors {
	public static var noteColors:Map<String, Array<Int>> = new Map<String, Array<Int>>();
	public static var defaultColors:Array<Array<Array<Int>>> = [
		[[204,204,204]],
		[[194,75,153],[249,57,63]],
		[[194,75,153],[204,204,204],[249,57,63]],
		[[194,75,153],[0,255,255],[18,250,5],[249,57,63]],
		[[194,75,153],[0,255,255],[204,204,204],[18,250,5],[249,57,63]],
		[[194,75,153],[18,250,5],[249,57,63],[255,255,0],[0,255,255],[0,51,255]],
		[[194,75,153],[18,250,5],[249,57,63],[204,204,204],[255,255,0],[0,255,255],[0,51,255]],
		[[194,75,153],[0,255,255],[18,250,5],[249,57,63],[255,255,0],[139,74,255],[255,0,0],[0,51,255]],
		[[194,75,153],[0,255,255],[18,250,5],[249,57,63],[204,204,204],[255,255,0],[139,74,255],[255,0,0],[0,51,255]],
	];

	public static function setNoteColor(note:String, color:Array<Int>):Void {
		noteColors.set(note, color);
		Options.setData(noteColors, "noteColors", "noteColors");
	}

	public static function getNoteColor(note:String):Array<Int> {
		if (!noteColors.exists(note))
			setNoteColor(note, [255, 0, 0]);

		return noteColors.get(note);
	}

	public static function load():Void {
		if (Options.getData("noteColors", "noteColors") != null)
			noteColors = Options.getData("noteColors", "noteColors");
	}
}
