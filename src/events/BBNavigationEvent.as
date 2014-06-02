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
		public static const MAIN_MENU:String = "main menu";
		public static const UP_BUTTON_REQUEST:String = "up button request";
		public static const TO_BUILD_FLEET:String = "build fleet";
		public static const TUTORIAL:String = "tutorial";
		
		public function BBNavigationEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
			
		}
		
	}

}