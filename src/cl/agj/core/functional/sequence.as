package cl.agj.core.functional {
	import cl.agj.core.utils.ListUtil;

	public function sequence(... fns):Function {
		return function sequenced(... args):* {
			var fnsCopy:Array = fns.slice();
			return ListUtil.reduce(fnsCopy, process, fnsCopy.shift().apply(this, args));
		};
		function process(r:*, fn:Function, ...rest):* {
			return fn(r);
		}
	}

}