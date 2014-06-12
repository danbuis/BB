package ships 
{
	/**
	 * ...
	 * @author dan
	 */
	public class PatrolBoat extends ShipBase 
	{
		
		public function PatrolBoat(team:int) 
		{
			this.team = team;
			shipType = ShipTypes.PATROL_BOAT;
			super();
			startingHP = 2;
			currentHP = 2;
			this.movementRange = 3;
			visibilityRange = 3;
		}
		
	}

}