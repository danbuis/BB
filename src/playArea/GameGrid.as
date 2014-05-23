package playArea 
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author dan
	 */
	public class GameGrid extends Sprite 
	{
		
	
		private var backgroundImage:Image;
		
		public function GameGrid() 
		{
			super();
			initialize();
			
		}
		
		private function initialize():void 
		{
			backgroundImage = new Image(Assets.getTexture("GameScreenBG"));
			this.addChild(backgroundImage);
		}
	}

}