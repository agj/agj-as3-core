package cl.agj.core.functional {
	
	public function bind(target:*, fn:Function, arguments:Array = null):Function {
		return function (...args):* {
			fn.apply(target, arguments ? arguments.concat(args) : args);
		};
	}
	
}