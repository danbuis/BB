package playArea 
{
	import flash.geom.Point;
	import screens.GamePhase;
	import ships.Carrier;
	import ships.Fighter;
	import ships.ShipBase;
	import ships.ShipTypes;
	import ships.Submarine;
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
		// TODO, use...
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
		public var startGameButton:Button;
		public var mainMenuButton:Button;
		
		private var fuel100:Image;
		private var fuel89:Image;
		private var fuel75:Image;
		private var fuel66:Image;
		private var fuel63:Image;
		private var fuel50:Image;
		private var fuel38:Image;
		private var fuel33:Image;
		private var fuel25:Image;
		private var fuel13:Image;
		
		
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
			shipCompleteButton.visible = false;
			this.addChild(shipCompleteButton);
			
			mainMenuButton = new Button(Assets.getAtlas().getTexture("Buttons/main_menu_button"));
			mainMenuButton.x = shipCompleteButton.x;
			mainMenuButton.y = shipCompleteButton.y + mainMenuButton.height + 5;
			mainMenuButton.visible = true;
			this.addChild(mainMenuButton);
			
			startGameButton = new Button(Assets.getAtlas().getTexture("Buttons/turnComplete_Button"));
			startGameButton.x = shipCompleteButton.x;
			startGameButton.y = shipCompleteButton.y;
			this.addChild(startGameButton);
			
			
			
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
		
			//initialize fuel indicators
			fuel100 = new Image(Assets.getAtlas().getTexture("GUI/fuel_100"));
			fuel100.x = 6;
			fuel100.y = 300;
			fuel100.visible = false;
			this.addChild(fuel100);
			
			fuel89 = new Image(Assets.getAtlas().getTexture("GUI/fuel_88"));
			fuel89.x = fuel100.x;
			fuel89.y = fuel100.y;
			fuel89.visible = false;
			this.addChild(fuel89);
			
			fuel75 = new Image(Assets.getAtlas().getTexture("GUI/fuel_75"));
			fuel75.x = fuel100.x;
			fuel75.y = fuel100.y;
			fuel75.visible = false;
			this.addChild(fuel75);
			
			fuel66 = new Image(Assets.getAtlas().getTexture("GUI/fuel_66"));
			fuel66.x = fuel100.x;
			fuel66.y = fuel100.y;
			fuel66.visible = false;
			this.addChild(fuel66);
			
			fuel63 = new Image(Assets.getAtlas().getTexture("GUI/fuel_63"));
			fuel63.x = fuel100.x;
			fuel63.y = fuel100.y;
			fuel63.visible = false;
			this.addChild(fuel63);
			
			fuel50 = new Image(Assets.getAtlas().getTexture("GUI/fuel_50"));
			fuel50.x = fuel100.x;
			fuel50.y = fuel100.y;
			fuel50.visible = false;
			this.addChild(fuel50);
			
			fuel38 = new Image(Assets.getAtlas().getTexture("GUI/fuel_38"));
			fuel38.x = fuel100.x;
			fuel38.y = fuel100.y;
			fuel38.visible = false;
			this.addChild(fuel38);
	 		
			fuel33 = new Image(Assets.getAtlas().getTexture("GUI/fuel_33"));
			fuel33.x = fuel100.x;
			fuel33.y = fuel100.y;
			fuel33.visible = false;
			this.addChild(fuel33);
			
			fuel25 = new Image(Assets.getAtlas().getTexture("GUI/fuel_25"));
			fuel25.x = fuel100.x;
			fuel25.y = fuel100.y;
			fuel25.visible = false;
			this.addChild(fuel25);
			
			fuel13 = new Image(Assets.getAtlas().getTexture("GUI/fuel_13"));
			fuel13.x = fuel100.x;
			fuel13.y = fuel100.y;
			fuel13.visible = false;
			this.addChild(fuel13);
			
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
		
		public function switchToPlayPhase():void
		{
			
			startGameButton.visible = false;
			shipCompleteButton.visible = true;
		}
		
		public function switchToPregamePhase():void
		{
		
			startGameButton.visible = true;
			shipCompleteButton.visible = false;
		}
		
		public function updateShipStatus(ship:ShipBase, gamePhase:String):void
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
				showSubFuel(ship as Submarine);
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
				showFighterFuelStatus(ship as Fighter);
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
			
			if (gamePhase == GamePhase.PLACEMENT_PHASE)
			{
				moveButton.visible = false;
				fireButton.visible = false;
				bombardButton.visible = false;
				AAfireButton.visible = false;
				launchFighterButton.visible = false;
				submergeButton.visible = false;
			}
			
		}
		
		private function showSubFuel(sub:Submarine):void
		{
			if (sub.numberOfDivesRemaining == 8)
			{
				fuel100.visible = true;
			}
			else if (sub.numberOfDivesRemaining == 7)
			{
				fuel89.visible = true;
			}
			
			else if (sub.numberOfDivesRemaining == 6)
			{
				fuel75.visible = true;
			}
			else if (sub.numberOfDivesRemaining == 5)
			{
				fuel63.visible = true;
			}
			else if (sub.numberOfDivesRemaining == 4)
			{
				fuel50.visible = true;
			}
			else if (sub.numberOfDivesRemaining == 3)
			{
				fuel38.visible = true;
			}
			else if (sub.numberOfDivesRemaining == 2)
			{
				fuel25.visible = true;
			}
			else if (sub.numberOfDivesRemaining == 1)
			{
				fuel13.visible = true;
			}
		}
		
		private function showFighterFuelStatus(fighter:Fighter):void 
		{
			if (fighter.currentEndurance == 3)
			{
				fuel100.visible = true;
			}
			else if (fighter.currentEndurance == 2)
			{
				fuel66.visible = true;
			}
			else if (fighter.currentEndurance == 1)
			{
				fuel33.visible = true;
			}
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
			
			fuel100.visible = false;
			fuel89.visible = false;
			fuel75.visible = false;
			fuel66.visible = false;
			fuel63.visible = false;
			fuel50.visible = false;
			fuel38.visible = false;
			fuel33.visible = false;
			fuel25.visible = false;
			fuel13.visible = false;
			
		}
		
	}

}