package managers 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author dan
	 */
	public class utilities 
	{
		public static function pause(timeInSeconds:int, functionToCall:Function):void 
		{
			var timer:Timer = new Timer(timeInSeconds * 1000);
			timer.addEventListener(TimerEvent.TIMER, callFunction, false, 0, true);
			timer.start();
			function callFunction(event:TimerEvent):void 
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, callFunction);
				timer = null;
				functionToCall();               
				
			}
		}
		
		
	}

}