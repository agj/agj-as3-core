package cl.agj.core.functional {
	
	public function empty(obj:Object):Boolean {
		if (!obj) return true;
		for each (var item:* in obj) {
			return false;
		}
		return true;
	}
	
}