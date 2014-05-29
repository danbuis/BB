package screens 
{
	import events.BBNavigationEvent;
	import ships.ShipBase;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author dan
	 */
	public class ShipSelectModule extends Sprite 
	{
		
		private var shipImage:ShipBase;
		public var count:int = 0;
		private var upButton:Button;
		private var downButton:Button;
		private var background:Image;
		
		public function ShipSelectModule(shipImagePassedIn:ShipBase) 
		{
			super();
			shipImage = shipImagePassedIn
			upButton = new Button(Assets.getAtlas().getTexture("GUI/up_arrow"));
			downButton = new Button(Assets.getAtlas().getTexture("GUI/down_arrow"));
			
			initializeComponent();
		}
		// TODO resize
		private function initializeComponent():void 
		{
			background = new Image(Assets.getAtlas().getTexture("GUI/shipSelect_bg"));
			this.addChild(background);
			
			upButton.x = (this.width / 2) - (upButton.width / 2);
			upButton.y = 0;
			this.addChild(upButton);
			upButton.addEventListener(Event.TRIGGERED, upButtonTriggered);
			
			downButton.x = upButton.x;
			downButton.y = this.height - downButton.height;
			this.addChild(downButton);
			downButton.addEventListener(Event.TRIGGERED, downButtonTriggered);
			
			//TODO #text and related updates
			
			shipImage.x = (this.width / 2) - 20;
			shipImage.y = (this.height / 2) - 20;
			this.addChild(shipImage);
		}
		
		private function downButtonTriggered(e:Event):void 
		{
			if (count > 0)
			{
				count--;
			}
		}
		
		private function upButtonTriggered(e:Event):void 
		{
			this.dispatchEvent(new BBNavigationEvent(BBNavigationEvent.UP_BUTTON_REQUEST, true, {team:shipImage.team, source:this}));
		}
		
		public function upButtonAllowed():void
		{
			count++;
		}
		
	}

}