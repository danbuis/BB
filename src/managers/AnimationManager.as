package managers 
{
	import playArea.GridCell;
	import screens.GamePhase;
	import ships.Carrier;
	import ships.Fighter;
	import ships.ShipBase;
	import com.greensock.TweenLite;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class AnimationManager 
	{
		
		public function AnimationManager() 
		{
			
		}
		
		public static function moveShipAnimation(newX:int, newY:int, time:Number, ship:ShipBase, gamePhase:String):void
		{
			var moveTime:Number = time / 2.0;
			
			//move faster during initial.
			if (gamePhase == GamePhase.PLACEMENT_PHASE)
			{
				moveTime /= 2.0;
			}
			
			TweenLite.to(ship, moveTime, { x:newX, y:newY } );
		}
		
		public static function fogChange(newAlpha:Number, gridCell:GridCell):void
		{
			var currentAlpha:Number = gridCell.fog.alpha;
			var timeToChange:Number = (Math.abs(currentAlpha - newAlpha)) * 1.0;
			
			TweenLite.to(gridCell.fog, timeToChange, { alpha:newAlpha } );
		}
		
		public static function moveFuelPanel(newX:int, fuelPanel:Image, fuelAmount:Image):void
		{
			TweenLite.to(fuelPanel, 0.65, { x:newX } );
			if (fuelAmount != null)
			{
				TweenLite.to(fuelAmount, 0.65, { x:newX + 43 } );
			}
		}
		
		static public function moveFighterPanel(newX:Number, fighterPanel:Image, numberOfSquadrons:int, storedFighter1:Image, storedFighter2:Image, storedFighter3:Image):void 
		{
			TweenLite.to(fighterPanel, 0.65, { x:newX } );
			
			var verticalAlign:int = 54;
			
			if (numberOfSquadrons >= 1)
			{
				TweenLite.to(storedFighter1, 0.65, { x:newX + verticalAlign } );
			}
			if (numberOfSquadrons >= 2)
			{
				TweenLite.to(storedFighter2, 0.65, { x:newX + verticalAlign } );
			}
			if (numberOfSquadrons >= 3)
			{
				TweenLite.to(storedFighter3, 0.65, { x:newX + verticalAlign } );
			}
			
		}
		
		public static function getRotationFrame(ship:ShipBase, newX:int, newY:int):int
		{
			var deltaX:int = ship.x - newX;
			var deltaY:int = ship.y - newY;
			
			var headingInRad:Number = Math.atan2(deltaY, deltaX);
			var headingInDeg:Number = headingInRad * 180 / Math.PI;
			
			if (Math.abs(headingInDeg) <= 11.25)
			{
				return 13;
			}
			else if (Math.abs(headingInDeg) >= 168.75)
			{
				return 5;
			}
			else if (headingInDeg > 0)
			{
				if (headingInDeg <= 33.75)
				{
					return 14;
				}
				if (headingInDeg <= 56.25)
				{
					return 15;
				}
				if (headingInDeg <= 78.75)
				{
					return 16;
				}
				if (headingInDeg <= 101.25)
				{
					return 1;
				}
				if (headingInDeg <= 123.75)
				{
					return 2;
				}
				if (headingInDeg <= 146.25)
				{
					return 3;
				}
				if (headingInDeg <= 168.75)
				{
					return 4;
				}
			}
			else if (headingInDeg < 0)
			{
				if (headingInDeg >= -33.75)
				{
					return 12;
				}
				if (headingInDeg >= -56.25)
				{
					return 11;
				}
				if (headingInDeg >= -78.75)
				{
					return 10;
				}
				if (headingInDeg >= -101.25)
				{
					return 9;
				}
				if (headingInDeg >= -123.75)
				{
					return 8;
				}
				if (headingInDeg >= -146.25)
				{
					return 7;
				}
				if (headingInDeg >= -168.75)
				{
					return 6;
				}
			}
			return 1;
		}
		
		public static function landFighter(fighter:Fighter, newX:int):void
		{
			TweenLite.to(fighter, 3, { x:newX, y:fighter.y+15, alpha:0, scaleX:0.2, scaleY:0.2 } );
			fighter.dispose();
		}
		
		public static function launchFighter(fighter:Fighter, newX:int, newY:int):void
		{
			trace("fighter launch animation");
			TweenLite.to(fighter, 2, { x:newX, y:newY, alpha:1, scaleX:1, scaleY:1 });
		}
		
		
	}

}