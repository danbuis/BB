package playArea 
{
	import flash.geom.Point;
	import managers.AnimationManager;
	import ships.ShipBase;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author dan
	 */
	public class GridCell extends Sprite 
	{
				
		public var occupied:Boolean = false;
		public var occupyingShip:ShipBase = null;
		private var _coordinates:Point;
		
		public var highlight:Image = new Image(Assets.getAtlas().getTexture("gridcell_highlight"));
		public var fog:Image = new Image(Assets.getAtlas().getTexture("gridcell_fog"));
		
		public function GridCell(x:int, y:int) 
		{
			super();
			_coordinates = new Point(x, y);
			
			fog.visible = true;
			fog.scaleX = 0.8;
			fog.scaleY = 0.8;
			fog.x = 20 + (_coordinates.x * 40) + fog.width / 2;
			fog.y = 20 + (_coordinates.y * 40) + fog.height / 2;;
			this.addChild(fog);
			
			highlight.alpha = 0;
			highlight.x = 20 + (_coordinates.x * 40) + highlight.width / 2;
			highlight.y = 20 + (_coordinates.y * 40) + highlight.height / 2;;
			this.addChild(highlight);
			

		}
		
		public function shipEnters(ship:ShipBase):void
		{
			occupied = true;
			occupyingShip = ship;
		}
		
		public function shipLeaves():void
		{
			occupied = false;
			occupyingShip = null;
		}
		
		public function get coordinates():Point 
		{
			return _coordinates;
		}
		
		public function drawHighlight(validTarget:Boolean):void
		{
			if (validTarget)
			{
				highlight.alpha = 1;
			}
			else highlight.alpha = 0.5;
		}
		
		public function hideHighlight():void
		{
			highlight.alpha = 0;
		}
		
		public function isHighlighted():Boolean
		{
			if (highlight.alpha == 1)
			{
				return true;
			}
			else return false;
		}
		
		public function hideFog():void
		{
			AnimationManager.fogChange(0, this);
			if (occupied)
			{
				occupyingShip.visible = true;
			}
		}
		
		public function showFog():void
		{
			AnimationManager.fogChange(1.0, this);
			if (occupied)
			{
				occupyingShip.visible = false;
			}
		}
		

		
	}

}