package screens 
{
	import events.BBNavigationEvent;
	import ships.ShipBase;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
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
		public var numberText:TextField;
		
		public function ShipSelectModule(shipImagePassedIn:ShipBase) 
		{
			super();
			shipImage = shipImagePassedIn
			upButton = new Button(Assets.getAtlas().getTexture("GUI/up_arrow"));
			downButton = new Button(Assets.getAtlas().getTexture("GUI/down_arrow"));
			
			initializeComponent();
		}
		
		private function initializeComponent():void 
		{
			background = new Image(Assets.getAtlas().getTexture("GUI/shipSelect_bg"));
			background.scaleY = 1.5;
			background.scaleX = 1.5;
			this.addChild(background);
			
			upButton.x = (this.width / 2) - (upButton.width / 2);
			upButton.y = 10;
			this.addChild(upButton);
			upButton.addEventListener(Event.TRIGGERED, upButtonTriggered);
			
			downButton.x = upButton.x;
			downButton.y = this.height - downButton.height-10;
			this.addChild(downButton);
			downButton.addEventListener(Event.TRIGGERED, downButtonTriggered);
			
			Assets.getFont();
			numberText = new TextField(this.width, 40, ""+count , "ARMY RUST", 30, 0xffffff);
			numberText.x = 0;
			numberText.y = 110;
			this.addChild(numberText);
			
			shipImage.x = (this.width / 2) - 20;
			shipImage.y = 60;
			this.addChild(shipImage);
		}
		
		private function downButtonTriggered(e:Event):void 
		{
			trace("down button");
			if (count > 0)
			{
				count--;
				trace(count);
				numberText.text = "" + count;
			}
		}
		
		private function upButtonTriggered(e:Event):void 
		{
			trace("up button");
			this.dispatchEvent(new BBNavigationEvent(BBNavigationEvent.UP_BUTTON_REQUEST, true, {team:shipImage.team, source:this}));
		}
		
		public function upButtonAllowed():void
		{
			count++;
			trace(count);
			numberText.text = "" + count;
		}
		
	}

}