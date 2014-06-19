package playArea 
{
	import events.BBAnimationEvents;
	import FGL.GameTracker.GameTracker;
	import managers.AnimationManager;
	import managers.utilities;
	import screens.GameScreen;
	import screens.highlightTypes;
	import ships.Battleship;
	import ships.Carrier;
	import ships.Fighter;
	import ships.ShipBase;
	import ships.ShipTypes;
	import ships.Submarine;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author dan
	 */
	public class AI extends Sprite
	{
		private var game:GameScreen;
		
		private var shipsAvailable:Vector.<ShipBase>;
		private var shipToUse:ShipBase;
		private var target:ShipBase;
		
		private var availableCells:Vector.<GridCell>;
		
		private var recoveredFighter:Boolean = false;
		
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
				GameTracker.api.alert("AI starting using" + shipToUse+"targeting" + target);
				trace("AI starting using"+shipToUse+"targeting"+target);
				startActionEventChain();
			}
		}
		
		private function selectTarget(shipToUse:ShipBase):ShipBase 
		{
			var targetShip:ShipBase;
			var shipToCheck:ShipBase;
			
			var range:Number;
			var closestRange:Number = 300;
			
			var visibleEnemyShips:Vector.<ShipBase> = findEnemyShips();
			
			if (visibleEnemyShips.length == 0)
			{
				return null;
			}
			
			//fighters  search for specifically fighters
			
			if (shipToUse.shipType == ShipTypes.FIGHTER)
			{
				for (var f:int = visibleEnemyShips.length - 1; f >= 0; f--)
				{
					shipToCheck = visibleEnemyShips[f];
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
			
			//trace("acquiring target for " + shipToUse);
			//just searches for the closest target that isn't a fighter
			for (var i:int = visibleEnemyShips.length - 1; i >= 0; i--)
			{
				shipToCheck = visibleEnemyShips[i];
				//trace("checking against " + shipToCheck);
				if (shipToCheck.team == 1 && shipToCheck.shipType != ShipTypes.FIGHTER)
				{
				   if(shipToCheck.shipType==ShipTypes.SUBMARINE && (shipToCheck as Submarine).submerged) // if ship is a submarine and is submerged, can't target.
					{
						//trace("submerged submarine");
						break;
					}
					range = shipToCheck.getRangeToSquare(game.grid[shipToUse.location.x][shipToUse.location.y]);
				//	trace("meets criteria.  Range: " + range);
					if (range < closestRange)
					{
						closestRange = range;
						targetShip = shipToCheck;
						//trace ("new closest");
					}
				}	
				
			}
			return targetShip;
		}
		
		private function findEnemyShips():Vector.<ShipBase> 
		{
			var computerShips:Vector.<ShipBase> = new Vector.<ShipBase>();
			var PlayerShips:Vector.<ShipBase> = new Vector.<ShipBase>();
			var returnShips:Vector.<ShipBase> = new Vector.<ShipBase>();

			
			//sort ships
			for (var i:int = 0; i <= game.shipsInPlay.length - 1; i++)
			{
				if (game.shipsInPlay[i].team == 1)
				{
					PlayerShips.push(game.shipsInPlay[i]);
				}
				else
				{
					computerShips.push(game.shipsInPlay[i]);
				}
			}
			
			var range:Number;
			var playerShip:ShipBase;
			//for each computer ships
			for (var comp:int = 0; comp <= computerShips.length - 1; comp++)
			{
				//test against each player ship
				for (var play:int = 0; play <= PlayerShips.length - 1; play++)
				{
					playerShip = PlayerShips[play];
					range = computerShips[comp].getRangeToSquare(game.grid[playerShip.location.x][playerShip.location.y]);
					
					if (range <= computerShips[comp].visibilityRange)
					{
						returnShips.push(playerShip);
					}
				}
			}
			
			return returnShips;

		}
		
		public function startActionEventChain():void
		{
			trace("starting chain");
			if (target != null)
			{
				trace("target not null");
				moveShip(shipToUse);
			}
			else
			{
				trace("target null");
				moveToMaximizeVisibleSpace(shipToUse);
				//selectTarget(shipToUse);
			}
			
		}
		
		private function moveToMaximizeVisibleSpace(shipToUse:ShipBase):void 
		{
			trace("move to maximize");
			//for now just move down
			var yCoord:int = shipToUse.location.y;
			
			if (yCoord <= 9 - shipToUse.movementRange)
			{
				game.highlightRange(shipToUse.movementRange, shipToUse, highlightTypes.MOVE);
				game.moveShip(shipToUse, game.grid[shipToUse.location.x][shipToUse.location.y + shipToUse.movementRange]);
				game.resetHighlight();
			}
			else
			{
				game.highlightRange(shipToUse.movementRange, shipToUse, highlightTypes.MOVE);
				game.moveShip(shipToUse, game.grid[shipToUse.location.x][9]);
				game.resetHighlight();
			}
		}
		

		
		public function arrangeShips():void 
		{
			shipsAvailable = findShipsToUse();
			if (shipsAvailable.length != 0)
			{
				var cellsAvailable:Vector.<GridCell> = game.highlightRange(18, shipsAvailable[0], highlightTypes.COMPUTER_PLACE);
				var index:int;
				//for each ship
				for (var i:int = shipsAvailable.length - 1; i >= 0; i--)
				{
					//which cell to move to
					index = Math.floor(Math.random() * cellsAvailable.length);
					//move there
					game.moveShip(shipsAvailable[i], cellsAvailable[index]);
					//remove the cell from the list
					cellsAvailable.splice(index, 1);
				}
			}
			
			game.resetHighlight();
		}
		
		private function actionShip(ship:ShipBase):void 
		{
			GameTracker.api.alert("AI action");
			trace("AI action");
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
			else if (ship.shipType == ShipTypes.SUBMARINE)
			{
				submarineAction(ship);
			}
			
		}
		
		
		public function handleAfterFireEvent(e:BBAnimationEvents):void 
		{
			trace("top of link after firing");
			var shipInEvent:ShipBase = e.data.ship;
			
			if (shipInEvent.team == 2)
			{
				if (shipInEvent.shipType == ShipTypes.PATROL_BOAT)
				{
					this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, { ship:shipInEvent } ));
				}
				else if (shipInEvent.shipType == ShipTypes.FIGHTER)
				{
					this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, { ship:shipInEvent } ));
				}
				else
				{
					actionShip(shipInEvent);
				}
			}
		}
		
		public function cleanUpEvent(e:BBAnimationEvents):void 
		{
			trace("end of chain, clean up");
			var shipInEvent:ShipBase = e.data.ship;
			var recover:Boolean = false;
			
			if (e.data.recoverFighter)
			{
				recover = true;
			}
			if (shipInEvent.team == 2)
			{
				trace("inside clean up block");
				recoveredFighter = false;

				shipInEvent.moved = true;
				shipInEvent.fired = true;
				shipInEvent.performedAction = true;

				//to activate the mask of the ship
				shipInEvent.turnCompleted = true;
				shipInEvent.updateStatus();
			}
			
			this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_TURN, true, {fighterRecover:recover}));
		}
		
		private function submarineAction(ship:ShipBase):void 
		{
			var shipsInPlay:Vector.<ShipBase> = game.shipsInPlay;
			var shipToCheck:ShipBase;
			var closestRange:Number = 300;
			var rangeToCheck:Number;
			
			for (var i:int = shipsInPlay.length - 1; i >= 0; i--)
			{
				shipToCheck = shipsInPlay[i];
				//screen out friendly ships
				if (shipToCheck.team != 2)
				{
					rangeToCheck = shipToCheck.getRangeToSquare(game.grid[ship.location.x][ship.location.y]);
					if (rangeToCheck < closestRange)
					{
						closestRange = rangeToCheck;
					}
				}
			}
			
			if (closestRange <= 4)
			{
				var submarine:Submarine = ship as Submarine;
				if (submarine.numberOfDivesRemaining > 0)
				{
					submarine.submerged = true;
					AnimationManager.submarineVisibility(submarine, false);
					submarine.numberOfDivesRemaining--;
				}
			}
			
			this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, { ship:ship } ));

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
			else
			{
				this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, { ship:ship } ));
			}
			
			game.resetHighlight();
			
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
						if (target != null)
						{
							tempRange = target.getRangeToSquare(targetableCells[i]);
							if (tempRange < closestRange)
							{
								index = i;
								closestRange = tempRange;
							}
						}		
					}
					if (target == null)
					{
						index = 0;
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
			else 
			{
				this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, { ship:AIship } ));
			}
			
			game.resetHighlight();
			
			
		}
		
		public function fireShip(AIship:ShipBase):void 
		{
			GameTracker.api.alert("AI firing");
			trace("AI firing");
			var targetCell:GridCell = game.grid[target.location.x][target.location.y];
			var rangeToTarget:Number = AIship.getRangeToSquare(targetCell);

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
			else
			{
				this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_FIRING, true, { ship:AIship } ));
			}
			
		}
		
		public function handleAfterMoveEvent(e:BBAnimationEvents):void 
		{
			trace("top of event handler after move");
			
			var shipInEvent:ShipBase = e.data.ship;
			
			trace(shipInEvent);
			trace(shipInEvent.team);
			trace(recoveredFighter);
			if (shipInEvent.team ==2 && !recoveredFighter)
			{
				if (target != null)
				{
					trace("firing ship");
					fireShip(shipInEvent);
				}
				else 
				{
					if (shipInEvent.shipType == ShipTypes.CARRIER)
					{
						trace("actioning carrier");
						actionShip(shipInEvent);
					}
					else 
					{
						trace("dispatching done with turn after just move");
						//to trigger a clean up...
						this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, {ship:shipInEvent}));
					}
				}
			}
		}
		
		private function moveShip(AIship:ShipBase):void 
		{
			GameTracker.api.alert("AI moving");
			trace("AI moving");
			if (AIship.shipType == ShipTypes.FIGHTER)
			{
				availableCells = game.highlightRange(AIship.movementRange, AIship, highlightTypes.FIGHTER_MOVE);
			}
			else
			{
				availableCells = game.highlightRange(AIship.movementRange, AIship, highlightTypes.MOVE);
			}
			
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
				var retreat:Boolean = retreatFighter(AIship);
				trace("retreat:" + retreat);
				
				if (retreat)
				{
					//move toward closest carrier
					var targetCarrier:Carrier = getClosestCarrier(AIship as Fighter);
					
					currentRange = 300;
					if (targetCarrier != null)
					{
						for (var j:int = availableCells.length - 1; j >= 0; j--)
						{
							cellToCheck = availableCells[j];

							checkedRange = targetCarrier.getRangeToSquare(cellToCheck);
					
							if (checkedRange < currentRange)
							{
								currentRange = checkedRange;
								targetCell = cellToCheck;
							}
						}
					}
				}
			}
			
			
			//will be null if no other cell is closer than current position
			if (targetCell != null)
			{	
				trace("target cell to move to not null");
				game.moveShip(shipToUse, targetCell);
				//if a fighter was recovered
				if (shipToUse.shipType==ShipTypes.FIGHTER && targetCell.occupied && targetCell.occupyingShip.shipType == ShipTypes.CARRIER)
				{
					recoveredFighter = true;
				}
			}
			else
			{
				game.resetHighlight();
				//if ship doesn't need to move, skip straight to firing, dispatch an event as if it had moved.
				trace("ship remaining stationary");
				this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_MOVING, true, { ship:shipToUse } ));
			}
		}
		
		private function retreatFighter(AIship:ShipBase):Boolean 
		{
			//its been hit once
			if (AIship.currentHP < 2)
			{
				return true;
			}
			
			var closestCarrier:Carrier = getClosestCarrier(AIship as Fighter);
			
			return !continueWithoutGoingToCarrier(AIship, closestCarrier);
			
			
		}
		
		private function getClosestCarrier(fighter:Fighter):Carrier
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
					rangeToCheck=shipToCheck.getRangeToSquare(game.grid[fighter.location.x][fighter.location.y]);
					if (rangeToCheck < rangeToCarrier)
					{
						rangeToCarrier = rangeToCheck;
						closestCarrier = shipToCheck;
					}
				}
			}
			
			return closestCarrier as Carrier;
		}
		
		private function continueWithoutGoingToCarrier(aIship:ShipBase, closestCarrier:Carrier):Boolean 
		{

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
			
			return (operationalFighterRange > closestCarrier.getRangeToSquare(game.grid[fighter.location.x][fighter.location.y]));
			
		}
		
		private function selectShip():ShipBase 
		{
			var returnShip:ShipBase = null;
			var returnIndex:int;
			
			//returns a random ship from those available
			returnIndex = Math.floor(Math.random() * shipsAvailable.length);
			
			
			return shipsAvailable[returnIndex];
			
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