package modding.scripts.classes;

/**
 * Contains all the stuff for loading a script when a class is loaded
 * @author Vortex
 */
import flixel.FlxState;
import modding.scripts.languages.HScript;

using StringTools;

class ClassScript {
    /**
     * Stuff for ediditng classes
     * @param classPath The folder of the class. eg: "states".
     * @param className The name of the class. eg: "TitleState".
     */
    public function new(classPath:String, className:Dynamic) {
        var modList = modding.ModList.getActiveMods(modding.PolymodHandler.metadataArrays);
        var globalScript:HScript;

		if (modList.length > 0)
		{
			for (mod in modList)
			{
				if (sys.FileSystem.exists("mods/" + mod + "/classes/" + classPath + "/" + Std.string(className)))
				{
					var modGlobalScripts = sys.FileSystem.readDirectory("mods/" + mod + "/classes/" + classPath + "/" + Std.string(className));

					if (modGlobalScripts.length > 0)
					{
						for (file in modGlobalScripts)
						{
							if(file.endsWith('.hx'))
								{
									globalScript = new HScript("mods/" + mod + "/classes/" + classPath + "/" + Std.string(className) + "/" + file, true);
									globalScript.start();
								
									className.scripts.push(globalScript);
								}
						}
					}
				}
			}
		}
    }
}