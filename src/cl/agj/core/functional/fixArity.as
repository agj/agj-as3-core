package cl.agj.core.functional {
	
	public function fixArity(arity:uint, fn:Function):Function {
		if (arity === 0) return function arity0():* { return fn.call(this); };
		if (arity === 1) return function arity1(a:*):* { return fn.call(this, a); };
		if (arity === 2) return function arity2(a:*, b:*):* { return fn.call(this, a, b); };
		if (arity === 3) return function arity3(a:*, b:*, c:*):* { return fn.call(this, a, b, c); };
		if (arity === 4) return function arity4(a:*, b:*, c:*, d:*):* { return fn.call(this, a, b, c, d); };
		throw new RangeError("Arity " + arity + " is out of range 4.");
	};
	
}