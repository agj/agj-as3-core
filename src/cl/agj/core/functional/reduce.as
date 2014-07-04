package cl.agj.core.functional {
	import cl.agj.core.utils.ListUtil;
	
	public function reduce(fn:Function):Function {
		return function (list:Object):Object {
			return ListUtil.reduce(list, fn);
		};
	}
	
}