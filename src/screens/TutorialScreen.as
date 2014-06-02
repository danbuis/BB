package screens 
{
	import flash.geom.Point;
	import managers.TutorialManager;
	import managers.utilities;
	import playArea.CurrentPlayer;
	import playArea.GridCell;
	import ships.ShipBase;
	import ships.TorpedoBoat;
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
		private var clickHere:Image;
		
		public function TutorialScreen() 
		{
			super();
			updateTutorial();
			
			phase = GamePhase.PLAY_PHASE;
			
			resetHighlight()
			
			/*var newShip:ShipBase = new TorpedoBoat(1)
			placeShip(newShip, 4, 8);
			pushShip(newShip);
			
			resetFog();
			
			newShip = new TorpedoBoat(2);
			placeShip(newShip, 4, 0);
			pushShip(newShip);*/
			
	
	
			
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
				
				GUI.moveButton.addEventListener(Event.TRIGGERED, onTutorialMoveButtonClick);
			}
			
			else if (thisStep == "attack enemy")
			{
				this.removeChild(message);
				message = manager.getMessageScreen(3);
				message.x = ((this.width- GUI.width) / 2) - (message.width / 2) ;
				message.y = 100;
				this.addChild(message);
				
				this.removeChild(clickHere);
			}
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
								
								utilities.pause(1.5, updateTutorial);
			
							}
			
						}
					}
				}
			}
			return false;
		}
	}

}