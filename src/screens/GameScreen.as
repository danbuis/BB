package screens
{
	import events.BBAnimationEvents;
	import events.BBNavigationEvent;
	import FGL.GameTracker.GameTracker;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
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
	import ships.PatrolBoat;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author dan
	 */
	public class GameScreen extends BaseScreen
	{
		public var backgroundImage:GameGrid;
		
		// grid information, uses center of grid cell
		public var grid:Array = [];
		private var gridWidth:int = 13;
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
		
		public var winner:TextField;
		
		private var mcToRemove:Vector.<MovieClip> = new Vector.<MovieClip>();
		public var firingShip:ShipBase;
		public var actioningShip:ShipBase;
		
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
			
			GUI.lower_GUI.touchable = true;
			GUI.lower_GUI.addEventListener(TouchEvent.TOUCH, clickHandler);
			
			opponent = new AI(this);
			
			this.addChild(opponent);
			
			winner = new TextField(300, 100, "", "ARMY RUST", 70, 0xffffff);
			winner.x = (this.width - winner.width) / 2;
			winner.y= (this.height - winner.height) / 2;
			winner.visible = false;
			
			this.addEventListener(BBAnimationEvents.DONE_MOVING, doneMovingEvent);
			this.addEventListener(BBAnimationEvents.DONE_FIRING, doneFiringEvent);
			this.addEventListener(BBAnimationEvents.DONE_ACTIONING, doneActionEvent);
			this.addEventListener(BBAnimationEvents.DONE_TURN, doneTurnEvent);
			
			trace("gamescreen initialized");
		}
		
		private function doneTurnEvent(e:BBAnimationEvents):void 
		{
			trace("done turn event recieved");
			
			var fighterRecovered:Boolean = e.data.fighterRecover;
			
			whoGetsNextTurn(fighterRecovered);
		}
		
		private function doneActionEvent(e:BBAnimationEvents):void 
		{
			trace("done action event recieved");
			var shipInEvent:ShipBase = e.data.ship;
			if (shipInEvent.team != 1)
			{
				opponent.cleanUpEvent(e);
			}
		}
		
		private function doneFiringEvent(e:BBAnimationEvents):void 
		{
			trace("done fire event recieved");
			var shipInEvent:ShipBase = e.data.ship;
			if (shipInEvent.team != 1)
			{
				opponent.handleAfterFireEvent(e);
			}
		}
		
		private function doneMovingEvent(e:BBAnimationEvents):void 
		{
			trace("done move event recieved");
			var shipInEvent:ShipBase = e.data.ship;
			if (shipInEvent.team != 1)
			{
				opponent.handleAfterMoveEvent(e);
			}
			
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
						shipToAdd = new PatrolBoat(1);
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
						shipToAdd = new PatrolBoat(2);
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
			
			GUI = new ControlBar(this);
			this.addChild(GUI);
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
			GUI.doneButton.addEventListener(Event.TRIGGERED, onDoneButtonClick);
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
		public function onDoneButtonClick(e:Event):void 
		{
			if (phase == GamePhase.PLACEMENT_PHASE)
			{
				phase = GamePhase.PLAY_PHASE;
				GUI.switchToPlayPhase();
				resetHighlight()
				turnIsComplete();
			}
			else
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
						GameTracker.api.alert("fighter out of fuel", fighter.team);
					}
				}
				else if (shipsInPlay[i].shipType == ShipTypes.SUBMARINE)
				{
					var submarine:Submarine = shipsInPlay[i] as Submarine;
					
					var gridOfSub:GridCell = grid[submarine.location.x][submarine.location.y];
					
					if (submarine.submerged == true)
					if (submarine.numberOfDivesRemaining > 0)
					{
						submarine.numberOfDivesRemaining--;
						//trace("revealed from turn is complete");
						//submarine.submerged = false;
						//submarine.alpha = 1.0;
						//submarine.visible = true;
					}
					else
					{
						submarine.submerged = false;
						submarine.alpha = 1.0;
						submarine.visible = true;
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
				//surface...
				if (selectedSub.submerged)
				{
					AnimationManager.submarineVisibility(selectedSub, true);
					selectedSub.submerged = false;
					
					selectedShip.performedAction = true;
					GUI.updateShipStatus(selectedShip, phase);
					
					isSelectionLocked = true;
					updateSelection(false);
				}
				//dive...
				else if (selectedSub.numberOfDivesRemaining > 0)
				{
					GameTracker.api.alert("player submerged sub");
					
					AnimationManager.submarineVisibility(selectedSub, false);
					
					//selectedSub.alpha = 0.2;
					//selectedSub.numberOfDivesRemaining--;
					selectedSub.submerged = true;
					
					selectedShip.performedAction = true;
					GUI.updateShipStatus(selectedShip, phase);
					
					isSelectionLocked = true;
					updateSelection(false);
					
				}
			}
			
			actioningShip = selectedSub;
				
				var actionEventTimer:Timer = new Timer(1300, 1);
					actionEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchActionEvent);
					actionEventTimer.start();
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
					
					//call animation sequence.
					(ship as Fighter).landFighterAnimation((gridCell.occupyingShip as Carrier));
					//backgroundImage.removeChild(ship);
					
					//remove from ships in play
					var index:int = shipsInPlay.indexOf(ship);
					shipsInPlay.splice(index, 1);
			
					//tells current gridcell it has left
					grid[ship.location.x][ship.location.y].shipLeaves();
					
					if (currentPlayer == CurrentPlayer.COMPUTER)
					{
						var test:int = 0;
					}
				
					//trace("attempting fighter recovery for team: " +ship.team);
					GameTracker.api.alert("attempting fighter recovery", ship.team);
					if (currentPlayer == CurrentPlayer.PLAYER && ship.team == 1)
					{
					//	trace("in player block");
					//	GameTracker.api.alert("player fighter recovered", selectedShip.team);
						//housekeeping to reset GUI
						selectedShip.moved = true;
						selectedShip.fired = true;
						selectedShip.turnCompleted = true;
						GUI.eraseCurrentStatus();
						updateSelection(true);
						isAShipSelected = false;
						whoGetsNextTurn(true);
					}
					//trace("fighter recovered");
					GameTracker.api.alert("fighter recovered");
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
					ship.moveAndRotateShip(tweenX, tweenY, range, true);
					
				}
				//trace("ship moved");
				
				
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
					//trace("called at move");
					checkForRevealedSubs(ship, gridCell);
				}
				resetFog();
				return true;


			}
			else
			{
				//trace("ship can't move that far");
				return false;
			}
		}
		
		//ship is ship to use
		private function checkForRevealedSubs(ship:ShipBase, gridCell:GridCell):void 
		{
			//trace("checking for subs with "+ship);
			//look at each ship
			var shipToCheck:ShipBase;
			var revealedSub:Submarine;
			for (var i:int = shipsInPlay.length-1; i >= 0; i--)
			{
				shipToCheck = shipsInPlay[i];
				//look for submarines on the other team
				if (shipToCheck.shipType == ShipTypes.SUBMARINE && shipToCheck.team != ship.team)
				{
					
					//check if they are close enough
					var range:Number = shipToCheck.getRangeToSquare(gridCell);
					//trace("Range: " + range);
					if (range <= 1.6)
					{
						//trace("revealed with " + ship);
						revealedSub = shipToCheck as Submarine;
						revealedSub.submerged = false;
						AnimationManager.submarineVisibility(revealedSub, true);
					}
				}
			}
		}
		
		
		//handles a ship firing on another.
		public function fireShip(ship:ShipBase, gridCell:GridCell):void
		{
			
			if (gridCell.isHighlighted() && gridCell.occupied && gridCell.occupyingShip.team != ship.team)
			{
				if (gridCell.occupied)
				{
					damageShip(gridCell.occupyingShip);
					
					firingShip = ship;
					
					var fireEventTimer:Timer = new Timer(1100, 1);
					fireEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchFireEvent);
					fireEventTimer.start();
				}
				
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
				

				resetHighlight();
				
				
				
			}
			
		}
		
		private function dispatchFireEvent(e:TimerEvent):void 
		{
			trace("dispatching fire event");
			this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_FIRING, true, { ship:firingShip } ));
		}
		
		private function dispatchActionEvent(e:TimerEvent):void 
		{
			trace("dispatching action event from ship:"+actioningShip);
			this.dispatchEvent(new BBAnimationEvents(BBAnimationEvents.DONE_ACTIONING, true, { ship:actioningShip } ));
		}
		
		
		//handles BB using its action
		public function bombardShip(selectedShip:ShipBase, gridCell:GridCell):void 
		{
			if (gridCell.isHighlighted() && gridCell.occupied && gridCell.occupyingShip.team != selectedShip.team)
			{
				//trace("bombarding");
				actioningShip = selectedShip;
				
				var actionEventTimer:Timer = new Timer(1300, 1);
					actionEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchActionEvent);
					actionEventTimer.start();

				damageShip(gridCell.occupyingShip);
				
				
				if (currentPlayer == CurrentPlayer.PLAYER && selectedShip.team == 1)
				{
					GameTracker.api.alert("bombarding", selectedShip.team);
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
				
				actioningShip = selectedShip;
				
				var actionEventTimer:Timer = new Timer(1300, 1);
					actionEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dispatchActionEvent);
					actionEventTimer.start();
				
				
				if (currentPlayer == CurrentPlayer.PLAYER && selectedShip.team == 1)
				{
					GameTracker.api.alert("AA fire", selectedShip.team);
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
				return;
			}
			
			var shootExplosion:MovieClip = new MovieClip(Assets.getAtlas().getTextures("Explosions/fire_"), 12);
			shootExplosion.x = ship.x;
			shootExplosion.y = ship.y;
			shootExplosion.loop = false;
			
			this.addChild(shootExplosion);
			
			AnimationManager.explosionAnimation(ship.x, ship.y, shootExplosion);
			
			mcToRemove.push(shootExplosion);
			
			var removeExplosionTimer:Timer = new Timer(1500, 1);
			removeExplosionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, emptyExplosionMCs);
			removeExplosionTimer.start();
			
		}
		
		private function killShip(ship:ShipBase):void
		{
			var deathExplosion:MovieClip = new MovieClip(Assets.getAtlas().getTextures("Explosions/death_"), 12);
			deathExplosion.x = ship.x;
			deathExplosion.y = ship.y;
			deathExplosion.loop = false;
			
			this.addChild(deathExplosion);
			
			AnimationManager.explosionAnimation(ship.x, ship.y, deathExplosion);
			
			mcToRemove.push(deathExplosion);
			
			var removeExplosionTimer:Timer = new Timer(1500, 1);
			removeExplosionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, emptyExplosionMCs);
			removeExplosionTimer.start();
			
			//remove ship from background object
			backgroundImage.removeChild(ship);
			
			//remove from ships in play
			var index:int = shipsInPlay.indexOf(ship);
			shipsInPlay.splice(index, 1);
			
			//tells current gridcell it has left
			grid[ship.location.x][ship.location.y].shipLeaves();
			
			//garbage collection
			ship.dispose();
		
		}
		
		private function emptyExplosionMCs(e:TimerEvent):void 
		{
			while (mcToRemove.length != 0)
			{
				var mc:MovieClip = mcToRemove.pop();
				this.removeChild(mc);
				mc.dispose();
			}
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
					else if (selectedShip != null && selectedShip.shipType == ShipTypes.FIGHTER && shipMoving
					&& gridCellClicked.occupied && gridCellClicked.occupyingShip.shipType==ShipTypes.CARRIER)
					{
						//will move the ship onto a carrier
						moveShip(selectedShip, gridCellClicked);
					}
					
					
					//check if cell has a friendly ship that can be selected
				
					else if (gridCellClicked.occupied && gridCellClicked.occupyingShip.team == 1 && !isSelectionLocked)
					{
						// if on your team select the ship
						selectedShip = gridCellClicked.occupyingShip;
						isAShipSelected = true;
						GUI.updateShipStatus(selectedShip, phase);
						resetHighlight();	
					}
					//else if occupied by enemy ship
					else if (gridCellClicked.occupied && gridCellClicked.occupyingShip.team != 1 && !shipActioning && !shipFiring)
					{
						GUI.displayEnemyStatus(gridCellClicked.occupyingShip);
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
			
			
			
			
			//update carrier
			launchingCarrier.launchFighter(fighter, gridCell, this);
			launchingCarrier.performedAction = true;

			
			
			if (currentPlayer == CurrentPlayer.PLAYER)
			{
				GUI.updateShipStatus(selectedShip, phase);
				isSelectionLocked = true;
				updateSelection(false);
				GameTracker.api.alert("launch fighter");
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
			if (returnX < gridWidth && returnY < gridHeight && returnX >= 0 && returnY >= 0)
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
								&& cellToCheck.occupyingShip.shipType != ShipTypes.FIGHTER
								&& cellToCheck.fog.alpha == 0 )
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
							if (cellToCheck.coordinates.y >= 8)
							{
								cellToCheck.drawHighlight(true);
								returnList.push(cellToCheck);
							}
							/*else 
							{
								cellToCheck.drawHighlight(false);
							}*/
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
			
		}
		
		
		private function whoGetsNextTurn(recoveredFighterThisTurn:Boolean):void
		{
			var nextPlayer:String = gameTurnManager.determineNextPlayer(shipsInPlay, currentPlayer, recoveredFighterThisTurn);
			GameTracker.api.alert("next player result", 0, nextPlayer);
			
			
		//change GUI light
		GUI.changePlayerIndicatorLight(nextPlayer);
			
		// TODO on win/lose, remove main menu event listener, add return to main menu button.
			if (nextPlayer==CurrentPlayer.PLAYER_WIN)
			{
				winner.visible = true;
				winner.text = "you win";
				this.addChild(winner);
				
				GameTracker.api.alert("win");
				
				return;
			}
			if (nextPlayer == CurrentPlayer.COMPUTER_WINS)
			{
				winner.visible = true;
				winner.text = "you lose";
				this.addChild(winner);
				
				GameTracker.api.alert("lose");
				
				return;
			}
			
			
			
			
			//check for subs to reveal any that might have wandered over into a visible square.  This, along with movement, are the only
			//time the visible state of the sub can change
			var shipToCheck:ShipBase;
			for (var i:int = shipsInPlay.length - 1; i >= 0; i--)
			{
				shipToCheck = shipsInPlay[i];
				
				if (shipToCheck.shipType == ShipTypes.DESTROYER || shipToCheck.shipType == ShipTypes.SUBMARINE)
				{
					//trace("called at next turn");
					checkForRevealedSubs(shipToCheck, grid[shipToCheck.location.x][shipToCheck.location.y]);
				}
			}
			
			if (nextPlayer == CurrentPlayer.COMPUTER)
			{
				setTurnPriority(CurrentPlayer.COMPUTER)
				utilities.pause(1, computerTurn);
				
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
			isSelectionLocked = false;
			selectedShip = null;
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
			//TODO, check if necessary.
			//rebuild grid from scratch
			//grid = [];
			//initializeGrid();
		
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
			phase = GamePhase.PLACEMENT_PHASE;
			
			winner.visible = false;
		}
		
		
		//Restart function, using the current initial ship set
		
		public function restart():void
		{
			//store starting ships
			var shipsToRestartWith:Vector.<ShipBase> = shipsStarting;
			
			reset();
			
			shipsInPlay = shipsToRestartWith;
			shipsStarting = shipsToRestartWith;
			
			var shipArrayToStart:Array = convertVectorToInt(shipsStarting);
			
			resetFog();
			resetHighlight();
			
			addShips(shipArrayToStart);
			
		}
		
		
		private function convertVectorToInt(shipVector:Vector.<ShipBase>):Array
		{
			var returnArray:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			
			var shipToCheck:ShipBase;
			for (var i:int = 0; i <= shipVector.length - 1; i++)
			{
				shipToCheck = shipVector[i];
				if (shipToCheck.shipType == ShipTypes.CARRIER)
				{
					if (shipToCheck.team == 1)
					{
						returnArray[0]++;
					}
					else
					{
						returnArray[5]++;
					}
				}
				else if (shipToCheck.shipType == ShipTypes.BATTLESHIP)
				{
					if (shipToCheck.team == 1)
					{
						returnArray[1]++;
					}
					else
					{
						returnArray[6]++;
					}
				}
				else if (shipToCheck.shipType == ShipTypes.SUBMARINE)
				{
					if (shipToCheck.team == 1)
					{
						returnArray[2]++;
					}
					else
					{
						returnArray[7]++;
					}
				}
				else if (shipToCheck.shipType == ShipTypes.DESTROYER)
				{
					if (shipToCheck.team == 1)
					{
						returnArray[3]++;
					}
					else
					{
						returnArray[8]++;
					}
				}
				else if(shipToCheck.shipType == ShipTypes.PATROL_BOAT)
				{
					if (shipToCheck.team == 1)
					{
						returnArray[4]++;
					}
					else
					{
						returnArray[9]++;
					}
				}
			}
			
			return returnArray;
		}
	
	}

}