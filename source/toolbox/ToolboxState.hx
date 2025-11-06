package toolbox;

import toolbox.util.NewModState;
import ui.Option;
import states.PlayState;
import states.OptionsMenu;

class ToolboxState extends OptionsMenu {
	override function create() {
		pages = [
			"Categories" => [
				#if MODDING_ALLOWED
				new GameStateOption("New Mod", () -> new NewModState()),
				#end
				new PageOption("Tools", "Tools",),
				new PageOption("Documentation", "Documentation")
			],
			"Tools" => [
				new PageOption("Back", "Categories"),
				new GameStateOption("Charter", () -> new ChartingState()),
				new CharacterCreatorOption("Character Creator", () -> new CharacterCreator("dad", "stage")),
				new GameStateOption("Stage Editor", () -> new StageMakingState("stage")),
				#if MODCHARTING_TOOLS
				new GameStateOption("Modchart Editor", () -> new modcharting.ModchartEditorState())
				#end
			],
			"Documentation" => [
				new PageOption("Back", "Categories"),
				new OpenUrlOption("Wiki", "Wiki", "https://github.com/Leather128/LeatherEngine/wiki"),
				new OpenUrlOption("HScript Api", "HScript Api", "https://github.com/Vortex2Oblivion/LeatherEngine/wiki/HScript-api-documentation-(WIP)"),
				new OpenUrlOption("Lua Api", "Lua Api", "https://github.com/Vortex2Oblivion/LeatherEngine-Extended-Support/wiki/Lua-api-documentation-(WIP)"),
				new OpenUrlOption("Classes List", "Classes List", "https://vortex2oblivion.github.io/LeatherEngine/"),
				new OpenUrlOption("Polymod Docs", "Polymod Docs", "https://polymod.io/docs/")
			]
		];
		if (PlayState.instance == null) {
			pages["Tools"][4] = null;
			pages["Tools"][1] = null;
		}

		super.create();
	}
}
