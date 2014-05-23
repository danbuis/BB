package events 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author dan
	 */
	public class BBNavigationEvent extends Event 
	{
		
		public static const START_GAME:String = "new game";
		
		public function BBNavigationEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
			
		}
		
	}

}