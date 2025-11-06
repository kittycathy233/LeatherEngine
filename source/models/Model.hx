package models;
import away3d.entities.Mesh;
import away3d.events.Asset3DEvent;
import away3d.library.assets.Asset3DType;
import away3d.lights.DirectionalLight;
import away3d.loaders.Loader3D;
import away3d.loaders.misc.AssetLoaderContext;
import away3d.loaders.parsers.OBJParser;
import away3d.materials.TextureMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.utils.Cast;
import flx3D.FlxView3D;
import openfl.utils.Assets;

class Model extends FlxView3D {
    var meshes:Array<Mesh> = [];
    var material:TextureMaterial;

    var light:DirectionalLight;
	var lightPicker:StaticLightPicker;

    private var _loader:Loader3D;
	private var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();

    public function new(x:Float = 0, y:Float = 0, width:Int = -1, height:Int = -1)
	{
		super(x, y, width, height);

		antialiasing = true;

		light = new DirectionalLight();
		light.ambient = 0.5;
		light.z -= 10;

		view.scene.addChild(light);

		lightPicker = new StaticLightPicker([light]);

		material = new TextureMaterial(Cast.bitmapTexture(Paths.texture('Flixel Color')));
		material.lightPicker = lightPicker;

		var _model = Assets.getBytes(Paths.obj("flixel"));
		assetLoaderContext.mapUrlToData("flixel.mtl", Assets.getBytes(Paths.mtl("flixel")));

		_loader = new Loader3D();
		_loader.loadData(_model, assetLoaderContext, null, new OBJParser());
		_loader.addEventListener(Asset3DEvent.ASSET_COMPLETE, onAssetDone);
		view.scene.addChild(_loader);
	}

	public function onAssetDone(event:Asset3DEvent)
	{
		if (event.asset.assetType == Asset3DType.MESH)
		{
			var mesh:Mesh = cast(event.asset, Mesh);
			mesh.rotationX = -90;
			mesh.scale(6);

			mesh.material = material;

			meshes.push(mesh);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (mesh in meshes)
		{
			if (mesh != null)
				mesh.rotationY += 10 * elapsed;
		}
	}

	override function destroy()
	{
		super.destroy();
	}
}