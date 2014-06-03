package
{
//TODO go thorugh all code when done and do Math.floor for all divisions of sprite locaitons
	import events.BBNavigationEvent;
	import FGL.GameTracker.GameTracker;
	import managers.TutorialManager;
	import screens.BuildFleetScreen;
	import screens.GameScreen;
	import screens.TutorialScreen;
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
		public var tutorialScreen:TutorialScreen;
		
		public var tracker:GameTracker = new GameTracker();
		
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
			this.addEventListener(BBNavigationEvent.TUTORIAL, toTutorial);
			
			gameScreen = new GameScreen();
			gameScreen.hideScreen();
			this.addChild(gameScreen);
			
			fleetScreen = new BuildFleetScreen();
			fleetScreen.hideScreen();
			this.addChild(fleetScreen);
			
			tutorialScreen = new TutorialScreen();
			tutorialScreen.hideScreen();
			this.addChild(tutorialScreen);
			
			welcomeScreen = new WelcomeScreen();
			this.addChild(welcomeScreen);
			

		}
		
		private function toTutorial(event:Event):void 
		{
			//grab information from event regarding what ships to put in
			var shipsToPlayWith:Array = event.data.ships;
	
			
			
			//if ships in play now
			if (tutorialScreen.shipsInPlay.length > 0)
			{
				tutorialScreen.reset();
			}
			
			//adds ships to game
			tutorialScreen.addShips(shipsToPlayWith);
			tutorialScreen.moveShip(tutorialScreen.shipsInPlay[0], tutorialScreen.grid[4][8]);
			tutorialScreen.GUI.switchToPregamePhase();
			
			welcomeScreen.hideScreen();
			gameScreen.hideScreen();
			tutorialScreen.showScreen();
			
			

		}
		
		private function toBuildFleet(e:BBNavigationEvent):void 
		{
			fleetScreen.resetCount();
			
			welcomeScreen.hideScreen();
			gameScreen.hideScreen();
			fleetScreen.showScreen();
			tutorialScreen.hideScreen();
		}
		
		private function returnToMainMenu(e:BBNavigationEvent):void 
		{
			gameScreen.hideScreen();
			fleetScreen.hideScreen();
			welcomeScreen.showScreen();
			tutorialScreen.hideScreen();
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