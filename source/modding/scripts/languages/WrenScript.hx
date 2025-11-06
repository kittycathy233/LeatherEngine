package modding.scripts.languages;

#if WREN_ALLOWED
import cpp.ConstCharStar;
import cpp.Function;
import cpp.RawPointer;
import openfl.utils.Assets;
import hxwren.Types;
import hxwren.Wren;

class WrenScript extends Script {
    override public function new(path:String){
        super(path);
        trace('Wren ${Wren.GetVersionNumber()}');
        
        var config:WrenConfiguration = WrenConfiguration.alloc();

		Wren.InitConfiguration(RawPointer.addressOf(config));

		config.writeFn = Function.fromStaticFunction(writeFn);
		config.errorFn = Function.fromStaticFunction(errorFn);

		var vm:RawPointer<WrenVM> = Wren.NewVM(RawPointer.addressOf(config));

		switch (Wren.Interpret(vm, "main", Assets.getText(path)))
		{
			case WREN_RESULT_COMPILE_ERROR:
				Sys.println('Compile Error!');
			case WREN_RESULT_RUNTIME_ERROR:
				Sys.println('Runtime Error!');
			case WREN_RESULT_SUCCESS:
				Sys.println('Success!');
		}

        WrenForeignMethodFn(config.bindForeignMethodFn(vm, "main", "LeatherEngine", true,  "add(_,_)"));

		Wren.FreeVM(vm);
		vm = null;
    }
    private static function writeFn(vm:RawPointer<WrenVM>, text:ConstCharStar):Void
        {
            if (cast(text, String) != "\n") // Wtf Wren?
                Sys.println(cast(text, String));
        }
    
    private static function errorFn(vm:RawPointer<WrenVM>, errorType:WrenErrorType, module:ConstCharStar, line:Int, msg:ConstCharStar):Void{
        switch (errorType){
            case WREN_ERROR_COMPILE:
                trace('[' + cast(module, String) + ' line ' + line + '] ' + cast(msg, String), ERROR);
            case WREN_ERROR_STACK_TRACE:
                trace('[' + cast(module, String) + ' line ' + line + '] in ' + cast(msg, String));
            case WREN_ERROR_RUNTIME:
                trace('[Runtime Error] ' + cast(msg, String), ERROR);
        }
    }
}
#end