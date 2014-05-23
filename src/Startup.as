package 
{
	import flash.display.Sprite;
	import starling.core.Starling;

	/**
	 * ...
	 * @author dan
	 */
	[SWF(width="640", height="480", framerate="60", backgroundColor="#ffffff")]
	public class Startup extends Sprite 
	{
		private var _starling:Starling;
	

		public function Startup() 
		{
			_starling = new Starling(Game, stage);
			_starling.start();
		}

	}

}