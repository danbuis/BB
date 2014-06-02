package screens
{
	import events.BBNavigationEvent;
	import flash.geom.Point;
	import managers.AnimationManager;
	import managers.GameTurnManager;
	import managers.utilities;
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
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import com.greensock.TweenLite;
	
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
		public var currentPlayer:String = CurrentPlayer.PLAYER;
		private var gameTurnManager:GameTurnManager = new GameTurnManager();
		
		public var phase:String = GamePhase.PLACEMENT_PHASE;
		
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
			var currentX:int = 0;
			var currentY:int = 9;
			
			var shipToAdd:ShipBase;
			
			for (var index:int = 0; index <= 9; index++)
			{
				//at cutoff point, switch to top of grid
				if (index == 5)
				{
					currentY = 0;
				}
				while (shipArray[index] > 0)
				{
					if (index == 0)
					{
						shipToAdd = new Carrier(1);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
					else if (index == 1)
					{
						shipToAdd = new Battleship(1);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
					else if (index == 2)
					{
					shipToAdd = new Submarine(1);
					placeShip(shipToAdd, currentX, currentY);
					pushShip(shipToAdd);
					}
					else if (index ==3)
					{
						shipToAdd = new Destroyer(1);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
					else if (index == 4)
					{
						shipToAdd = new TorpedoBoat(1);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
			
					
					// cut off point between player and computer
					
					
					else if (index == 5)
					{
						shipToAdd = new Carrier(2);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
					else if (index == 6)
					{
						shipToAdd = new Battleship(2);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
					else if (index == 7)
					{
						shipToAdd = new Submarine(2);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
					else if (index == 8)
					{
						shipToAdd = new Destroyer(2);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
					if (index == 9)
					{
						shipToAdd = new TorpedoBoat(2);
						placeShip(shipToAdd, currentX, currentY);
						pushShip(shipToAdd);
					}
					
					if (currentX == 9) //if at the end of a row, iterate to the start of the next row
					{
						currentX = 0;
						if (currentY <= 4)
						{
							currentY++;
						}
						else
						{
							currentY--;
						}
					}
					shipArray[index]--;
					currentX++;
					
				}//end while loop
			} //end for loop.
			trace("finished adding ships");
			
			
			opponent.arrangeShips();
			
			//code for player to place ships
			//draws highlights
			for (var x:int = 0; x < gridWidth; x++)
			{
				for (var y:int = 0; y < gridHeight; y++)
				{
					if (y >= 8)
					{
						grid[x][y].drawHighlight(true);
					}
				}
			}
			
			//resets fog
			resetFog();
			
			
		}
		
		//helper method for addShips()
		public function pushShip(ship:ShipBase):void
		{
			//fighters should not be added to the starting list.
			if (ship.shipType != ShipTypes.FIGHTER)
			{
				shipsStarting.push(ship);
			}
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
			GUI.startGameButton.addEventListener(Event.TRIGGERED, onStartGameButtonClick);
			GUI.mainMenuButton.addEventListener(Event.TRIGGERED, onMainMenuButtonClick);
		}
		
		private function onMainMenuButtonClick(e:Event):void 
		{
			var buttonClicked:Button = e.target as Button;
			
			if (buttonClicked == GUI.mainMenuButton)
			{
				this.dispatchEvent(new BBNavigationEvent(BBNavigationEvent.MAIN_MENU, true));
			}
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
		private function onStartGameButtonClick(e:Event):void 
		{
			phase = GamePhase.PLAY_PHASE;
			GUI.switchToPlayPhase();
			resetHighlight()
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
						fighter.currentHP = 0;
						killShip(fighter);
					}
				}
				else if (shipsInPlay[i].shipType == ShipTypes.SUBMARINE)
				{
					var submarine:Submarine = shipsInPlay[i] as Submarine;
					
					submarine.submerged = false;
					submarine.alpha = 1.0;
					submarine.visible = true;
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
			if (selectedShip != null && phase==GamePhase.PLAY_PHASE)
			{
				selectedShip.fired = true;
				selectedShip.moved = true;
				selectedShip.performedAction = true;
			
				updateSelection(false);
				GUI.eraseCurrentStatus();
				 resetHighlight();
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
					selectedSub.submerged = true;
					
					selectedShip.performedAction = true;
					GUI.updateShipStatus(selectedShip, phase);
					
					isSelectionLocked = true;
					updateSelection(false);
					
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
		public function placeShip(ship:ShipBase, x:int, y:int):void
		{
			ship.location.x = x;
			ship.location.y = y
			
			//updates the render location
			ship.x = gridOrigin.x + ship.location.x * gridSpacing + gridSpacing / 2 - ship.width / 2;
			ship.y = gridOrigin.y + ship.location.y * gridSpacing + gridSpacing / 2 - ship.height / 2;
			
			//tells new cell it is there
			grid[x][y].shipEnters(ship);
		
		}
		
		public function moveShip(ship:ShipBase, gridCell:GridCell):Boolean
		{
			//if placement
			if (phase == GamePhase.PLACEMENT_PHASE)
			{
				if (gridCell.isHighlighted())
				{
					if (!gridCell.occupied)
					{
						//to pass to animation
						var range:Number = ship.getRangeToSquare(gridCell);
						//var time:Number = int(range * 100) / 100;

						//tells current gridcell it has left
						grid[ship.location.x][ship.location.y].shipLeaves();
				
						//updates grid location within the ship's properties
						ship.location.x = gridCell.coordinates.x;
						ship.location.y = gridCell.coordinates.y;
				
						//calculates new renderlocation for animation manager
						var tweenX:int = gridOrigin.x + ship.location.x * gridSpacing + gridSpacing / 2 - ship.width / 2;
						var tweenY:int = gridOrigin.y + ship.location.y * gridSpacing + gridSpacing / 2 - ship.height / 2;

				
						//tells new cell it is there
						gridCell.shipEnters(ship);
						
						//call to animation manager
						AnimationManager.moveShipAnimation(tweenX, tweenY, range, ship, phase);
						
						
						if (currentPlayer == CurrentPlayer.PLAYER)
						{
							resetFog();
						}
						return true;
					}
					
					else
					{
						//do nothing
						return false;
					}
				}
			}
			
			//if a fighter moved, update its endurance and act accordingly

			//TODO check for submerged subs, if found bounce back to closest square to origin.
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
					
					if (currentPlayer == CurrentPlayer.COMPUTER)
					{
						var test:int = 0;
					}
					
					if (currentPlayer == CurrentPlayer.PLAYER && ship.team == 1)
					{
						//housekeeping to reset GUI
						selectedShip.moved = true;
						selectedShip.fired = true;
						selectedShip.turnCompleted = true;
						GUI.eraseCurrentStatus();
						updateSelection(true);
						isAShipSelected = false;
						whoGetsNextTurn(true);
					}
					trace("fighter recovered");
					resetHighlight();
					
					resetFog();
					return true;
				}
				
				
				else
				{
					//to pass to animation
					range = ship.getRangeToSquare(gridCell);
					
					//tells current gridcell it has left
					grid[ship.location.x][ship.location.y].shipLeaves();
				
					//updates grid location within the ship's properties
					ship.location.x = gridCell.coordinates.x;
					ship.location.y = gridCell.coordinates.y;
					
					//updates the render location  for the animation manager
					tweenX = gridOrigin.x + ship.location.x * gridSpacing + gridSpacing / 2 - ship.width / 2;
					tweenY = gridOrigin.y + ship.location.y * gridSpacing + gridSpacing / 2 - ship.height / 2;
				
					//tells new cell it is there
					gridCell.shipEnters(ship);
					
					//call to animation manager
					AnimationManager.moveShipAnimation(tweenX, tweenY, range, ship, phase);
				}
				trace("ship moved");
				
				
				//resets moving boolean and highlights
				//certain steps don't pertain to the computer
				if (currentPlayer == CurrentPlayer.PLAYER && selectedShip!=null && ship.team == 1)
				{
					shipMoving = false;
					selectedShip.moved = true;
					GUI.updateShipStatus(selectedShip, phase);
					isSelectionLocked = true;
					updateSelection(false);
				}
				resetHighlight();
				
				if (ship.shipType == ShipTypes.SUBMARINE || ship.shipType == ShipTypes.DESTROYER)
				{
					checkForRevealedSubs(ship, gridCell);
				}
				resetFog();
				return true;


			}
			else
			{
				trace("ship can't move that far");
				return false;
			}
		}
		
		private function checkForRevealedSubs(ship:ShipBase, gridCell:GridCell):void 
		{
			//look at each ship
			var shipToCheck:ShipBase;
			var revealedSub:Submarine;
			for (var i:int = shipsInPlay.length-1; i >= 0; i--)
			{
				shipToCheck = shipsInPlay[i];
				//look for submarines on the other team
				if (shipToCheck.shipType == ShipTypes.SUBMARINE && shipToCheck.team != ship.team)
				{
					//TODO copy somewhere that is called at the start of the player's turn.
					//check if they are close enough
					if (shipToCheck.getRangeToSquare(gridCell) <= 1.6)
					{
						revealedSub = shipToCheck as Submarine;
						revealedSub.visible = true;
						revealedSub.submerged = false;
						revealedSub.alpha = 1.0;
					}
				}
			}
		}
		
		
		//handles a ship firing on another.
		public function fireShip(ship:ShipBase, gridCell:GridCell):void
		{
			
			if (gridCell.isHighlighted() && gridCell.occupied && gridCell.occupyingShip.team != ship.team)
			{
				if (currentPlayer == CurrentPlayer.PLAYER && ship.team == 1 )
				{
				shipFiring = false;
				selectedShip.fired = true;
				isSelectionLocked = true;
				GUI.updateShipStatus(selectedShip, phase);
				updateSelection(false);
				}
				
				/* odd bug where player fighter attacks a recently launched AI fighter.  The click registers as normal, 
				 * but registers again after AI code finishes executing, causing a null pointer due to the now unoccupied square.
				 * 
				 * therefore added a double check to prevent the problem.
				 * */
				if (gridCell.occupied)
				{
					damageShip(gridCell.occupyingShip);
				}

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
				
				if (currentPlayer == CurrentPlayer.PLAYER && selectedShip.team == 1)
				{
					shipActioning = false;
					selectedShip.performedAction = true;
					GUI.updateShipStatus(selectedShip, phase);
					isSelectionLocked = true;
					updateSelection(false);
				}
	
				resetHighlight();
				
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
				
				if (currentPlayer == CurrentPlayer.PLAYER && selectedShip.team == 1)
				{
					GUI.updateShipStatus(selectedShip, phase);
					resetHighlight();
					isSelectionLocked = true;
					updateSelection(false);
				}
				
				
			}
		}
		
		private function damageShip(ship:ShipBase):void
		{
			ship.hit();
			trace("hitting ship");
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
			
			//garbage collection
			ship.dispose();
			
			// TODO:check for win
		}
		
		
		/* processes touch events and returns with the grid cell that it corresponds with.
		 * If touch is outside the grid, it returns a default value that should be easy to check
		 * */
		public function clickHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{
				
				var touchPosition:Point = touch.getLocation(this);
				var gridCellClicked:GridCell = getGridCellFromClick(touchPosition.x, touchPosition.y);
				
				
				//verify that the click is on the grid
				if (validCell(gridCellClicked) && currentPlayer==CurrentPlayer.PLAYER)
				{
					if (phase == GamePhase.PLACEMENT_PHASE)
					{
						if (gridCellClicked.occupied)
						{
							selectedShip = gridCellClicked.occupyingShip;
							GUI.updateShipStatus(selectedShip, phase);
						}
						else
						{
							if (selectedShip != null)
							{
								moveShip(selectedShip, gridCellClicked);
							}
						}
					}
					//check if a fighter needs to be placed and selected ship is a carrier
					else if (fighterAwaitingPlacement && selectedShip.shipType==ShipTypes.CARRIER)
					{
						if (gridCellClicked.isHighlighted())
						{
							//a valid location is found.  Create the fighter and place it.
							var newFighter:Fighter = new Fighter(selectedShip.team);
							
							var carrier:Carrier;
							carrier = selectedShip as Carrier;
							launchFighter(carrier, newFighter, gridCellClicked);
						}
					}
					//corner case where a fighter is moving and wants to land on a carrier
					else if (selectedShip!=null && selectedShip.shipType == ShipTypes.FIGHTER && shipMoving)
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
						GUI.updateShipStatus(selectedShip, phase);
						resetHighlight();
						
					}
					// if cell is not occupied, check if a ship is selected, and figure out what to do with it
					else if (isAShipSelected && selectedShip!= null)
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
							if (selectedShip!= null && selectedShip.shipType == ShipTypes.BATTLESHIP)
							{
								bombardShip(selectedShip, gridCellClicked);
							}
							if (selectedShip!= null && selectedShip.shipType == ShipTypes.DESTROYER)
							{
								AAfire(selectedShip, gridCellClicked);
							}
						}
					}
				}
			}
		}
		
		public function launchFighter(launchingCarrier:Carrier, fighter:Fighter, gridCell:GridCell):void 
		{
			placeShip(fighter, gridCell.coordinates.x, gridCell.coordinates.y);
			pushShip(fighter)
			
			resetFog();
			
			//update carrier
			launchingCarrier.launchFighter();
			launchingCarrier.performedAction = true;
			
			if (currentPlayer == CurrentPlayer.PLAYER)
			{
				GUI.updateShipStatus(selectedShip, phase);
				isSelectionLocked = true;
				updateSelection(false);
			}
							
			//remove highlights
			resetHighlight();
			//reset boolean
			fighterAwaitingPlacement = false;
		}
		

		
		public function validCell(gridCellClicked:GridCell):Boolean
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
		public function getGridCellFromClick(x:int, y:int):GridCell
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
		
		
		//TODO half alpha for cells in range.  full alpha for cells that are valid
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
					
					if (rangeToSquare <= range)
					{
						
						//if moving, highlight all unoccupied
						if (type == highlightTypes.MOVE)
						{
							if (!cellToCheck.occupied)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else 
							{
								cellToCheck.drawHighlight(false);
							}
						}
						else if (type == highlightTypes.FIRE)
						{
							// if firing hilight all squares not occupied by own team or any fighters
							if ( cellToCheck.occupied && cellToCheck.occupyingShip.team != ship.team 
								&& cellToCheck.occupyingShip.shipType!=ShipTypes.FIGHTER)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else 
							{
								cellToCheck.drawHighlight(false);
							}
						}
						else if (type==highlightTypes.FIGHTER_FIRE )
						{
							if (cellToCheck.occupied && cellToCheck.occupyingShip.team != ship.team)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else 
							{
								cellToCheck.drawHighlight(false);
							}
						}
						
						else if (type == highlightTypes.FIGHTER_PLACE)
						{
							if (!cellToCheck.occupied)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else 
							{
								cellToCheck.drawHighlight(false);
							}
						}
						
						else if (type == highlightTypes.FIGHTER_MOVE)
						{
							if (!cellToCheck.occupied)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else if (cellToCheck.occupied && cellToCheck.occupyingShip.shipType == ShipTypes.CARRIER)
							{
								if (currentPlayer == CurrentPlayer.PLAYER && cellToCheck.occupyingShip.team == 1)
								{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
								}
								else if (currentPlayer == CurrentPlayer.COMPUTER && cellToCheck.occupyingShip.team == 2)
								{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
								}
							}
							else 
							{
								cellToCheck.drawHighlight(false);
							}
						}
						else if (type == highlightTypes.BOMBARD)
						{
							if (cellToCheck.occupied && cellToCheck.occupyingShip.team != ship.team 
								&& cellToCheck.occupyingShip.shipType!=ShipTypes.FIGHTER)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else 
							{
								cellToCheck.drawHighlight(false);
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
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else 
							{
								cellToCheck.drawHighlight(false);
							}
						}
						else if (type == highlightTypes.COMPUTER_PLACE)
						{
							if (cellToCheck.coordinates.y <= 1)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else 
							{
								cellToCheck.drawHighlight(false);
							}
						}
						else if (type == highlightTypes.PLAYER_PLACE)
						{
							if (cellToCheck.coordinates.y >= 9)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							else 
							{
								cellToCheck.drawHighlight(false);
							}
						}
					}
				}
				
			}
			
			return returnList;
		}
		
		//TODO reset alpha value
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
		public function updateSelection(recoveringFighter:Boolean):void
		{
			selectedShip.updateStatus();
			
			//only when ship finished
			if (selectedShip.turnCompleted)
			{
				GUI.eraseCurrentStatus();
				selectedShip = null;
				if (!recoveringFighter)
				{
					whoGetsNextTurn(false);
				}
			}
		}
		
		public function computerTurn():void 
		{
			if (currentPlayer == CurrentPlayer.COMPUTER)
			{
				opponent.takeTurn();
			}
			
			whoGetsNextTurn(false);
		}
		
		// TODO add find subs call here...
		private function whoGetsNextTurn(recoveredFighterThisTurn:Boolean):void
		{
			var nextPlayer:String = gameTurnManager.determineNextPlayer(shipsInPlay, currentPlayer, recoveredFighterThisTurn);
			
			//check for subs to reveal any that might have wandered over into a visible square.  This, along with movement, are the only
			//time the visible state of the sub can change
			var shipToCheck:ShipBase;
			for (var i:int = shipsInPlay.length - 1; i >= 0; i--)
			{
				shipToCheck = shipsInPlay[i];
				
				if (shipToCheck.shipType == ShipTypes.DESTROYER || shipToCheck.shipType == ShipTypes.SUBMARINE)
				{
					checkForRevealedSubs(shipToCheck, grid[shipToCheck.location.x][shipToCheck.location.y]);
				}
			}
			
			if (nextPlayer == CurrentPlayer.COMPUTER)
			{
				setTurnPriority(CurrentPlayer.COMPUTER)
				utilities.pause(1, computerTurn);
				//computerTurn();
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
				whoGetsNextTurn(false);
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
		
		public function resetFog():void
		{
			var cellToCheck:GridCell;
			var range:Number;
			
			var playerShips:Vector.<ShipBase> = new Vector.<ShipBase>();
			//filter out enemy ships
			
			for (var i:int = 0; i <= shipsInPlay.length - 1; i++)
			{
				if (shipsInPlay[i].team == 1)
				{
					playerShips.push(shipsInPlay[i]);
				}
			}
			
			for (var x:int = 0; x <= gridWidth-1; x++)
			{
				for (var y:int = 0; y <= gridHeight-1; y++)
				{
					cellToCheck = grid[x][y];
					for (var shipIndex:int = 0; shipIndex <= playerShips.length - 1; shipIndex++)
					{
						//show fog again
						cellToCheck.showFog();
						
						range = playerShips[shipIndex].getRangeToSquare(cellToCheck);
						if (range <= playerShips[shipIndex].visibilityRange)
						{
							cellToCheck.hideFog();
							break;
						}
					}
					
				}
			}
		}
	
		/*resets all variables associated with the game.  Called on exit/enter or other times
		 * when current info needs to be trashed
		 * */
		public function reset():void
		{
			//rebuild grid from scratch
			grid = [];
			initializeGrid();
		
			shipsStarting = new Vector.<ShipBase>();
			
			for (var i:int = shipsInPlay.length - 1; i >= 0; i--)
			{
				killShip(shipsInPlay[i]);
			}
			shipsInPlay = new Vector.<ShipBase>();
		
			fighterAwaitingPlacement = false;
		
			selectedShip = null;
			isAShipSelected = false;
			isSelectionLocked = false;
			shipMoving = false;
			shipFiring = false;
			shipActioning = false;
			
			GUI.eraseCurrentStatus();
			GUI.switchToPregamePhase();
		
			currentPlayer = CurrentPlayer.PLAYER;
			phase= GamePhase.PLACEMENT_PHASE;
		}
		
		
		// TODO: Restart function, using the current initial ship set
	
	}

}