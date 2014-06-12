package 
//sitelock code from https://www.fgl.com/view_thread.php?thread_id=45569&offset=0#post320363
{
	import flash.display.DisplayObject;
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
			startWithSitelock();
		}

	
	
	private function startWithSitelock():void
	{
		//if (onUrl(["fgl.com", "flashgamelicense.com"], root))
		if(true)
		{
			_starling = new Starling(Game, stage);
			_starling.start();
		}
	}
	
	//blind copy from link above
	public static function onUrl(urls:Array, root:DisplayObject):Boolean
        {
            var url:String = root.root.loaderInfo.url;
            url = url.substr(url.indexOf("://") + 3);
            var allow:Boolean = false;
            for each(var uri:String in urls)
            {
                var index:int = url.indexOf(uri, 0);
                if (index == 0)
                {
                    allow = true;
                    break;
                }
                if (index > 0)
                {
                    if (url.charAt(index - 1) == ".")
                    {
                        allow = true;
                        break;
                    }
                }
            }
            return allow;
        }
	}
}