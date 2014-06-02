package managers 
{
	import playArea.GridCell;
	import screens.GamePhase;
	import ships.ShipBase;
	import com.greensock.TweenLite;
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
				moveTime / 2.0;
			}
			TweenLite.to(ship, moveTime, { x:newX, y:newY } );
		}
		
		public static function fogChange(newAlpha:Number, gridCell:GridCell):void
		{
			var currentAlpha:Number = gridCell.fog.alpha;
			var timeToChange:Number = (Math.abs(currentAlpha - newAlpha)) * 1.0;
			
			TweenLite.to(gridCell.fog, timeToChange, { alpha:newAlpha } );
		}
		
	}

}