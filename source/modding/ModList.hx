package modding;

#if polymod
import polymod.Polymod;

class ModList {
	public static var modList:Map<String, Bool> = new Map<String, Bool>();

	public static var modMetadatas:Map<String, ModMetadata> = new Map();

	public static function setModEnabled(mod:String, enabled:Bool):Void {
		modList.set(mod, enabled);
		Options.setData(modList, "modlist", "modlist");
	}

	public static function getModEnabled(mod:String):Bool {
		if (!modList.exists(mod))
			setModEnabled(mod, modMetadatas.get(mod).metadata.get('auto_enable').toLowerCase() != 'false');

		return modList.get(mod);
	}

	public static function getActiveMods(modsToCheck:Array<String>):Array<String> {
		var activeMods:Array<String> = [];

		for (modName in modsToCheck) {
			if (getModEnabled(modName))
				activeMods.push(modName);
		}

		return activeMods;
	}

	public static function load():Void {
		if (Options.getData("modlist", "modlist") != null && Options.getData("modlist", "modlist") != [])
			modList = Options.getData("modlist", "modlist");
	}
}
#end
