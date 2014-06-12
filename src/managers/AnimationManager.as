package managers 
{
	import playArea.GridCell;
	import screens.GamePhase;
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
		
		
	}

}