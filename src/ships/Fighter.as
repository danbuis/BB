package ships 
{
	import events.BBAnimationEvents;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import managers.AnimationManager;
	/**
	 * ...
	 * @author dan
	 */
	public class Fighter extends ShipBase 
	{
		private var startingEndurance:int=3;
		public var currentEndurance:int = 3;
		
		
		public function Fighter(team:int) 
		{
			this.team = team;
			shipType = ShipTypes.FIGHTER;
			super();
			startingHP = 2;
			currentHP = 2;
			movementRange = 4;
			visibilityRange = 4;
		}
		
		public function useEndurance():void
		{
			currentEndurance--;
		}
		
		//TODO refine timing, get more accurate estimate of second fighter pivot.  currently it grabs it from the original start state.  check order of display list.  landing fighter should be moved to the top...
		public function landFighterAnimation( carrier:Carrier):void
		{
			//first move fighter and rotate carrier into position
			var timeForFghterMove:int = this.moveAndRotateShip(carrier.x - 40, carrier.y, this.getRangeToShip(carrier), true);
			trace("time for fighter move:" + timeForFghterMove);
			var timeForCarrier:int = carrier.pivotShip(13);
			trace("time for carrier pivot:" + timeForCarrier);
			
			//after fighter has moved, rotate it to land
			var fighterMoveTimer:Timer = new Timer(timeForFghterMove, 1);
			var timeToRotate:int = this.getRotationDistance(5) * animInterval;
			trace("time for fighter pivot:" + timeToRotate);
			fighterMoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rotateFighterToLand);
			fighterMoveTimer.start();
			
			
			//var timeForFighterPivot:int = fighter.pivotShip(5);
			
			var delay:int = Math.max((timeForFghterMove+timeToRotate), timeForCarrier);
			trace("delay:"+delay);
			var setUpTimer:Timer = new Timer(delay,1);
			setUpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, landFighter);
			setUpTimer.start();
			
			shipRef = carrier;
		}
		
		private function rotateFighterToLand(e:TimerEvent):void 
		{
			this.pivotShip(5);
		}
		
		private function landFighter(e:Event):void 
		{
			AnimationManager.landFighter(this, shipRef.x + 20);
			
			var eventDispatchTimer:Timer = new Timer(2000, 1);
			eventDispatchTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchLandingEvent);
			eventDispatchTimer.start();
			
		}
		
		private function dispatchLandingEvent(e:TimerEvent):void 
		{
			this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, { ship:this, fighterRecover:true } ));
		}
		
	}

}