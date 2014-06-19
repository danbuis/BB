package ships 
{
	import events.BBAnimationEvents;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import managers.AnimationManager;
	import playArea.GridCell;
	import screens.GameScreen;
	/**
	 * ...
	 * @author dan
	 */
	public class Carrier extends ShipBase 
	{
		public var fighterSquadrons:int;
		
		private var game:GameScreen;
		private var gridCell:GridCell;
		
		
		public function Carrier(team:int) 
		{
			this.team = team;
			shipType = ShipTypes.CARRIER;
			super();
			startingHP = 5;
			currentHP = 5;
			
			fighterSquadrons = 3;
		}
		
		public function launchFighter(fighter:Fighter, gridCell:GridCell, game:GameScreen):void
		{
			if (fighterSquadrons > 0)
			{
				fighterSquadrons--;
				
				this.gridCell = gridCell;
				this.game = game;
				shipRef = fighter;
			
				
				
				var timeToPivotCarrier:int = this.pivotShip(13);
				var timeToPivot:Timer = new Timer(timeToPivotCarrier, 1);
				timeToPivot.addEventListener(TimerEvent.TIMER_COMPLETE, launchFighterAnimation);
				timeToPivot.start();
			}
		}
		
		private function launchFighterAnimation(f:int):void 
		{
			//trace("carrier launch fighter");
			shipRef.updateSprite(13);
			
			game.pushShip(shipRef);
			
			shipRef.x = this.x + 20;
			shipRef.y = this.y + 20;
			//trace("x:" + shipRef.x);
			//trace("y:" + shipRef.y);
			shipRef.scaleX = 0.1;
			shipRef.scaleY = 0.1;
			shipRef.alpha = 0.5;
			AnimationManager.launchFighter(shipRef as Fighter, this.x - 40, this.y);
			
			
			
			var timeToTakeOff:Timer = new Timer(2000, 1);
			timeToTakeOff.addEventListener(TimerEvent.TIMER_COMPLETE, fighterLaunchMoveToPosition)
			timeToTakeOff.start();
			
			
		}
		
		private function fighterLaunchMoveToPosition(e:TimerEvent):void 
		{
			//trace("x:" + shipRef.x);
			var delay:int = shipRef.moveAndRotateShip((this.gridCell.coordinates.x * 40 + 40), (this.gridCell.coordinates.y * 40 + 40), 
			2.5, false, gridCell);
			
			var timeToMoveRotateFighter:Timer = new Timer(delay - 500, 1);
			timeToMoveRotateFighter.addEventListener(TimerEvent.TIMER_COMPLETE, pushFighter);
			timeToMoveRotateFighter.start();
		}
		
		private function pushFighter(e:TimerEvent):void 
		{
			game.placeShip(shipRef, gridCell.coordinates.x, gridCell.coordinates.y);
			game.resetFog();
			
			trace("dispatching action");
			this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, { ship:this } ));
		}
		
		public function recoverFighter():void
		{
			fighterSquadrons++;
		}
		
	}

}