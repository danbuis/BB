package screens 
{
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author dan
	 */
	public class BaseScreen extends Sprite 
	{
		
		public function BaseScreen() 
		{
			super();
			
		}
		
		public function hideScreen():void
		{
			this.visible = false;
		}
		
		public function showScreen():void
		{
			this.visible = true;
		}
		
	}

}