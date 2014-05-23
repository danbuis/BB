package screens 
{
	import events.BBNavigationEvent;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author dan
	 */
	public class WelcomeScreen extends BaseScreen
	{
		private var backgroundImage:Image;
		
		private var newGameButton:Button;
		private var tutorialButton:Button;
		private var freePlayButton:Button;
		
		/* Constructor
		 * 
		 * */
		public function WelcomeScreen() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/* event handler from constructor
		 * */
		private function onAddedToStage(e:Event):void 
		{
			trace ("Welcome screen initialized");
			
			drawScreen();
			//adds event listeners for buttons
			this.addEventListener(Event.TRIGGERED, onButtonClick);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		/*handles button click events
		 * */
		private function onButtonClick(event:Event):void 
		{
			var buttonClicked:Button = event.target as Button;
			
			if (buttonClicked == newGameButton)
				{
					this.dispatchEvent(new BBNavigationEvent(BBNavigationEvent.START_GAME, true, {ships:[1,1,1,1,1,1,1,1,1,1]}));
				}
		}
		
		/* Draws screen, placing static elements in their locations
		 * */
		private function drawScreen():void 
		{
			backgroundImage = new Image(Assets.getTexture("WelcomeScreenBG"));
			this.addChild(backgroundImage);
			
			//this button centered along bottom
			newGameButton = new Button(Assets.getAtlas().getTexture("Buttons/NewGameButton"));
			newGameButton.x = (stage.width / 2) - (newGameButton.width / 2);
			newGameButton.y = 400;
			this.addChild(newGameButton);
			
			// how far apart buttons are spaced
			var buttonOffset:int = 200;
			
			tutorialButton = new Button(Assets.getAtlas().getTexture("Buttons/TutorialButton"));
			tutorialButton.x = newGameButton.x - buttonOffset;
			tutorialButton.y = newGameButton.y;
			this.addChild(tutorialButton);
			
			freePlayButton = new Button(Assets.getAtlas().getTexture("Buttons/FreePlayGameButton"));
			freePlayButton.x = newGameButton.x + buttonOffset;
			freePlayButton.y = newGameButton.y;
			this.addChild(freePlayButton);
		}
		

		
		
		
		
	}

}