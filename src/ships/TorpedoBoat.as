package ships 
{
	/**
	 * ...
	 * @author dan
	 */
	public class TorpedoBoat extends ShipBase 
	{
		
		public function TorpedoBoat(team:int) 
		{
			this.team = team;
			shipType = ShipTypes.TORPEDO_BOAT;
			super();
			startingHP = 2;
			currentHP = 2;
			this.movementRange = 3;
			visibilityRange = 3;
		}
		
	}

}