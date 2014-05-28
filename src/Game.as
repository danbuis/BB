package
{

	import events.BBNavigationEvent;
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
			
			gameScreen = new GameScreen();
			gameScreen.hideScreen();
			this.addChild(gameScreen);
			
			welcomeScreen = new WelcomeScreen();
			this.addChild(welcomeScreen);
			

		}
		
		
		//event handler for starting a new game
		private function startNewGame(event:BBNavigationEvent):void 
		{
			//grab information from event regarding what ships to put in
			var shipsToPlayWith:Array = event.data.ships;
		
			//adds ships to game
			gameScreen.addShips(shipsToPlayWith);
			
			
			//hide current screen
			welcomeScreen.hideScreen();
			//initialize a new game using the data passed in the event data parameter to add ships
			gameScreen.showScreen();
			
		}
	}
}