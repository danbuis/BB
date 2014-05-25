package playArea 
{
	import screens.GameScreen;
	import screens.highlightTypes;
	import ships.ShipBase;
	import ships.ShipTypes;
	/**
	 * ...
	 * @author dan
	 */
	public class AI 
	{
		private var game:GameScreen;
		
		private var shipsAvailable:Vector.<ShipBase>;
		private var shipToUse:ShipBase;
		private var target:ShipBase;
		
		private var availableCells:Vector.<GridCell>;
		
		public function AI(gs:GameScreen) 
		{
			this.game = gs;
		}
		
		public function takeTurn():void
		{
			shipsAvailable = findShipsToUse();
			
			shipToUse = selectShip();
			//game.selectedShip = shipToUse;
			
			target = selectTarget(shipToUse);
			
			performActions();
		}
		
		private function selectTarget(shipToUse:ShipBase):ShipBase 
		{
			var targetShip:ShipBase;
			var shipToCheck:ShipBase;
			
			var range:Number;
			var closestRange:Number = 300;
			
			//fighters and destroyers search for specifically fighters
			//TODO destroyers
			/*if (shipToUse.shipType == ShipTypes.FIGHTER)
			{
				for (var f:int = game.shipsInPlay.length - 1; f >= 0; f--)
				{
					shipToCheck = game.shipsInPlay[f];
					if (shipToCheck.team == 1 && shipToCheck.shipType==ShipTypes.FIGHTER)
					{
						range = shipToCheck.getRangeToSquare(game.grid[shipToUse.location.x][shipToUse.location.y]);

					
						if (range < closestRange)
						{
							closestRange = range;
							targetShip = shipToCheck;
						}
					}
				}
				
				//if it found a valid fighter target
				if (targetShip.shipType == ShipTypes.FIGHTER)
				{
					return targetShip;
				}
			}
			
			*/
			//just searches for the closest target that isn't a fighter
			for (var i:int = game.shipsInPlay.length - 1; i >= 0; i--)
			{
				shipToCheck = game.shipsInPlay[i];
				if (shipToCheck.team == 1 && shipToCheck.shipType!=ShipTypes.FIGHTER)
				{
					range = shipToCheck.getRangeToSquare(game.grid[shipToUse.location.x][shipToUse.location.y]);
					
					if (range < closestRange)
					{
						closestRange = range;
						targetShip = shipToCheck;
					}
					
				}
			}
			return targetShip;
		}
		
		public function performActions():void
		{
			//TODO decide what action to take
			
			moveShip(shipToUse);
			fireShip(shipToUse);
			actionShip(shipToUse);

			shipToUse.moved = true;
			shipToUse.fired = true;
			shipToUse.performedAction = true;

			//to activate the mask of the ship
			shipToUse.turnCompleted = true;
			shipToUse.updateStatus();
			
		}
		
		private function actionShip(shipToUse:ShipBase):void 
		{
			// TODO:
		}
		
		private function fireShip(AIship:ShipBase):void 
		{
			var targetCell:GridCell = game.grid[target.location.x][target.location.y];
			var rangeToTarget:Number = shipToUse.getRangeToSquare(targetCell);

			//if target in range
			if (rangeToTarget <= 1)
			{
				
				game.highlightRange(1, shipToUse, highlightTypes.FIRE);
				//TODO:handle fighters as target
				game.fireShip(shipToUse, targetCell);
				
				//highlights reset in gameScreen
			}
		}
		
		private function moveShip(AIship:ShipBase):void 
		{
			//TODO: for now just moves closer to target ship
			
			availableCells = game.highlightRange(shipToUse.movementRange, shipToUse, highlightTypes.MOVE);
			//defines benchmark
			var currentRange:Number = target.getRangeToSquare(game.grid[shipToUse.location.x][shipToUse.location.y]);
			var checkedRange:Number;
			var targetCell:GridCell;
			var cellToCheck:GridCell;
			
			for (var i:int = availableCells.length - 1; i >= 0; i--)
			{
				cellToCheck = availableCells[i];

				checkedRange = target.getRangeToSquare(cellToCheck);
					
				if (checkedRange < currentRange)
				{
					currentRange = checkedRange;
					targetCell = cellToCheck;

				}
			}
			
			//will be null if no other cell is closer than current position
			if (targetCell != null)
			{	
				game.moveShip(shipToUse, targetCell);
			}
			else
			{
				game.resetHighlight();
			}
		}
		
		private function selectShip():ShipBase 
		{
			var returnShip:ShipBase = null;
			//TODO: refine, justgrabs the first one on its list.
			
			return shipsAvailable[0];
			
		}
		
		private function findShipsToUse():Vector.<ShipBase> 
		{
			var returnVector:Vector.<ShipBase> = new Vector.<ShipBase>();
			for (var i:int = game.shipsInPlay.length - 1; i >= 0; i--)
			{
				if (game.shipsInPlay[i].team == 2 && !game.shipsInPlay[i].turnCompleted)
				{
					returnVector.push(game.shipsInPlay[i]);
				}
			}
			
			return returnVector;
		}
		
		
		
		
	}

}