package ships 
{
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
		
		public function launchFighter():void
		{
			if (fighterSquadrons > 0)
			{
				fighterSquadrons--;
			}
		}
		
		public function recoverFighter():void
		{
			fighterSquadrons++;
		}
		
	}

}