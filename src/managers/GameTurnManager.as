package managers 
{
	import playArea.CurrentPlayer;
	import ships.ShipBase;
	/**
	 * ...
	 * @author dan
	 */
	public class GameTurnManager 
	{
		
		public function GameTurnManager() 
		{
			
		}
		
		public function determineNextPlayer(shipsInPlay:Vector.<ShipBase>, playerJustFinished:String):String
		{
			var playerRemainingShips:int = 0;
			var computerRemainingShips:int = 0;
			
			var playerCompletedShips:int = 0;
			var computerCompletedShips:int = 0;
			
			
			//builds stas for current game standing
			var shipToCheck:ShipBase;
			for (var i:int = shipsInPlay.length - 1; i >= 0; i--)
			{
				shipToCheck = shipsInPlay[i];
				
				if (shipToCheck.team == 1)
				{
					if (shipToCheck.turnCompleted)
					{
						playerCompletedShips++;
					}
					else
					{
						playerRemainingShips++;
					}
				}
				else
				{
					if (shipToCheck.turnCompleted)
					{
						computerCompletedShips++;
					}
					else
					{
						computerRemainingShips++;
					}
				}
			}
			
			
			trace(playerRemainingShips + ", " + playerCompletedShips + ", " + computerRemainingShips + ", " + computerCompletedShips + " " + playerJustFinished);
			//process corner cases
			
			//turn complete, need to start next one
			if (playerRemainingShips == 0 && computerRemainingShips == 0)
			{
				return CurrentPlayer.TURN_COMPLETE;
			}
			//turn starting. Player always goes first
			if (playerCompletedShips == 0)
			{
				return CurrentPlayer.PLAYER;
			}	
			// if player has ships, but compter does not, then player
			if (computerRemainingShips == 0 && playerRemainingShips > 0)
			{
				return CurrentPlayer.PLAYER;
			}
			
			//if computer has ships, but player does not, then player
			if (playerRemainingShips == 0 && computerRemainingShips > 0)
			{
				return CurrentPlayer.COMPUTER;
			}
			
			//normal cases
			if (playerJustFinished == CurrentPlayer.PLAYER)
			{
				return CurrentPlayer.COMPUTER;
			}
			
			if (playerJustFinished == CurrentPlayer.COMPUTER)
			{
				return CurrentPlayer.PLAYER;
			}
			
			//if you've gotten here, throw a string and the debugger will grab it.
			return (playerRemainingShips + ", " + playerCompletedShips + ", " + computerRemainingShips + ", " + computerCompletedShips + " " + playerJustFinished);
			
	
		}
		
	}

}