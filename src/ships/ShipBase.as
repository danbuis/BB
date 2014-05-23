package ships 
{
	import flash.geom.Point;
	import playArea.GridCell;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author dan
	 */
	public class ShipBase extends Sprite 
	{
		// what kind of ship, set in the individual constructors	
		public var shipType:String;
		
		//current location on the game grid
		//set manually by game field upon construction
		private var _location:Point;
		
		//team, affects render process
		public var team:int;
		
		//handles turn process
		public var moved:Boolean;
		public var fired:Boolean;
		public var performedAction:Boolean;
		public var turnCompleted:Boolean;
		
		//variables to render ship
		private var teamImage:Image;
		private var shipImage:Image;
		private var shipMask:Image;
		
		//stats of ship
		public var movementRange:int=2;
		
		// TODO: use heading, will affect rendering
		
		public var startingHP:int;
		public var currentHP:int;
		private var sunk:Boolean = false;
		
		public function ShipBase() 
		{
			super();
			initialize();
		}
		
		private function initialize():void 
		{
			moved = false;
			performedAction = false;
			turnCompleted = false;
			_location = new Point(0, 0); // TODO: set initial location via constructor
			
			drawShip();
		}
		
		
		/* handles weather or not the ship is done with its turn. When it is done, it turns on its mask
		 * */
		public function updateStatus():void
		{
			if (shipType == ShipTypes.FIGHTER || shipType == ShipTypes.TORPEDO_BOAT)
			{
				if (moved && fired)
				{
					turnCompleted = true;
					shipMask.visible = true;
				}
			}
			else
			{
				if (moved && fired && performedAction)
				{
					turnCompleted = true;
					shipMask.visible = true;
				}
			}
		}
		
		public function resetShip():void
		{
			moved = false;
			performedAction = false;
			fired = false;
			turnCompleted = false;
			
			shipMask.visible = false;
		}
		
		public function get location():Point 
		{
			return _location;
		}
		
		public function set location(value:Point):void 
		{
			_location = value;
		}
		
		public function drawShip():void
		
		{
			//first draw team color shape
			teamImage = new Image(Assets.getAtlas().getTexture(shipType+"_" + team));
			this.addChild(teamImage);
			//then add sprite
			shipImage = new Image(Assets.getAtlas().getTexture(""+shipType));
			this.addChild(shipImage);
			//then masking, which will be turned off until turn complete
			shipMask = new Image(Assets.getAtlas().getTexture("" + shipType+"_MASK"));
			this.addChild(shipMask);
			shipMask.visible = false;
			
		}
		
		public function getRangeToSquare(square:GridCell):Number
		{
			var squareCoords:Point = square.coordinates;
			var deltaX:int = _location.x - squareCoords.x;
			var deltaY:int = _location.y - squareCoords.y;
			
			return Math.sqrt((deltaX * deltaX) + (deltaY * deltaY));
		}
		
		public function hit():void
		{
			currentHP--;
			isSunkAfterHit();
		}
		
		private function isSunkAfterHit():void 
		{
			if (currentHP == 0)
			{
				sunk = true;
			}
		}
		
		public function checkSunk():Boolean
		{
		return sunk;
		}
		
	}

}