package cl.agj.core.functional {
	
	public function map(fn:Function):Function {
		return function (list:Object):Object {
			return list.map(fn);
		};
	}
	
}