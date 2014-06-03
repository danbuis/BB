package screens 
{
	import events.BBNavigationEvent;
	import ships.Battleship;
	import ships.Carrier;
	import ships.Destroyer;
	import ships.Submarine;
	import ships.TorpedoBoat;
	import starling.display.Button;
	import starling.events.Event;
	/**
	 * ...
	 * @author dan
	 */
	public class BuildFleetScreen extends BaseScreen 
	{
		
		
		private var components:Vector.<ShipSelectModule> = new Vector.<ShipSelectModule>();
		private var index:int = 0;
		private var startGame:Button;
		
		public function BuildFleetScreen() 
		{
			super();
			initialize();
			
			drawScreen();
			trace("build fleet screen initialized");
		}
		
		private function drawScreen():void 
		{
			//sets background
			
			var initialX:int = 19;
			var currentX:int = 19;
			var Xinterval:int = 128;
			
			var currentY:int = 30;
			var Yinterval:int = 210;
			
			addComponent(new ShipSelectModule(new Carrier(1)), currentX, currentY);
			currentX += Xinterval;
			addComponent(new ShipSelectModule(new Battleship(1)), currentX, currentY);
			currentX += Xinterval;
			addComponent(new ShipSelectModule(new Submarine(1)), currentX, currentY);
			currentX += Xinterval;
			addComponent(new ShipSelectModule(new Destroyer(1)), currentX, currentY);
			currentX += Xinterval;
			addComponent(new ShipSelectModule(new TorpedoBoat(1)), currentX, currentY);
			currentX = initialX;
			
			currentY += Yinterval;
			
			addComponent(new ShipSelectModule(new Carrier(2)), currentX, currentY);
			currentX += Xinterval;
			addComponent(new ShipSelectModule(new Battleship(2)), currentX, currentY);
			currentX += Xinterval;
			addComponent(new ShipSelectModule(new Submarine(2)), currentX, currentY);
			currentX += Xinterval;
			addComponent(new ShipSelectModule(new Destroyer(2)), currentX, currentY);
			currentX += Xinterval;
			addComponent(new ShipSelectModule(new TorpedoBoat(2)), currentX, currentY);
			currentX += Xinterval;
			
		}
		
		private function initialize():void 
		{
			this.addEventListener(BBNavigationEvent.UP_BUTTON_REQUEST, checkUpButtonRequest);
			startGame = new Button(Assets.getAtlas().getTexture("Buttons/turnComplete_Button"));
			startGame.x = (640 - startGame.width) / 2;
			startGame.y = 440;
			startGame.addEventListener(Event.TRIGGERED, onStartGame);
			this.addChild(startGame);
		}
		
		private function onStartGame(e:Event):void 
		{
			var countArray:Array = new Array();
			
			for (var i:int = 0; i <= 9; i++)
			{
				countArray.push(components[i].count);
			}
			
			dispatchEvent( new BBNavigationEvent(BBNavigationEvent.START_GAME, true, { ships:countArray } ));
		}
		
		private function checkUpButtonRequest(event:BBNavigationEvent):void 
		{
			var team:int = event.data.team;
			var source:ShipSelectModule = event.data.source;
			
			var total:int = 0;
			if (team == 1)
			{
				for (var i:int = 0; i <= 4; i++)
				{
					total += components[i].count;
				}
			}
			else
			{
				for (var j:int = 5; j <= 9; j++)
				{
					total += components[j].count;
				}
			}
			
			if (total < 12)
			{
				source.upButtonAllowed();
			}
		}
		

		
		private function addComponent(module:ShipSelectModule, x:int, y:int):void
		{
			module.x = x;
			module.y = y;
			this.addChild(module);
			
			components.push(module);
			index++;
		}
		
		public function resetCount():void
		{
			for (var i:int = 0; i <= components.length - 1; i++)
			{
				components[i].count = 0;
				components[i].numberText.text = "" + components[i].count;
			}
		}
		
	}

}