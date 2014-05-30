package ships 
{
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
		
	}

}