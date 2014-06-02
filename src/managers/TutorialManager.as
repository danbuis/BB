package managers 
{
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class TutorialManager 
	{
		
		public function TutorialManager() 
		{
			
		}
		
		public function getMessageScreen(screenNumber:int):Image
		{
			var returnImage:Image;
			
			returnImage = new Image(Assets.getAtlas().getTexture("message-" + screenNumber));
			
			return returnImage;
		}
		
		public function getNextStep(currentStep:String):String
		{
			if (currentStep == "select torpedo boat")
			{
				return "move torpedo boat";
			}
			else if (currentStep == "move torpedo boat")
			{
				return "attack enemy";
			}
			
			return "error";
		}
		
	}

}