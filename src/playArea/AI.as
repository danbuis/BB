package playArea 
{
	import screens.GameScreen;
	import screens.highlightTypes;
	import ships.Battleship;
	import ships.Carrier;
	import ships.Fighter;
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
			//if there are ships available
			if (shipsAvailable.length != 0)
			{
				shipToUse = selectShip();
			
				target = selectTarget(shipToUse);
			
				performActions();
			}
		}
		
		private function selectTarget(shipToUse:ShipBase):ShipBase 
		{
			var targetShip:ShipBase;
			var shipToCheck:ShipBase;
			
			var range:Number;
			var closestRange:Number = 300;
			
			//fighters and destroyers search for specifically fighters
			//TODO destroyers
			if (shipToUse.shipType == ShipTypes.FIGHTER)
			{
				for (var f:int = game.shipsInPlay.length - 1; f >= 0; f--)
				{
					shipToCheck = game.shipsInPlay[f];
					if (shipToCheck.team == 1 && shipToCheck.shipType == ShipTypes.FIGHTER)
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
				if (targetShip != null && targetShip.shipType == ShipTypes.FIGHTER)
				{
					return targetShip;
				}
			}
			
			
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
			//TODO decide what order to act
			
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
		
		private function actionShip(ship:ShipBase):void 
		{
			if (ship.shipType == ShipTypes.BATTLESHIP)
			{
				battleshipAction(ship);
			}
			else if (ship.shipType == ShipTypes.CARRIER)
			{
				carrierAction(ship);
			}
			else if (ship.shipType == ShipTypes.DESTROYER)
			{
				destroyerAction(ship);
			}
		}
		
		private function destroyerAction(ship:ShipBase):void 
		{
			game.resetHighlight();
			
			var targetableCells:Vector.<GridCell>;
				
			targetableCells = game.highlightRange(1, ship, highlightTypes.DESTROYER_AA);
			
			if (targetableCells.length > 0)
			{
				for (var i:int = targetableCells.length - 1; i >= 0; i--)
				{
					if (targetableCells[i].occupied && targetableCells[i].occupyingShip.shipType == ShipTypes.FIGHTER)
					{
						game.AAfire(ship, targetableCells[i]);
					}
				}
			}
		}
		
		private function carrierAction(ship:ShipBase):void 
		{
			var carrier:Carrier = ship as Carrier;
			
			if (carrier.fighterSquadrons > 0)
			{
				game.resetHighlight();
				
				var targetableCells:Vector.<GridCell>;
				
				targetableCells = game.highlightRange(1, ship, highlightTypes.FIGHTER_PLACE);
				
				var index:int = -1;
				var closestRange:Number = 300;
				var tempRange:Number;
				
				//if any cells highlighted
				if (targetableCells.length > 0)
				{
					for (var i:int = targetableCells.length - 1; i >= 0; i--)
					{
						tempRange = target.getRangeToSquare(targetableCells[i]);
						if (tempRange < closestRange)
						{
							index = i;
							closestRange = tempRange;
						}
					}
					game.launchFighter(carrier, new Fighter(carrier.team), targetableCells[index]);
				}
			}
			game.resetHighlight();
		}
		
		private function battleshipAction(AIship:ShipBase):void 
		{
			game.resetHighlight();
			var targetableCells:Vector.<GridCell>;
			
			targetableCells = game.highlightRange(Battleship.bombardRange, AIship, highlightTypes.BOMBARD);
			
			
			var shipToBombard:ShipBase;
			var index:int;
			
			var shipToCheck:ShipBase;
			for (var i:int = targetableCells.length - 1; i >= 0; i--)
			{
				if (targetableCells[i].occupied)
				{
					shipToCheck=targetableCells[i].occupyingShip
					if (shipToBombard == null)
					{
						shipToBombard = shipToCheck;
						index = i;
					}
					else
					{
						//searches for lowest health ship in an effort to finish one off
						if (shipToCheck.currentHP < shipToBombard.currentHP)
						{
							shipToBombard = shipToCheck;
							index = i;
						}
					}
				}
			}
			if (shipToBombard != null)
			{
				game.bombardShip(AIship, targetableCells[index]);
			}
			
			game.resetHighlight();
		}
		
		private function fireShip(AIship:ShipBase):void 
		{
			var targetCell:GridCell = game.grid[target.location.x][target.location.y];
			var rangeToTarget:Number = shipToUse.getRangeToSquare(targetCell);

			//if target in range
			if (rangeToTarget <= 1)
			{
				if (AIship.shipType != ShipTypes.FIGHTER)
				{
					game.highlightRange(1, shipToUse, highlightTypes.FIRE);
				}
				else 
				{
					game.highlightRange(1, shipToUse, highlightTypes.FIGHTER_FIRE);
				}

				game.fireShip(shipToUse, targetCell);
				
				//highlights reset in gameScreen
			}
		}
		
		private function moveShip(AIship:ShipBase):void 
		{
			//TODO: for now just moves closer to target ship
			
			availableCells = game.highlightRange(AIship.movementRange, AIship, highlightTypes.MOVE);
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
			
			//if using a fighter, check if retreat required
			if (AIship.shipType == ShipTypes.FIGHTER)
			{
				var retreat:Boolean = retreatFighter(AIship)
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
		
		private function retreatFighter(AIship:ShipBase):Boolean 
		{
			//its been hit once
			if (AIship.currentHP < 2)
			{
				return true;
			}
			//staying out will cause it to move out of range
			
			return continueWithoutGoingToCarrier(AIship);
			
			
		}
		
		private function continueWithoutGoingToCarrier(aIship:ShipBase):Boolean 
		{
			var closestCarrier:ShipBase;
			var shipToCheck:ShipBase;
			var rangeToCarrier:Number = 1000;
			var rangeToCheck:Number;
			
			for (var i:int = game.shipsInPlay.length - 1; i >= 0; i--)
			{
				shipToCheck = game.shipsInPlay[i];
				if (shipToCheck.team == 2 && shipToCheck.shipType==ShipTypes.CARRIER)
				{
					//get range to the carrier
					rangeToCheck=shipToCheck.getRangeToSquare(game.grid[aIship.location.x][aIship.location.y]);
					if (rangeToCheck < rangeToCarrier)
					{
						rangeToCarrier = rangeToCheck;
						closestCarrier = shipToCheck;
					}
				}
			}
			
			//if no carriers available
			if (closestCarrier==null)
			{
				return true;
			}
			
			//cast as a fighter
			var fighter:Fighter = aIship as Fighter;
			/*subtract 1 for the outbound trip
			 * when deployed operational range will be 2 movement ranges
			 * when at 2 endurange, operatoinal range is one movement
			 * when at 1, will return to carrier
			 * */
			var operationalFighterRange:int = (fighter.currentEndurance - 1) * fighter.movementRange;
			
			return (operationalFighterRange > rangeToCarrier);
			
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