package cl.agj.core.functional {
	
	public function not(fn:Function):Function {
		return function (...args):Boolean {
			return !fn.apply(this, args);
		};
	}
	
}