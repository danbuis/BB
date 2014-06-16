package ships 
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	import managers.AnimationManager;
	import managers.utilities;
	import playArea.GridCell;
	import screens.GamePhase;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
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
		public var shipImage:Image;
		public var shipMask:Image;
		public var currentFrame:int;
		public var targetFrame:int;
		
		//stats of ship
		public var movementRange:int = 2;
		public var visibilityRange:int = 2;
		
		// TODO: use heading, will affect rendering
		
		public var startingHP:int;
		public var currentHP:int;
		private var sunk:Boolean = false;
		
		//vars for animation
		private var newX:int;
		private var newY:int;
		private var range:Number;
		public var animInterval:int = 250;
		public var shipRef:ShipBase;
		
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
			_location = new Point(0, 0);
			if (team == 1)
			{
				currentFrame = 1;
			}
			else
			{
				currentFrame = 9;
			}
			
			drawShip();
		}
		
		
		/* handles weather or not the ship is done with its turn. When it is done, it turns on its mask
		 * */
		public function updateStatus():void
		{
			if (shipType == ShipTypes.FIGHTER || shipType == ShipTypes.PATROL_BOAT)
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
			//then add sprite
			shipImage = new Image(Assets.getAtlas().getTexture("Ships/" + this.shipType+this.team + "/"+getFrameString(currentFrame)));
			this.addChild(shipImage);
			
			//then masking, which will be turned off until turn complete
			shipMask = new Image(Assets.getAtlas().getTexture("Ships/" + shipType+"_MASK/"+getFrameString(currentFrame)));
			shipMask.alpha = 0.7;
			this.addChild(shipMask);
			shipMask.visible = false;
			
		}
		
		public function getRotationDistance(targetFrame:int):int
		{
			var distanceClockwiseToFrame:int = targetFrame-currentFrame;
			if (distanceClockwiseToFrame < 0)
			{
				distanceClockwiseToFrame+= 16;
			}
			
			var distanceCounterwiseToFrame:int = currentFrame-targetFrame;
			if (distanceCounterwiseToFrame < 0)
			{
				distanceCounterwiseToFrame+= 16;
			}
			
			return Math.min(distanceClockwiseToFrame, distanceCounterwiseToFrame);
		}
		
		public function moveAndRotateShip(newX:int, newY:int, range:Number):int
		{
			trace("moveing and rotating");
			
			var targetFrame:int = AnimationManager.getRotationFrame(this, newX, newY);
			
			
			var distanceClockwiseToFrame:int = targetFrame-currentFrame;
			if (distanceClockwiseToFrame < 0)
			{
				distanceClockwiseToFrame+= 16;
			}
			
			var distanceCounterwiseToFrame:int = currentFrame-targetFrame;
			if (distanceCounterwiseToFrame < 0)
			{
				distanceCounterwiseToFrame+= 16;
			}
			
			if (Math.min(distanceClockwiseToFrame, distanceCounterwiseToFrame) != 0)
			{
				if(distanceClockwiseToFrame < distanceCounterwiseToFrame)
				{
					var CWRotationTimer:Timer = new Timer(animInterval, distanceClockwiseToFrame);
					CWRotationTimer.addEventListener(TimerEvent.TIMER, incrementShipRotation);
					CWRotationTimer.start();
				}
				else
				{
					var CCWRotationTimer:Timer = new Timer(animInterval, distanceCounterwiseToFrame);
					CCWRotationTimer.addEventListener(TimerEvent.TIMER, decrementShipRotation);
					CCWRotationTimer.start();
				}
			}
			
			this.newX = newX;
			this.newY = newY;
			this.range = range;
			
			var timeForMove:int = Math.ceil(animInterval * (Math.min(distanceClockwiseToFrame, distanceCounterwiseToFrame)) + (range * 1000));
			
			var movementTimer:Timer = new Timer(animInterval*(1+Math.min(distanceClockwiseToFrame, distanceCounterwiseToFrame)),1);
			movementTimer.addEventListener(TimerEvent.TIMER_COMPLETE, moveShip);
			movementTimer.start();
			
			return timeForMove;
			
		}
		
		/** returns time to rotate*/
		public function pivotShip(targetFrame:int):int
		{
			var distanceClockwiseToFrame:int = targetFrame-currentFrame;
			if (distanceClockwiseToFrame < 0)
			{
				distanceClockwiseToFrame+= 16;
			}
			
			var distanceCounterwiseToFrame:int = currentFrame-targetFrame;
			if (distanceCounterwiseToFrame < 0)
			{
				distanceCounterwiseToFrame+= 16;
			}
			
			if (Math.min(distanceClockwiseToFrame, distanceCounterwiseToFrame) != 0)
			{
				if(distanceClockwiseToFrame < distanceCounterwiseToFrame)
				{
					var CWRotationTimer:Timer = new Timer(animInterval, distanceClockwiseToFrame);
					CWRotationTimer.addEventListener(TimerEvent.TIMER, incrementShipRotation);
					CWRotationTimer.start();
				}
				else
				{
					var CCWRotationTimer:Timer = new Timer(animInterval, distanceCounterwiseToFrame);
					CCWRotationTimer.addEventListener(TimerEvent.TIMER, decrementShipRotation);
					CCWRotationTimer.start();
				}
			}
			
			//returns time to rotate
			return(Math.min(distanceClockwiseToFrame, distanceCounterwiseToFrame) * animInterval);
		}
		
		private function decrementShipRotation(e:TimerEvent):void 
		{
			currentFrame = ((currentFrame+14) % 16)+1;
			//trace("decrement function");
			this.removeChild(shipImage);
			shipImage = new Image(Assets.getAtlas().getTexture("Ships/" + this.shipType+this.team + "/" + getFrameString(currentFrame)));
			this.addChild(shipImage);
			
			this.removeChild(shipMask);
			shipMask = new Image(Assets.getAtlas().getTexture("Ships/" + shipType+"_MASK/" + getFrameString(currentFrame)));
			shipMask.alpha = 0.5
			shipMask.visible=false;
			this.addChild(shipMask);
		}
		
		private function incrementShipRotation(e:TimerEvent):void 
		{
			currentFrame = (currentFrame % 16) + 1;
			//trace("increment function");
			this.removeChild(shipImage);
			shipImage = new Image(Assets.getAtlas().getTexture("Ships/" + this.shipType+this.team + "/" + getFrameString(currentFrame)));
			this.addChild(shipImage);
			
			this.removeChild(shipMask);
			shipMask = new Image(Assets.getAtlas().getTexture("Ships/" + shipType+"_MASK/" + getFrameString(currentFrame)));
			shipMask.alpha = 0.5
			shipMask.visible=false;
			this.addChild(shipMask);
		}
		
		private function moveShip(e:TimerEvent):void 
		{
			AnimationManager.moveShipAnimation(newX, newY, range, this, GamePhase.PLAY_PHASE);
		}
		
		/*public function incrementShip():void 
		{
			currentFrame = (currentFrame % 16) + 1;
			trace("increment function");
			this.removeChild(shipImage);
			shipImage = new Image(Assets.getAtlas().getTexture("Ships/" + this.shipType+this.team + "/" + getFrameString(currentFrame)));
			this.addChild(shipImage);	
			
			/*trace("increment ship");
			this.removeChild(shipImage);
			shipImage = new Image(Assets.getAtlas().getTexture("Ships/" + this.shipType+this.team + "/" + getFrameString(currentFrame)));
			shipImage.x = this.x;
			shipImage.y = this.y;
			this.addChild(shipImage);
			
			shipMask = new Image(Assets.getAtlas().getTexture("Ships/" + shipType+"_MASK/" + getFrameString(currentFrame)));
			
		}*/
		
		private function getFrameString(frameNumber:int):String
		{
			var returnString:String = "" + frameNumber.toString();
			
			while (returnString.length != 4)
			{
				returnString = "0" + returnString;
			}
			
			return returnString;
		}
		
		public function getRangeToSquare(square:GridCell):Number
		{
			var squareCoords:Point = square.coordinates;
			var deltaX:int = _location.x - squareCoords.x;
			var deltaY:int = _location.y - squareCoords.y;
			
			return Math.sqrt((deltaX * deltaX) + (deltaY * deltaY));
		}
		
		public function getRangeToShip(ship:ShipBase):Number
		{
			var deltaX:int = _location.x - ship.location.x;
			var deltaY:int = _location.y - ship.location.y;
			
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
		
		
	}

}