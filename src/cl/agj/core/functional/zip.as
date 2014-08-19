package cl.agj.core.functional {
	import cl.agj.core.utils.ListUtil;
	
	public function zip(... lists):Array {
		var len:int = ListUtil.reduce(lists.map(prop("length")), function (a:int, b:int):int {
			return a > b ? a : b;
		}, 0);
		var r:Array = [];
		
		var i:int = -1;
		while (++i < len) {
			r[i] = lists.map(prop(i));
		}
		
		return r;
	}
	
}