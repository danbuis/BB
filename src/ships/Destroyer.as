package ships 
{
	/**
	 * ...
	 * @author dan
	 */
	public class Destroyer extends ShipBase 
	{
		
		public function Destroyer(team:int) 
		{
		
			this.team = team;
			shipType = ShipTypes.DESTROYER;
			super();
			startingHP = 3;
			currentHP = 3;
		}
		
	}

}