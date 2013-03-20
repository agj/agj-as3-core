package cl.agj.core.datastructures {
	
	/**
	 * Very basic implementation of linked lists, in a single class.
	 * 
	 * @author agj
	 */
	public class LinkedListNode {
		
		public var head:Object;
		public var tail:LinkedListNode;
		
		public function LinkedListNode(head:Object = null, tail:LinkedListNode = null) {
			this.head = head;
			this.tail = tail;
		}
		
	}
}