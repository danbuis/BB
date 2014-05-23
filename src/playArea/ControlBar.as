package playArea 
{
	import flash.geom.Point;
	import ships.Carrier;
	import ships.ShipBase;
	import ships.ShipTypes;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author dan
	 */
	public class ControlBar extends Sprite 
	{
		
		private var backgroundImage:Image;
		// TODO: use origin... trickles down into initialize...
		private var iconOrigin:Point;
		
		private var battlshipIcon:Image;
		private var carrierIcon:Image;
		private var fighterIcon:Image;
		
		public var moveButton:Button;
		public var fireButton:Button;
		public var bombardButton:Button;
		public var launchFighterButton:Button;
		public var submergeButton:Button;
		public var AAfireButton:Button;
		
		private var shipType:TextField;
		private var shipHealth:TextField;
		
		private var moveButtonMask:Image;
		private var fireButtonMask:Image;
		private var actionButtonMask:Image;
		
		private var storedFighter1:Image;
		private var storedFighter2:Image;
		private var storedFighter3:Image;
		
		public var shipCompleteButton:Button;
		public var turnCompleteButton:Button;
		
		
		public function ControlBar() 
		{
			super();
			initializeGUI();
			
		}
		
		private function initializeGUI():void 
		{
			backgroundImage = new Image(Assets.getAtlas().getTexture("GUI/GUI_background"));
			this.addChild(backgroundImage);
			
			//initialize icons
			battlshipIcon = new Image(Assets.getAtlas().getTexture("GUI/BB_icon"));
			battlshipIcon.visible = false;
			battlshipIcon.x = this.width / 2 - battlshipIcon.width / 2;
			battlshipIcon.y = 100;
			this.addChild(battlshipIcon);
			
			carrierIcon = new Image(Assets.getAtlas().getTexture("GUI/carrier_icon"));
			carrierIcon.visible = false;
			carrierIcon.x = this.width / 2 - carrierIcon.width / 2;
			carrierIcon.y = 100;
			this.addChild(carrierIcon);
			
			fighterIcon = new Image(Assets.getAtlas().getTexture("GUI/fighter_icon"));
			fighterIcon.visible = false;
			fighterIcon.x = this.width / 2 - fighterIcon.width / 2;
			fighterIcon.y = 100;
			this.addChild(fighterIcon);
			
			//initialize buttons
			moveButton = new Button(Assets.getAtlas().getTexture("Buttons/move_button"));
			moveButton.x = backgroundImage.width * 0.2
			moveButton.y = 240;
			moveButton.visible = false;
			this.addChild(moveButton);
			
			fireButton = new Button(Assets.getAtlas().getTexture("Buttons/fire_button"));
			fireButton.x = backgroundImage.width * 0.5
			fireButton.y = moveButton.y;
			fireButton.visible = false;
			this.addChild(fireButton);
			
			bombardButton = new Button(Assets.getAtlas().getTexture("Buttons/bombard_button"));
			bombardButton.x = backgroundImage.width * 0.8
			bombardButton.y = moveButton.y;
			bombardButton.visible = false;
			this.addChild(bombardButton);
			
			launchFighterButton = new Button(Assets.getAtlas().getTexture("Buttons/launch_fighter_button"));
			launchFighterButton.x = bombardButton.x
			launchFighterButton.y = moveButton.y;
			launchFighterButton.visible = false;
			this.addChild(launchFighterButton);
			
			submergeButton = new Button(Assets.getAtlas().getTexture("Buttons/submerge_button"));
			submergeButton.x = bombardButton.x;
			submergeButton.y = moveButton.y;
			submergeButton.visible = false;
			this.addChild(submergeButton);
			
			AAfireButton = new Button(Assets.getAtlas().getTexture("Buttons/AA_fire_button"));
			AAfireButton.x = bombardButton.x;
			AAfireButton.y = moveButton.y;
			AAfireButton.visible = false;
			this.addChild(AAfireButton);
			
			moveButtonMask = new Image(Assets.getAtlas().getTexture("Buttons/button_mask"));
			moveButtonMask.x = moveButton.x;
			moveButtonMask.y = moveButton.y;
			moveButtonMask.visible = false;
			this.addChild(moveButtonMask);
			
			fireButtonMask = new Image(Assets.getAtlas().getTexture("Buttons/button_mask"));
			fireButtonMask.x = fireButton.x;
			fireButtonMask.y = fireButton.y;
			fireButtonMask.visible = false;
			this.addChild(fireButtonMask);
			
			actionButtonMask = new Image(Assets.getAtlas().getTexture("Buttons/button_mask"));
			actionButtonMask.x = bombardButton.x;
			actionButtonMask.y = bombardButton.y;
			actionButtonMask.visible = false;
			this.addChild(actionButtonMask);
			
			shipCompleteButton = new Button(Assets.getAtlas().getTexture("Buttons/shipComplete_Button"));
			shipCompleteButton.x = this.width / 2 - shipCompleteButton.width / 2;
			shipCompleteButton.y = 400;
			this.addChild(shipCompleteButton);
			
			turnCompleteButton = new Button(Assets.getAtlas().getTexture("Buttons/turnComplete_Button"));
			turnCompleteButton.x = shipCompleteButton.x;
			turnCompleteButton.y = shipCompleteButton.y + turnCompleteButton.height + 5;
			this.addChild(turnCompleteButton);
			
			//initialize text fields
			Assets.getFont();
			shipType = new TextField(this.width, 100, "", "ARMY RUST", 30, 0xffffff);
			shipType.x = 0;
			shipType.y = 30;
			this.addChild(shipType);
			
			shipHealth = new TextField(this.width, 50, "", "ARMY RUST", 30, 0xffffff);
			shipHealth.x = 0;
			shipHealth.y = 200;
			this.addChild(shipHealth);
			
			//initialize random stuff
			storedFighter1 = new Image(Assets.getAtlas().getTexture("GUI/fighter_stored"));
			storedFighter1.x = 6;
			storedFighter1.y = 300;
			storedFighter1.visible = false;
			this.addChild(storedFighter1);
			
			storedFighter2 = new Image(Assets.getAtlas().getTexture("GUI/fighter_stored"));
			storedFighter2.x = 6+storedFighter1.width;
			storedFighter2.y = 300;
			storedFighter2.visible = false;
			this.addChild(storedFighter2);
			
			storedFighter3 = new Image(Assets.getAtlas().getTexture("GUI/fighter_stored"));
			storedFighter3.x = 6+(2*storedFighter1.width);
			storedFighter3.y = 300;
			storedFighter3.visible = false;
			this.addChild(storedFighter3);
			
		}
		
		public function updateShipStatus(ship:ShipBase):void
		{
			eraseCurrentStatus();
			if (ship.shipType == ShipTypes.BATTLESHIP)
			{
				battlshipIcon.visible = true;
				moveButton.visible = true;
				fireButton.visible = true;
				bombardButton.visible = true;
			}
			else if (ship.shipType == ShipTypes.CARRIER)
			{
				carrierIcon.visible = true;
				moveButton.visible = true;
				fireButton.visible = true;
				launchFighterButton.visible = true;
				showStoredFighters(ship as Carrier);
			}
			else if (ship.shipType == ShipTypes.SUBMARINE)
			{
				moveButton.visible = true;
				fireButton.visible = true;
				submergeButton.visible = true;
			}
			else if (ship.shipType == ShipTypes.DESTROYER)
			{
				moveButton.visible = true;
				fireButton.visible = true;
				AAfireButton.visible = true;
			}
			else if (ship.shipType == ShipTypes.TORPEDO_BOAT)
			{
				moveButton.visible = true;
				fireButton.visible = true;
			}
			else if (ship.shipType == ShipTypes.FIGHTER)
			{
				fighterIcon.visible = true;
				moveButton.visible = true;
				fireButton.visible = true;
			}
			
			
			if (ship.moved)
			{
				moveButtonMask.visible = true;
			}
			if (ship.fired)
			{
				fireButtonMask.visible = true;
			}
			if (ship.performedAction)
			{
				actionButtonMask.visible = true;
			}
			
			shipType.text = ship.shipType;
			shipHealth.text = ("HP :" + ship.currentHP);
			
		}
		
		private function showStoredFighters(carrier:Carrier):void 
		{
			if (carrier.fighterSquadrons >= 1)
			{
				storedFighter1.visible = true;
			}
			if (carrier.fighterSquadrons >= 2)
			{
				storedFighter2.visible = true;
			}
			if (carrier.fighterSquadrons >= 3)
			{
				storedFighter3.visible = true;
			}
		}
		
		public function eraseCurrentStatus():void 
		{
			battlshipIcon.visible = false;
			carrierIcon.visible = false;
			fighterIcon.visible = false;
			
			moveButton.visible = false;
			fireButton.visible = false;
			bombardButton.visible = false;
			launchFighterButton.visible = false;
			submergeButton.visible = false;
			AAfireButton.visible = false;
			
			moveButtonMask.visible = false;
			fireButtonMask.visible = false;
			actionButtonMask.visible = false;
			
			storedFighter1.visible = false;
			storedFighter2.visible = false;
			storedFighter3.visible = false;
			
			shipHealth.text = "";
			shipType.text = "";
		}
		
	}

}