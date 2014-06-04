package screens 
{
	import flash.geom.Point;
	import managers.TutorialManager;
	import managers.utilities;
	import playArea.CurrentPlayer;
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
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author ...
	 */
	public class TutorialScreen extends GameScreen 
	{
		private var learning:Boolean = true;
		private var thisStep:String = "select torpedo boat";
		private var manager:TutorialManager = new TutorialManager();
		private var message:Image;
		private var reinforcementMessage:Image = manager.getMessageScreen(4);
		private var clickHere:Image;
		private var clickDown:Image = new Image(Assets.getAtlas().getTexture("click_down"));
		private var clickContinue:Button = new Button(Assets.getAtlas().getTexture("continue"));
		
		
		//TODO reset not working.  look in game, perhaps just construct a new screen...
		public function TutorialScreen() 
		{
			super();
			updateTutorial();
			
			phase = GamePhase.PLAY_PHASE;
			
			resetHighlight()
						
			backgroundImage.removeEventListener(TouchEvent.TOUCH, clickHandler);
			backgroundImage.addEventListener(TouchEvent.TOUCH, clickHandlerTutorial);
			GUI.switchToPlayPhase();
			
		}
		
		private function updateTutorial():void 
		{
			if (thisStep == "select torpedo boat")
			{
				message = manager.getMessageScreen(1);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
				
				clickHere = new Image(Assets.getAtlas().getTexture("click_down"));
				clickHere.x = 270 - clickHere.width;
				clickHere.y = this.height - 120 - clickHere.height;
				this.addChild(clickHere);
				

			}
			else if (thisStep == "move torpedo boat")
			{
				this.removeChild(message);
				message = manager.getMessageScreen(2);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
				
				this.removeChild(clickHere);
				clickHere = new Image(Assets.getAtlas().getTexture("click_right"));
				clickHere.x = 510-clickHere.width;
				clickHere.y = 255 - (clickHere.height / 2);
				this.addChild(clickHere);
				
				var newShip:ShipBase;
				newShip = new TorpedoBoat(2);
				placeShip(newShip, 4, 0);
				pushShip(newShip);
				resetFog();
				newShip.hit();
				
				GUI.moveButton.addEventListener(Event.TRIGGERED, onTutorialMoveButtonClick);
			}
			
			else if (thisStep == "attack enemy")
			{
				this.removeChild(message);
				message = manager.getMessageScreen(3);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 400;
				this.addChild(message);
				
				this.removeChild(clickHere);
				clickHere.visible = false;
				
				//add a few enemies
				
				//TODO enemies visible above fog, fix
			var enemyBB:ShipBase = new Battleship(2);
			placeShip(enemyBB, 1, 0);
			pushShip(enemyBB);
			
			var enemyTorp:ShipBase = new TorpedoBoat(2);
			placeShip(enemyTorp, 4, 0);
			pushShip(enemyTorp);
			
			var enemyDD:ShipBase = new Destroyer(2);
			placeShip(enemyDD, 7, 1);
			pushShip(enemyDD);
			
			var enemyCarrier:ShipBase = new Carrier(2);
			placeShip(enemyCarrier, 8, 0);
			pushShip(enemyCarrier);
			}
			else if (thisStep == "reinforcements arrive")
			{
				this.removeChild(message);
				reinforcementMessage.x = ((this.width- GUI.width) / 2) - (reinforcementMessage.width / 2) ;
				reinforcementMessage.y = 100;
				this.addChild(reinforcementMessage);
				
				//add reinforcements
				var newCarrer:ShipBase = new Carrier(1);
				var newBB:ShipBase = new Battleship(1);
				var newSub:ShipBase = new Submarine(1);
				var newDD:ShipBase = new Destroyer(1);
				
				placeShip(newCarrer, 2, 8);
				pushShip(newCarrer);
				placeShip(newBB, 4, 8);
				pushShip(newBB);
				placeShip(newSub, 6, 8);
				pushShip(newSub);
				placeShip(newDD, 8, 8);
				pushShip(newDD);
				resetFog();
				
				this.addChild(clickDown);
				clickDown.x = 140 - clickDown.width / 2;
				clickDown.y = this.height - 120 - clickDown.height;
				
				
			}
			
			else if (thisStep == "carrier")
			{
				clickDown.visible = false;
				this.removeChild(reinforcementMessage);
				message = manager.getMessageScreen(5);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
			}
			else if (thisStep == "fighter1")
			{
				this.removeChild(message);
				message = manager.getMessageScreen(6);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
				
				clickDown.visible = false;
			}
			else if (thisStep == "fighter2")
			{
				this.removeChild(message);
				message = manager.getMessageScreen(7);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
				
				clickDown.visible = true;
				clickDown.x = 220 - clickDown.width / 2;
			}
			else if (thisStep == "BB")
			{
				this.removeChild(message);
				message = manager.getMessageScreen(9);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
				
				
				clickDown.x = 300 - clickDown.width / 2;
			}
			else if (thisStep == "sub")
			{
				this.removeChild(message);
				message = manager.getMessageScreen(8);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
				
				
				clickDown.x = 380 - clickDown.width / 2;
			}
			else if (thisStep == "DD")
			{
				this.removeChild(message);
				message = manager.getMessageScreen(10);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
				
				clickDown.visible = false;
				this.addChild(clickContinue);
				clickContinue.x = message.x;
				clickContinue.y = message.y+ message.height;
				clickContinue.addEventListener(Event.TRIGGERED, onContiue);
			}
			
			
		}
		
		private function onContiue(e:Event):void 
		{
			clickContinue.visible = false;
			
			this.removeChild(message);
			message = manager.getMessageScreen(11);
			message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
			message.y = 100;
			this.addChild(message);
				
			highlightRange(20, shipsInPlay[0], highlightTypes.PLAYER_PLACE);
			
			//TODO reset back to original click handler.
			phase = GamePhase.PLACEMENT_PHASE;
			
			backgroundImage.removeEventListener(TouchEvent.TOUCH, clickHandlerTutorial);
			backgroundImage.addEventListener(TouchEvent.TOUCH, clickHandler);
			
			GUI.startGameButton.addEventListener(Event.TRIGGERED, onTutorialStart);
			
		}
		
		private function onTutorialStart(e:Event):void 
		{
			message.visible = false;
		}
		
		
		
		private function onTutorialMoveButtonClick(e:Event):void 
		{
			clickHere.x = 100;
			clickHere.y = 240-(clickHere.height/2);
			this.addChild(clickHere);
			this.removeChild(message);
			
		}
		
		private function clickHandlerTutorial(event:TouchEvent):Boolean
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if (touch)
			{

				var touchPosition:Point = touch.getLocation(this);
				var gridCellClicked:GridCell = getGridCellFromClick(touchPosition.x, touchPosition.y);
				
				//verify that the click is on the grid
				if (validCell(gridCellClicked) && currentPlayer==CurrentPlayer.PLAYER)
				{
				
					//only use this part if still learning
					if (learning)
					{
						if (thisStep == "select torpedo boat")
						{
							if (gridCellClicked.occupied)
							{
								isAShipSelected = true;
								selectedShip = gridCellClicked.occupyingShip;
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								
								thisStep = manager.getNextStep(thisStep);
								updateTutorial();
								return true;
							}
						}
						else if (thisStep == "move torpedo boat")
						{
							if (gridCellClicked.coordinates.x == 4 && gridCellClicked.coordinates.y == 5)
							{
								thisStep = manager.getNextStep(thisStep);
								
								moveShip(selectedShip, gridCellClicked);
								selectedShip.fired = true;
								selectedShip.updateStatus();
								updateSelection(false);
								selectedShip = shipsInPlay[0];
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								
								utilities.pause(2, updateTutorial);
								
								isAShipSelected = true;
								selectedShip = gridCellClicked.occupyingShip;
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								return true;
							}	
						}
						else if (thisStep == "attack enemy")
						{
							if (gridCellClicked.occupied && gridCellClicked.occupyingShip.team == 1)
							{
								isAShipSelected = true;
								selectedShip = gridCellClicked.occupyingShip;
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
							}
							else if (gridCellClicked.occupied && shipFiring)
							{
								fireShip(selectedShip, gridCellClicked);
								thisStep = manager.getNextStep(thisStep);
								utilities.pause(2, updateTutorial);
							}
							else
							{
								//try moving
								moveShip(selectedShip, gridCellClicked);
							}
							return true;
						}
						else if (thisStep == "reinforcements arrive")
						{
							if (gridCellClicked.occupied && gridCellClicked.occupyingShip.shipType == ShipTypes.CARRIER)
							{
								isAShipSelected = true;
								selectedShip = gridCellClicked.occupyingShip;
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								
								thisStep = manager.getNextStep(thisStep);
								updateTutorial();
								return true;
							}
						}
						else if (thisStep == "carrier")
						{
							if (gridCellClicked.isHighlighted())
							{
								launchFighter(selectedShip as Carrier, new Fighter(1), gridCellClicked);
				
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								thisStep = manager.getNextStep(thisStep);
								updateTutorial();
								return true;
							}
						}
						else if (thisStep == "fighter1")
						{
							if (gridCellClicked.occupied && gridCellClicked.occupyingShip.shipType == ShipTypes.FIGHTER)
							{
								isAShipSelected = true;
								selectedShip = gridCellClicked.occupyingShip;
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								resetHighlight();
							}
							else if (gridCellClicked.occupied && gridCellClicked.occupyingShip.shipType == ShipTypes.CARRIER && selectedShip.shipType == ShipTypes.FIGHTER)
							{
								moveShip(selectedShip, gridCellClicked);
								thisStep = manager.getNextStep(thisStep);
								updateTutorial();
							}
						}
						else if (thisStep == "fighter2")
						{
							if (gridCellClicked.occupied && gridCellClicked.occupyingShip.shipType==ShipTypes.BATTLESHIP)
							{
								isAShipSelected = true;
								selectedShip = gridCellClicked.occupyingShip;
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								
								thisStep = manager.getNextStep(thisStep);
								updateTutorial();
								return true;
							}
						}
						else if (thisStep == "BB")
						{
							if (gridCellClicked.occupied && gridCellClicked.occupyingShip.shipType==ShipTypes.SUBMARINE)
							{
								isAShipSelected = true;
								selectedShip = gridCellClicked.occupyingShip;
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								
								thisStep = manager.getNextStep(thisStep);
								updateTutorial();
								return true;
							}
						}
						else if (thisStep == "sub")
						{
							if (gridCellClicked.occupied && gridCellClicked.occupyingShip.shipType==ShipTypes.DESTROYER)
							{
								isAShipSelected = true;
								selectedShip = gridCellClicked.occupyingShip;
								GUI.updateShipStatus(selectedShip, GamePhase.PLAY_PHASE);
								
								thisStep = manager.getNextStep(thisStep);
								updateTutorial();
								return true;
							}
						}
						
					}
				}
			}
			return false;
		}
		
		public function resetTutorial():void
		{
			this.removeChild(message);
			thisStep = "select torpedo boat";
		
			updateTutorial();
					
			backgroundImage.removeEventListener(TouchEvent.TOUCH, clickHandler);
			backgroundImage.addEventListener(TouchEvent.TOUCH, clickHandlerTutorial);
		}
	}

}