package events 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author dan
	 */
	public class BBAnimationEvents extends Event
	{
		public static const DONE_FIRING:String = "DONE FIRING";
		public static const DONE_MOVING:String = "DONE MOVING";
		public static const DONE_ACTIONING:String = "DONE ACTIONING";
		public static const DONE_TURN:String = "DONE TURN";
		
		
		public function BBAnimationEvents(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
		}
		
	}

}