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
			else if (currentStep == "attack enemy")
			{
				return "reinforcements arrive";
			}
			else if (currentStep == "reinforcements arrive")
			{
				return "carrier";
			}
			else if (currentStep == "carrier")
			{
				return "fighter1";
			}
			else if (currentStep == "fighter1")
			{
				return "fighter2";
			}
			else if (currentStep == "fighter2")
			{
				return "BB";
			}
			else if (currentStep == "BB")
			{
				return "sub";
			}
			else if (currentStep == "sub")
			{
				return "DD";
			}
			else if (currentStep == "DD")
			{
				return "begin";
			}
			
			return "error";
		}
		
	}

}