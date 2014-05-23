package ships 
{
	import playArea.GridCell;
	/**
	 * ...
	 * @author dan
	 */
	public class Battleship extends ShipBase 
	{
		public static var bombardRange:int = 3;
		public static var minimumBombard:int = 1;
		
		
		public function Battleship(team:int) 
		{
			this.team = team;
			shipType = ShipTypes.BATTLESHIP;
			super();
			startingHP = 4;
			currentHP = 4;
		}
		


		
		
	}

}