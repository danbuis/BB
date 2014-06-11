package playArea 
{
	import events.BBNavigationEvent;
	import flash.geom.Point;
	import managers.AnimationManager;
	import screens.GamePhase;
	import ships.Carrier;
	import ships.Fighter;
	import ships.ShipBase;
	import ships.ShipTypes;
	import ships.Submarine;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author dan
	 */
	public class ControlBar extends Sprite 
	{
		
		public var lower_GUI:Image;
		private var upper_GUI:Image;

		private var iconX:int = 575;
		private var iconY:int = 355;
		
		private var friendlyIconMask:Image;
		private var enemyIconMask:Image;
		
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
		private var fighterPanel:Image;
		
		public var doneButton:Button;
		public var menuButton:Button;
		
		private var currentFuel:Image;
		
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
		
		private var fuelGauge:Image;
		private var fuelGuageRestX:int = 650;
		
		private var verticalOffset:int = 34;
		private var sideHorizontalOffset:int = 29;
		private var sideVerticalOffset:int =  17;
		
		private var playerLight:Image;
		private var computerLight:Image;
		private var neutralLight:Image;
		
		private var menu_bg:Image;
		private var returnToMainMenu:Button;
		private var resumGameButton:Button;
		private var restartGameButton:Button;
		
		public function ControlBar() 
		{
			super();
			initializeGUI();
			buildMenu();
			
		}
		
		private function buildMenu():void 
		{
			menu_bg = new Image(Assets.getAtlas().getTexture("GUI/Menu_mask"));
			menu_bg.scaleX = 10;
			menu_bg.scaleY = 10;
			menu_bg.visible = false;
			this.addChild(menu_bg);
			
			returnToMainMenu = new Button(Assets.getAtlas().getTexture("Buttons/main_menu_button"));
			returnToMainMenu.x = 320 - (returnToMainMenu.width / 2);
			returnToMainMenu.y = 180;
			returnToMainMenu.visible = false;
			this.addChild(returnToMainMenu);
			returnToMainMenu.addEventListener(Event.TRIGGERED, onReturnToMainMenuClick);
			
			resumGameButton = new Button(Assets.getAtlas().getTexture("Buttons/resume_Button"));
			resumGameButton.x = returnToMainMenu.x;
			resumGameButton.y = 240;
			resumGameButton.visible = false;
			this.addChild(resumGameButton);
			resumGameButton.addEventListener(Event.TRIGGERED, onResumeGameClick);
			
			restartGameButton = new Button(Assets.getAtlas().getTexture("Buttons/restart_button"));
			restartGameButton.x = returnToMainMenu.x;
			restartGameButton.y = 300;
			restartGameButton.visible = false;
			this.addChild(restartGameButton);
			//TODO
		}
		
		private function onResumeGameClick(e:Event):void 
		{
			hideMenu();
		}
		
		private function onReturnToMainMenuClick(e:Event):void 
		{
			this.dispatchEvent(new BBNavigationEvent(BBNavigationEvent.MAIN_MENU, true));
			hideMenu();
		}
		
		private function initializeGUI():void 
		{
			//large panels
			upper_GUI = new Image(Assets.getAtlas().getTexture("GUI/upper_GUI"));
			upper_GUI.x = 640 - upper_GUI.width;
			this.addChild(upper_GUI);
			
			lower_GUI = new Image(Assets.getAtlas().getTexture("GUI/lower_GUI"));
			lower_GUI.x = 640 - lower_GUI.width;
			lower_GUI.y = 480 - lower_GUI.height;
			this.addChild(lower_GUI);
			
			fuelGauge = new Image(Assets.getAtlas().getTexture("GUI/fuel_panel"));
			fuelGauge.x = fuelGuageRestX;
			fuelGauge.y = 96;
			this.addChild(fuelGauge);
			
			fighterPanel = new Image(Assets.getAtlas().getTexture("GUI/fighter_panel"));
			fighterPanel.x = fuelGuageRestX;
			fighterPanel.y = 61;
			this.addChild(fighterPanel);
			
			playerLight = new Image(Assets.getAtlas().getTexture("GUI/green_light"));
			playerLight.x = 364;
			playerLight.y = 445;
			playerLight.visible = false;
			
			computerLight = new Image(Assets.getAtlas().getTexture("GUI/red_light"));
			computerLight.x = playerLight.x;
			computerLight.y = playerLight.y;
			computerLight.visible = false;
			
			neutralLight = new Image(Assets.getAtlas().getTexture("GUI/yellow_light"));
			neutralLight.x = playerLight.x;
			neutralLight.y = playerLight.y;
			
			this.addChild(computerLight);
			this.addChild(playerLight);
			this.addChild(neutralLight);
			
			//masks
			friendlyIconMask = new Image(Assets.getAtlas().getTexture("GUI/blue_screen"));
			friendlyIconMask.x = 570;
			friendlyIconMask.y = 350;
			friendlyIconMask.visible = false;
			this.addChild(friendlyIconMask);
			
			enemyIconMask = new Image(Assets.getAtlas().getTexture("GUI/red_screen"));
			enemyIconMask.x = 570;
			enemyIconMask.y = 350;
			enemyIconMask.visible = false;
			this.addChild(enemyIconMask);
			
			//initialize icons
			battlshipIcon = new Image(Assets.getAtlas().getTexture("GUI/BB_icon"));
			battlshipIcon.visible = false;
			battlshipIcon.x = iconX
			battlshipIcon.y = iconY;
			this.addChild(battlshipIcon);
			
			carrierIcon = new Image(Assets.getAtlas().getTexture("GUI/carrier_icon"));
			carrierIcon.visible = false;
			carrierIcon.x = iconX;
			carrierIcon.y = iconY;
			this.addChild(carrierIcon);
			
			fighterIcon = new Image(Assets.getAtlas().getTexture("GUI/fighter_icon"));
			fighterIcon.visible = false;
			fighterIcon.x = iconX;
			fighterIcon.y = iconY;
			this.addChild(fighterIcon);
			
			//initialize buttons
			moveButton = new Button(Assets.getAtlas().getTexture("Buttons/move_button"));
			moveButton.x = lower_GUI.width * 0.2
			moveButton.y = 240;
			moveButton.visible = false;
			this.addChild(moveButton);
			
			fireButton = new Button(Assets.getAtlas().getTexture("Buttons/fire_button"));
			fireButton.x = lower_GUI.width * 0.5
			fireButton.y = moveButton.y;
			fireButton.visible = false;
			this.addChild(fireButton);
			
			bombardButton = new Button(Assets.getAtlas().getTexture("Buttons/bombard_button"));
			bombardButton.x = lower_GUI.width * 0.8
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
			
			
			
			menuButton = new Button(Assets.getAtlas().getTexture("Buttons/menu_button"));
			menuButton.x = 560;
			menuButton.y = 5;
			this.addChild(menuButton);
			menuButton.addEventListener(Event.TRIGGERED, onMenuButtonClick);
			
			doneButton = new Button(Assets.getAtlas().getTexture("GUI/done_up"), "",Assets.getAtlas().getTexture("GUI/done_down") );
			doneButton.x = 5;
			doneButton.y = 480 - doneButton.height;
			this.addChild(doneButton);
			
			
			
			//initialize text fields
			Assets.getFont();
			shipType = new TextField(150, 38, "", "ARMY RUST", 30, 0xffffff);
			shipType.x = 406;
			shipType.y = 448;
			this.addChild(shipType);
			
			shipHealth = new TextField(60, 38, "", "ARMY RUST", 30, 0xffffff);
			shipHealth.x = 570;
			shipHealth.y = 448;
			this.addChild(shipHealth);
		
			//initialize fuel indicators
			fuel100 = new Image(Assets.getAtlas().getTexture("GUI/fuel_100"));
			fuel100.x = fuelGuageRestX + 43;
			fuel100.y = 107;
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
			storedFighter1.x = fuelGuageRestX+43;
			storedFighter1.y = 124;
			storedFighter1.visible = false;
			this.addChild(storedFighter1);
			
			storedFighter2 = new Image(Assets.getAtlas().getTexture("GUI/fighter_stored"));
			storedFighter2.x = storedFighter1.x;
			storedFighter2.y = 189;
			storedFighter2.visible = false;
			this.addChild(storedFighter2);
			
			storedFighter3 = new Image(Assets.getAtlas().getTexture("GUI/fighter_stored"));
			storedFighter3.x = storedFighter1.x;
			storedFighter3.y = 254;
			storedFighter3.visible = false;
			this.addChild(storedFighter3);
			
		}
		
		private function onMenuButtonClick(e:Event):void 
		{
			menu_bg.visible = true;
			resumGameButton.visible = true;
			restartGameButton.visible = true;
			returnToMainMenu.visible = true;
		}
		
		private function hideMenu():void
		{
			menu_bg.visible = false;
			resumGameButton.visible = false;
			restartGameButton.visible = false;
			returnToMainMenu.visible = false;
		}
		
		public function switchToPlayPhase():void
		{
			
			playerLight.visible = true;
		}
		
		public function switchToPregamePhase():void
		{
			playerLight.visible = false;
			computerLight.visible = false;
			neutralLight.visible = true;
		}
		
		public function changePlayerIndicatorLight(newPlayer:String):void
		{
			playerLight.visible = false;
			computerLight.visible = false;
			neutralLight.visible = false;
			
			if (newPlayer == CurrentPlayer.COMPUTER)
			{
				computerLight.visible = true;
			}
			else if (newPlayer==CurrentPlayer.PLAYER)
			{
				playerLight.visible = true;
			}
			else 
			{
				neutralLight.visible = true;
				
			}
		}
		
		//TODO grab information from around ship to determine button placement, perhaps an array of surrounding ships...
		public function updateShipStatus(ship:ShipBase, gamePhase:String):void
		{
			eraseCurrentStatus();
			
			//start with basics
			shipType.text = ship.shipType;
			shipHealth.text = ("HP :" + ship.currentHP);
			
			if (ship.team == 1)
			{
				friendlyIconMask.visible = true;
			}
			else 
			{
				enemyIconMask.visible = true;	
			}
			
			//if not your ship, break, rest of update has to do with player commands
			if (ship.team != 1)
			{
				return;
			}
			
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
				if ((ship as Carrier).fighterSquadrons == 0)
				{
					actionButtonMask.visible = true;
				}
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
			else if (ship.shipType == ShipTypes.PATROL_BOAT)
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
			
			locateShipButtons(ship);
			
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
		
		private function locateShipButtons(ship:ShipBase):void 
		{
			var centerX:int = ship.x + (ship.width / 2);
			var centerY:int = ship.y + (ship.height / 2);
			
			var buttonOffset:int = moveButton.height / 2;
			
			moveButton.x = centerX - buttonOffset;
			moveButton.y = centerY + verticalOffset - buttonOffset;
			moveButtonMask.x = moveButton.x;
			moveButtonMask.y = moveButton.y;
			
			fireButton.x = centerX -sideHorizontalOffset - buttonOffset;
			fireButton.y = centerY + sideVerticalOffset - buttonOffset;
			fireButtonMask.x = fireButton.x;
			fireButtonMask.y = fireButton.y;
			
			var actionButton:Button;
			
			if (ship.shipType == ShipTypes.CARRIER)
			{
				actionButton = launchFighterButton;
			}
			else if (ship.shipType == ShipTypes.BATTLESHIP)
			{
				actionButton = bombardButton;
			}
			else if (ship.shipType == ShipTypes.SUBMARINE)
			{
				actionButton = submergeButton;
			}
			else if (ship.shipType == ShipTypes.DESTROYER||ship.shipType==ShipTypes.PATROL_BOAT||ship.shipType==ShipTypes.FIGHTER)
			{
				actionButton = AAfireButton;
			}
			
			actionButton.x = centerX + sideHorizontalOffset - buttonOffset;
			actionButton.y = centerY + sideVerticalOffset - buttonOffset;
			actionButtonMask.x = actionButton.x;
			actionButtonMask.y = actionButton.y;
		}
		
		private function showSubFuel(sub:Submarine):void
		{
			
			//TODO sub fuel update at end of turn, not ship complete
			if (sub.numberOfDivesRemaining == 8)
			{
				fuel100.visible = true;
				currentFuel = fuel100;
			}
			else if (sub.numberOfDivesRemaining == 7)
			{
				fuel89.visible = true;
				currentFuel = fuel89;
			}
			
			else if (sub.numberOfDivesRemaining == 6)
			{
				fuel75.visible = true;
				currentFuel = fuel75;
			}
			else if (sub.numberOfDivesRemaining == 5)
			{
				fuel63.visible = true;
				currentFuel = fuel63
			}
			else if (sub.numberOfDivesRemaining == 4)
			{
				fuel50.visible = true;
				currentFuel = fuel50;
			}
			else if (sub.numberOfDivesRemaining == 3)
			{
				fuel38.visible = true;
				currentFuel = fuel38;
			}
			else if (sub.numberOfDivesRemaining == 2)
			{
				fuel25.visible = true;
				currentFuel = fuel25;
			}
			else if (sub.numberOfDivesRemaining == 1)
			{
				fuel13.visible = true;
				currentFuel = fuel13;
			}
			
			AnimationManager.moveFuelPanel(640 - fuelGauge.width, fuelGauge, currentFuel);
		}
		
		private function showFighterFuelStatus(fighter:Fighter):void 
		{
			
			
			if (fighter.currentEndurance == 3)
			{
				fuel100.visible = true;
				currentFuel = fuel100;
			}
			else if (fighter.currentEndurance == 2)
			{
				fuel66.visible = true;
				currentFuel = fuel66;
			}
			else if (fighter.currentEndurance == 1)
			{
				fuel33.visible = true;
				currentFuel = fuel33;
			}
			
			AnimationManager.moveFuelPanel(640 - fuelGauge.width, fuelGauge, currentFuel);
			
			
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
			
			AnimationManager.moveFighterPanel(640 - fighterPanel.width, fighterPanel, carrier.fighterSquadrons, storedFighter1, storedFighter2, storedFighter3);
		}
		
		public function eraseCurrentStatus():void 
		{
			if (currentFuel != null)
			{
				AnimationManager.moveFuelPanel(fuelGuageRestX, fuelGauge, currentFuel);
			}
			
			AnimationManager.moveFighterPanel(fuelGuageRestX, fighterPanel, 3, storedFighter1, storedFighter2, storedFighter3);
			
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
			currentFuel = null;
			
		}
		
	}

}