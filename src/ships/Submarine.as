package ships 
{
	/**
	 * ...
	 * @author dan
	 */
	public class Submarine extends ShipBase 
	{
		public var numberOfDivesRemaining:int = 8;
		
		public function Submarine(team:int) 
		{
			
			this.team = team;
			shipType = ShipTypes.SUBMARINE;
			super();
			startingHP = 3;
			currentHP = 3;
		}
		
	}

}