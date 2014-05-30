package
{
//TODO go thorugh all code when done and do Math.floor for all divisions of sprite locaitons
	import events.BBNavigationEvent;
	import screens.BuildFleetScreen;
	import screens.GameScreen;
	import screens.WelcomeScreen;
	import ships.ShipBase;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class Game extends Sprite
	{
		public var welcomeScreen:WelcomeScreen;
		public var gameScreen:GameScreen;
		public var fleetScreen:BuildFleetScreen;
		
		public function Game()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			trace ("starling framework initialized");
			
			//event listener for starting a new game.  recieved from the welcome screen
			this.addEventListener(BBNavigationEvent.START_GAME, startNewGame);
			this.addEventListener(BBNavigationEvent.MAIN_MENU, returnToMainMenu);
			this.addEventListener(BBNavigationEvent.TO_BUILD_FLEET, toBuildFleet);
			
			gameScreen = new GameScreen();
			gameScreen.hideScreen();
			this.addChild(gameScreen);
			
			fleetScreen = new BuildFleetScreen();
			fleetScreen.hideScreen();
			this.addChild(fleetScreen);
			
			welcomeScreen = new WelcomeScreen();
			this.addChild(welcomeScreen);
			

		}
		
		private function toBuildFleet(e:BBNavigationEvent):void 
		{
			welcomeScreen.hideScreen();
			gameScreen.hideScreen();
			fleetScreen.showScreen();
			
		}
		
		private function returnToMainMenu(e:BBNavigationEvent):void 
		{
			gameScreen.hideScreen();
			fleetScreen.hideScreen();
			welcomeScreen.showScreen();
		}
		

		//event handler for starting a new game
		private function startNewGame(event:BBNavigationEvent):void 
		{
			//grab information from event regarding what ships to put in
			var shipsToPlayWith:Array = event.data.ships;
	
			//if ships in play now
			if (gameScreen.shipsInPlay.length > 0)
			{
				gameScreen.reset();
			}
			
			//adds ships to game
			gameScreen.addShips(shipsToPlayWith);
			gameScreen.GUI.switchToPregamePhase();
			
			
			//hide current screen
			welcomeScreen.hideScreen();
			fleetScreen.hideScreen();
			
			//initialize a new game using the data passed in the event data parameter to add ships
			gameScreen.showScreen();
			
		}
	}
}