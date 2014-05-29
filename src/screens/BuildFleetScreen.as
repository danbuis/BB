package screens 
{
	import events.BBNavigationEvent;
	import ships.Battleship;
	import ships.Carrier;
	import ships.Destroyer;
	import ships.Submarine;
	import ships.TorpedoBoat;
	/**
	 * ...
	 * @author dan
	 */
	public class BuildFleetScreen extends BaseScreen 
	{
		
		
		private var components:Vector.<ShipSelectModule> = new Vector.<ShipSelectModule>();
		private var index:int = 0;
		
		
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
			
			var initialX:int = 36;
			var currentX:int = 36;
			var Xinterval:int = 96;
			
			var currentY:int = 30;
			var Yinterval:int = 180;
			
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
			
			if (total > 20)
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
		
	}

}