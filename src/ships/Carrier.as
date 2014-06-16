package ships 
{
	import managers.AnimationManager;
	/**
	 * ...
	 * @author dan
	 */
	public class Carrier extends ShipBase 
	{
		public var fighterSquadrons:int;
		
		
		public function Carrier(team:int) 
		{
			this.team = team;
			shipType = ShipTypes.CARRIER;
			super();
			startingHP = 5;
			currentHP = 5;
			
			fighterSquadrons = 3;
		}
		
		public function launchFighter(fighter:Fighter):void
		{
			if (fighterSquadrons > 0)
			{
				fighterSquadrons--;
				launchFighterAnimation(fighter)
			}
		}
		
		private function launchFighterAnimation(fighter:Fighter):void 
		{
			AnimationManager.launchFighter(fighter, this.x-40);
			
		}
		
		public function recoverFighter():void
		{
			fighterSquadrons++;
		}
		
	}

}