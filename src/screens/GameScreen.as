package screens
{
	import flash.geom.Point;
	import managers.GameTurnManager;
	import playArea.AI;
	import playArea.ControlBar;
	import playArea.CurrentPlayer;
	import playArea.GameGrid;
	import playArea.GridCell;
	import ships.Battleship;
	import ships.Carrier;
	import ships.Destroyer;
	import ships.Fighter;
	import ships.ShipBase;
	import ships.ShipTypes;
	import ships.Submarine;
	import ships.TorpedoBoat;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author dan
	 */
	public class GameScreen extends BaseScreen
	{
		public var backgroundImage:GameGrid;
		
		// grid information, uses center of grid cell
		public var grid:Array = [];
		private var gridWidth:int = 10;
		private var gridHeight:int = 10;
		public var gridOrigin:Point = new Point(40, 40);
		public var gridSpacing:int = 40;
		
		public var ship1:ShipBase;
		public var ship2:ShipBase;
		
		public var shipsStarting:Vector.<ShipBase>;
		public var shipsInPlay:Vector.<ShipBase>;
		
		public var fighterAwaitingPlacement:Boolean = false;
		
		public var selectedShip:ShipBase;
		public var isAShipSelected:Boolean = false;
		public var isSelectionLocked:Boolean = false;
		public var shipMoving:Boolean = false;
		public var shipFiring:Boolean = false;
		public var shipActioning:Boolean = false;
		
		public var GUI:ControlBar;
		
		private var opponent:AI;
		private var currentPlayer:String = CurrentPlayer.PLAYER;
		private var gameTurnManager:GameTurnManager = new GameTurnManager();
		
		public function GameScreen()
		{
			super();
			
			shipsInPlay = new Vector.<ShipBase>();
			shipsStarting = new Vector.<ShipBase>();
			
			drawScreen();
			initializeGrid();
			
			//separates clickable area from interface areas
			backgroundImage.touchable = true;
			backgroundImage.addEventListener(TouchEvent.TOUCH, clickHandler);
			
			opponent = new AI(this);
			
			trace("gamescreen initialized");
		}
		
		/* used to add ships initially
		 * */
		public function addShips(shipArray:Array):void
		{
			
			// TODO: refactor so create/place/push happens elsewhere.  This just governs initial placement
			var currentX:int = 0;
			var currentY:int = 9;
			
			var shipToAdd:ShipBase;
			if (shipArray[0] != 0)
			{
				shipToAdd = new Carrier(1);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++;
			}
			if (shipArray[1] != 0)
			{
				shipToAdd = new Battleship(1);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++;
			}
			if (shipArray[2] != 0)
			{
				shipToAdd = new Submarine(1);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++
			}
			if (shipArray[3] != 0)
			{
				shipToAdd = new Destroyer(1);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++
			}
			if (shipArray[4] != 0)
			{
				shipToAdd = new TorpedoBoat(1);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++;
			}
			
			currentY = 0;
			currentX = 0;
			
			if (shipArray[5] != 0)
			{
				shipToAdd = new Carrier(2);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++;
			}
			if (shipArray[6] != 0)
			{
				shipToAdd = new Battleship(2);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++;
			}
			if (shipArray[7] != 0)
			{
				shipToAdd = new Submarine(2);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++
			}
			if (shipArray[8] != 0)
			{
				shipToAdd = new Destroyer(2);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++
			}
			if (shipArray[9] != 0)
			{
				shipToAdd = new Fighter(2);
				placeShip(shipToAdd, currentX, currentY);
				pushShip(shipToAdd);
				currentX++;
			}
			
			trace("finished adding ships");
		}
		
		//TODO: fighters should not be added to ships in starting.  Refactor for a more flexible method
		//helper method for addShips()
		private function pushShip(ship:ShipBase):void
		{
			shipsStarting.push(ship);
			shipsInPlay.push(ship);
			backgroundImage.addChild(ship);
		}
		
		private function drawScreen():void
		{
			backgroundImage = new GameGrid();
			this.addChild(backgroundImage);
			
			GUI = new ControlBar();
			this.addChild(GUI);
			GUI.x = backgroundImage.width - GUI.width;
			GUI.y = 0;
			addGUIEventHandlers();
		
		}
		
		private function addGUIEventHandlers():void
		{
			GUI.moveButton.addEventListener(Event.TRIGGERED, onMoveButtonClick);
			GUI.fireButton.addEventListener(Event.TRIGGERED, onFireButtonClick);
			GUI.bombardButton.addEventListener(Event.TRIGGERED, onBombardButtonClick);
			GUI.submergeButton.addEventListener(Event.TRIGGERED, onSubmergeButtonClick);
			GUI.launchFighterButton.addEventListener(Event.TRIGGERED, onLaunchFighterButtonClick);
			GUI.AAfireButton.addEventListener(Event.TRIGGERED, onAAfireButtonClick);
			GUI.shipCompleteButton.addEventListener(Event.TRIGGERED, onShipCompleteButtonClick);
			GUI.turnCompleteButton.addEventListener(Event.TRIGGERED, onTurnCompleteButtonClick);
		}
		
		private function onAAfireButtonClick(e:Event):void 
		{
			fighterAwaitingPlacement = false;
			
			if (isAShipSelected && selectedShip.shipType == ShipTypes.DESTROYER)
			{
				highlightRange(1, selectedShip, highlightTypes.DESTROYER_AA);
			
				//set shipActioning to true to let the click handler know how to process the next grid click
				shipMoving = false;
				shipFiring = false;
				shipActioning = true;
			}
			
		}
		
		//method called if plater decides to skip acting with remaining ships.  In testing used to reset the state of all ships
		private function onTurnCompleteButtonClick(e:Event):void 
		{
			turnIsComplete();
		}
		
		private function turnIsComplete():void 
		{
			//reset ships
			for (var i:int = shipsInPlay.length-1; i >= 0; i--)
			{
				shipsInPlay[i].resetShip();
				
				
				//update fighter endurance
				if (shipsInPlay[i].shipType == ShipTypes.FIGHTER)
				{
					var fighter:Fighter = shipsInPlay[i] as Fighter;
					fighter.useEndurance();
					
					//fighter out of fuel
					if (fighter.currentEndurance <= 0)
					{
						killShip(fighter);
					}
				}
			}
			
			//reset current boolean values
			shipMoving = false;
			shipActioning = false;
			shipFiring = false;
			
			//reset GUI
			GUI.eraseCurrentStatus();
			
		}
		
		//method called if player decides to skip some actions available
		private function onShipCompleteButtonClick(e:Event):void 
		{
			if (selectedShip != null)
			{
				selectedShip.fired = true;
				selectedShip.moved = true;
				selectedShip.performedAction = true;
			
				updateSelection();
				GUI.eraseCurrentStatus();
			}
		}
		
		private function onLaunchFighterButtonClick(e:Event):void 
		{
			//double check that carrier selected
			if (isAShipSelected && selectedShip.shipType == ShipTypes.CARRIER)
			{
				//check remaining fighter squadrons
				var fightersStored:int = (selectedShip as Carrier).fighterSquadrons;
				if (fightersStored > 0)
				{	
					fighterAwaitingPlacement = true;
					
					resetHighlight();
					highlightRange(1, selectedShip, highlightTypes.FIGHTER_PLACE);
					
				}
			}
		}
	
		private function onSubmergeButtonClick(e:Event):void 
		{
			//reset value in case that was the previous, uncompleted order
			fighterAwaitingPlacement = false;
			
			//double check a ship is selected and that it is a submarine
			if (isAShipSelected && selectedShip.shipType == ShipTypes.SUBMARINE)
			{
				var selectedSub:Submarine = selectedShip as Submarine;
				if (selectedSub.numberOfDivesRemaining > 0)
				{
					selectedSub.alpha = 0.2;
					selectedSub.numberOfDivesRemaining--;
					
					selectedShip.performedAction = true;
					GUI.updateShipStatus(selectedShip);
					
					isSelectionLocked = true;
					updateSelection();
					
				}
			}
		}
		
		private function onBombardButtonClick(e:Event):void
		{
			
			//reset value in case that was the previous, uncompleted order
			fighterAwaitingPlacement = false;
			
			//double check a ship is selected and is a battleship
			if (isAShipSelected && selectedShip.shipType == ShipTypes.BATTLESHIP)
			{
				//reset highlights
				resetHighlight();
				
				//highlight cells in range (all ships fire at range 1)
				highlightRange(Battleship.bombardRange, selectedShip, highlightTypes.BOMBARD);
				
				//TODO: remove?
				//remove cells that are too close
				for (var x:int = 0; x < gridWidth; x++)
				{
					for (var y:int = 0; y < gridHeight; y++)
					{ //is square in range?
						if (selectedShip.getRangeToSquare(grid[x][y]) <= Battleship.minimumBombard)
							grid[x][y].hideHighlight();
					}
				}
				
				//set shipActioning to true to let the click handler know how to process the next grid click
				shipMoving = false;
				shipFiring = false;
				shipActioning = true;
			}
		}
		
		private function onFireButtonClick(e:Event):void
		{
			//reset value in case that was the previous, uncompleted order
			fighterAwaitingPlacement = false;

			//double check a ship is selected
			if (isAShipSelected)
			{
				//reset highlights
				resetHighlight();
				
				//highlight cells in range (all ships fire at range 1)
				if (selectedShip.shipType == ShipTypes.FIGHTER)
				{
					highlightRange(1, selectedShip, highlightTypes.FIGHTER_FIRE)
				}
				else
				{
					highlightRange(1, selectedShip, highlightTypes.FIRE);
				}
				
				//set shipFiring to true to let the click handler know how to process the next grid click
				shipMoving = false;
				shipFiring = true;
				shipActioning = false;
			}
		}
		
		private function onMoveButtonClick(e:Event):void
		{
			//reset value in case that was the previous, uncompleted order
			fighterAwaitingPlacement = false;
			
			//double check ship is selected
			if (isAShipSelected)
			{
				//reset highlights
				resetHighlight();
				
				//then highlight grid cells in range
				if (selectedShip.shipType == ShipTypes.FIGHTER)
				{
					highlightRange(selectedShip.movementRange, selectedShip, highlightTypes.FIGHTER_MOVE);
				}
				else
				{
					highlightRange(selectedShip.movementRange, selectedShip, highlightTypes.MOVE);
				}
				
				//set shipMoving to true to let the click handler know how to process the next grid click
				shipMoving = true;
				shipFiring = false;
				shipActioning = false;
			}
		}
		
		private function initializeGrid():void
		{
			var temp:GridCell;
			for (var x:int = 0; x < gridWidth; x++)
			{
				var column:Array = new Array();
				for (var y:int = 0; y < gridHeight; y++)
				{
					temp = new GridCell(x, y);
					column.push(temp);
					backgroundImage.addChild(temp);
				}
				grid[x] = column;
			}
		
		}
		
		/*
		 * places ships, rather than moving. differs only in the type of information being passed to the grid
		 * */
		private function placeShip(ship:ShipBase, x:int, y:int):void
		{
			ship.location.x = x;
			ship.location.y = y
			
			//updates the render location
			ship.x = gridOrigin.x + ship.location.x * gridSpacing + gridSpacing / 2 - ship.width / 2;
			ship.y = gridOrigin.y + ship.location.y * gridSpacing + gridSpacing / 2 - ship.height / 2;
			
			//tells new cell it is there
			grid[x][y].shipEnters(ship);
		
		}
		
		public function moveShip(ship:ShipBase, gridCell:GridCell):void
		{
			//if a fighter moved, update its endurance and act accordingly

			
			//if selected square is in range
			if (gridCell.isHighlighted())
			{
				//corner case for fighters landing on a carrier
				//if its now in a square with a carrier, let it land and update accordingly
				if (gridCell.occupied && gridCell.occupyingShip.shipType == ShipTypes.CARRIER)
				{
					(gridCell.occupyingShip as Carrier).recoverFighter();
					backgroundImage.removeChild(ship);
					
					//remove from ships in play
					var index:int = shipsInPlay.indexOf(ship);
					shipsInPlay.splice(index, 1);
			
					//tells current gridcell it has left
					grid[ship.location.x][ship.location.y].shipLeaves();
						
					//housekeeping to reset GUI
					selectedShip.turnCompleted = true;
					updateSelection();
					isAShipSelected = false;
					GUI.eraseCurrentStatus();
					
					trace("fighter recovered");
				}
				
				
				else
				{
					//tells current gridcell it has left
					grid[ship.location.x][ship.location.y].shipLeaves();
				
					//updates grid location within the ship's properties
					ship.location.x = gridCell.coordinates.x;
					ship.location.y = gridCell.coordinates.y;
				
				
					//TODO refactor this and place ship to a rendership method.  This will consolidate and enable changes based on facing of the ship
					//updates the render location
					ship.x = gridOrigin.x + ship.location.x * gridSpacing + gridSpacing / 2 - ship.width / 2;
					ship.y = gridOrigin.y + ship.location.y * gridSpacing + gridSpacing / 2 - ship.height / 2;
				
					//tells new cell it is there
					gridCell.shipEnters(ship);
				}
				trace("ship moved");
				
				//resets moving boolean and highlights
				//certain steps don't pertain to the computer
				if (currentPlayer == CurrentPlayer.PLAYER && selectedShip!=null)
				{
					shipMoving = false;
					selectedShip.moved = true;
					GUI.updateShipStatus(selectedShip);
					isSelectionLocked = true;
					updateSelection();
				}
				resetHighlight();
				


			}
			else
			{
				trace("ship can't move that far");
			}
		}
		
		
		//handles a ship firing on another.
		public function fireShip(ship:ShipBase, gridCell:GridCell):void
		{
			
			if (gridCell.isHighlighted() && gridCell.occupied && gridCell.occupyingShip.team != ship.team)
			{
				if (currentPlayer == CurrentPlayer.PLAYER)
				{
				shipFiring = false;
				selectedShip.fired = true;
				isSelectionLocked = true;
				GUI.updateShipStatus(selectedShip);
				updateSelection();
				}
				
				damageShip(gridCell.occupyingShip);

				resetHighlight();
				
				
				
			}
			else
				trace("no valid target to fire on");
		}
		
		
		//handles BB using its action
		public function bombardShip(selectedShip:ShipBase, gridCell:GridCell):void 
		{
			if (gridCell.isHighlighted() && gridCell.occupied && gridCell.occupyingShip.team != selectedShip.team)
			{
				trace("bombarding");
				damageShip(gridCell.occupyingShip);
				shipActioning = false;
				selectedShip.performedAction = true;
				GUI.updateShipStatus(selectedShip);
				resetHighlight();
				
				isSelectionLocked = true;
				updateSelection();
			}
			else
				trace("no valid target to bombard");
		}
		
		public function AAfire(selectedShip:ShipBase, gridCell:GridCell):void 
		{
			if (gridCell.isHighlighted() && gridCell.occupied && gridCell.occupyingShip.team != selectedShip.team)
			{
				trace("AAfire");
				damageShip(gridCell.occupyingShip);
				selectedShip.performedAction = true;
				shipActioning = false;
				
				if (currentPlayer == CurrentPlayer.PLAYER)
				{
					GUI.updateShipStatus(selectedShip);
					resetHighlight();
					isSelectionLocked = true;
				}
				
				updateSelection();
			}
		}
		
		private function damageShip(ship:ShipBase):void
		{
			ship.hit();
			if (ship.currentHP == 0)
			{
				killShip(ship);
			}
		}
		
		private function killShip(ship:ShipBase):void
		{
			//remove ship from background object
			backgroundImage.removeChild(ship);
			
			//remove from ships in play
			var index:int = shipsInPlay.indexOf(ship);
			shipsInPlay.splice(index, 1);
			
			//tells current gridcell it has left
			grid[ship.location.x][ship.location.y].shipLeaves();
			
			// TODO:check for win
		}
		
		
		/* processes touch events and returns with the grid cell that it corresponds with.
		 * If touch is outside the grid, it returns a default value that should be easy to check
		 * */
		private function clickHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{
				
				var touchPosition:Point = touch.getLocation(this);
				var gridCellClicked:GridCell = getGridCellFromClick(touchPosition.x, touchPosition.y);
				
				//verify that the click is on the grid
				if (validCell(gridCellClicked) && currentPlayer==CurrentPlayer.PLAYER)
				{
					//check if a fighter needs to be placed and selected ship is a carrier
					if (fighterAwaitingPlacement && selectedShip.shipType==ShipTypes.CARRIER)
					{
						if (gridCellClicked.isHighlighted())
						{
							//a valid location is found.  Create the fighter and place it.
							var newFighter:Fighter = new Fighter(selectedShip.team);
							placeShip(newFighter, gridCellClicked.coordinates.x, gridCellClicked.coordinates.y);
							pushShip(newFighter)
							
							//update carrier
							var carrier:Carrier;
							carrier = selectedShip as Carrier;
							carrier.launchFighter();
							carrier.performedAction = true;
							GUI.updateShipStatus(selectedShip);
							
							isSelectionLocked = true;
							updateSelection();
							
							//remove highlights
							resetHighlight();
							//reset boolean
							fighterAwaitingPlacement = false;
						}
					}
					//corner case where a fighter is moving and wants to land on a carrier
					if (selectedShip!=null && selectedShip.shipType == ShipTypes.FIGHTER && shipMoving)
					{
						//will move the ship, potentially onto a carrier
						moveShip(selectedShip, gridCellClicked);
					}
					
					
					//check if cell has a ship that can be selected
					else if (gridCellClicked.occupied && gridCellClicked.occupyingShip.team == 1 && !isSelectionLocked)
					{
						//select the ship
						selectedShip = gridCellClicked.occupyingShip;
						isAShipSelected = true;
						GUI.updateShipStatus(selectedShip);
						resetHighlight();
						
					}
					// if cell is not occupied, check if a ship is selected, and figure out what to do with it
					else if (isAShipSelected)
					{
						if (shipMoving)
						{
							//will try to move the ship until a valid target selected, or another ship selected
							moveShip(selectedShip, gridCellClicked);
						}
						else if (shipFiring)
						{
							//will try to fire until a valid target selected, or another ship/action selected.
							fireShip(selectedShip, gridCellClicked);
						}
						else if (shipActioning)
						{
							if (selectedShip.shipType == ShipTypes.BATTLESHIP)
							{
								bombardShip(selectedShip, gridCellClicked);
							}
							if (selectedShip.shipType == ShipTypes.DESTROYER)
							{
								AAfire(selectedShip, gridCellClicked);
							}
						}
					}
				}
			}
		}
		

		
		private function validCell(gridCellClicked:GridCell):Boolean
		{
			
			//rule out thrown cell
			if (gridCellClicked.coordinates.x < 0 || gridCellClicked.coordinates.y < 0)
			{
				return false;
			}
			return true;
		}
		
		/* Gets information from clickHandler method and returns a gridcell.  If click does not correspond
		 * with a gridcell a default value is returned.  Default value can be used to fail gracefully
		 * */
		private function getGridCellFromClick(x:int, y:int):GridCell
		{
			
			var returnX:int = Math.floor((x - gridOrigin.x) / gridSpacing);
			var returnY:int = Math.floor((y - gridOrigin.y) / gridSpacing);
			
			//check min and max
			if (returnX < 10 && returnY < 10 && returnX >= 0 && returnY >= 0)
			{
				return grid[returnX][returnY];
			}
			
			//only returns if touch event not on the grid
			return new GridCell(-1, -1);
		
		}
		
		/*highlights a section of the grid based on range and the ship that called it.  Used to check movement and shooting
		 * */
		
		public function highlightRange(range:int, ship:ShipBase, type:String):Vector.<GridCell>
		{
			
			var returnList:Vector.<GridCell> = new Vector.<GridCell>();
			
			var cellToCheck:GridCell;
			for (var x:int = 0; x < gridWidth; x++)
			{
				for (var y:int = 0; y < gridHeight; y++)
				{ //is square in range?
					cellToCheck = grid[x][y];
					
					var rangeToSquare:Number = ship.getRangeToSquare(cellToCheck);
					
					if (rangeToSquare <= range && rangeToSquare != 0)
					{
						
						//if moving, highlight all unoccupied
						if (type == highlightTypes.MOVE)
						{
							if (!cellToCheck.occupied)
							{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
							}
						}
						else if (type ==highlightTypes.FIRE)
						{
							// if firing hilight all squares not occupied by own team or any fighters
							if (!cellToCheck.occupied || 
							    (cellToCheck.occupied && cellToCheck.occupyingShip.team != ship.team 
								&& cellToCheck.occupyingShip.shipType!=ShipTypes.FIGHTER))
							{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
							}
						}
						else if (type==highlightTypes.FIGHTER_FIRE )
						{
							if (cellToCheck.occupied && cellToCheck.occupyingShip.team != ship.team)
							{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
							}
						}
						
						else if (type == highlightTypes.FIGHTER_PLACE)
						{
							if (!cellToCheck.occupied)
							{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
							}
						}
						
						else if (type == highlightTypes.FIGHTER_MOVE)
						{
							if (!cellToCheck.occupied)
							{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
							}
							if (cellToCheck.occupied && cellToCheck.occupyingShip.shipType == ShipTypes.CARRIER)
							{
								if (currentPlayer == CurrentPlayer.PLAYER && cellToCheck.occupyingShip.team == 1)
								{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
								}
								else if (currentPlayer == CurrentPlayer.COMPUTER && cellToCheck.occupyingShip.team == 2)
								{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
								}
							}
						}
						else if (type == highlightTypes.BOMBARD)
						{
							if (!cellToCheck.occupied || 
							    (cellToCheck.occupied && cellToCheck.occupyingShip.team != ship.team 
								&& cellToCheck.occupyingShip.shipType!=ShipTypes.FIGHTER))
							{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
							}
								
							if (rangeToSquare <= Battleship.minimumBombard)
							{
								cellToCheck.hideHighlight();
								returnList.pop();
							}
						}
						else if (type == highlightTypes.DESTROYER_AA)
						{
							if (cellToCheck.occupied && cellToCheck.occupyingShip.shipType == ShipTypes.FIGHTER)
							{
								cellToCheck.drawHighlight();
								returnList.push(cellToCheck);
							}
						}
					}
				}
				
			}
			
			return returnList;
		}
		
		//turns off all highlights
		public function resetHighlight():void
		{
			for (var x:int = 0; x < gridWidth; x++)
			{
				for (var y:int = 0; y < gridHeight; y++)
				{
					grid[x][y].hideHighlight();
				}
				
			}
		
		}
		
		
		//updates ship and selection state appropriately.
		private function updateSelection():void
		{
			selectedShip.updateStatus();
			
			//only when ship finished
			if (selectedShip.turnCompleted)
			{
				GUI.eraseCurrentStatus();
				selectedShip = null;
				
				whoGetsNextTurn();
			}
		}
		
		public function computerTurn():void 
		{
			//double check
			if (currentPlayer == CurrentPlayer.COMPUTER)
			{
				opponent.takeTurn();
			}
			
			whoGetsNextTurn();
		}
		
		private function whoGetsNextTurn():void
		{
			var nextPlayer:String = gameTurnManager.determineNextPlayer(shipsInPlay, currentPlayer);
			
			if (nextPlayer == CurrentPlayer.COMPUTER)
			{
				setTurnPriority(CurrentPlayer.COMPUTER)
				computerTurn();
			}
			else if (nextPlayer == CurrentPlayer.PLAYER)
			{
				setTurnPriority(CurrentPlayer.PLAYER);
				
				//unlock selection for player
				isSelectionLocked = false;
			}
			else if (nextPlayer == CurrentPlayer.TURN_COMPLETE)
			{
				turnIsComplete();
				whoGetsNextTurn();
			}
			
			else
			{
				trace("failed turn priority determination");
				trace(nextPlayer);
			}
		}
		
		private function setTurnPriority(nextPlayer:String):void
		{
			currentPlayer = nextPlayer;
		}
	
		// TODO: Reset function, completely resets the game
		// TODO: Restart function, using the current initial ship set
	
	}

}