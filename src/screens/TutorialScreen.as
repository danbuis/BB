package screens 
{
	import managers.TutorialManager;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ...
	 */
	public class TutorialScreen extends GameScreen 
	{
		private var learning:Boolean = true;
		private var nextStep:String = "select torpedo boat";
		private var manager:TutorialManager = new TutorialManager();
		
		public function TutorialScreen() 
		{
			super();
			
		}
		
		private function clickHandler(event:TouchEvent):void
		{
			if (learning)
			{
				
			}
		}
	}

}