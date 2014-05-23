package playArea 
{
	import flash.geom.Point;
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
		
		private var highlight:Image = new Image(Assets.getAtlas().getTexture("gridcell_highlight"));
		
		public function GridCell(x:int, y:int) 
		{
			super();
			_coordinates = new Point(x, y);
			highlight.visible = false;
			// TODO: refactor so that it pulls numbers from the game screen
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
		
		public function drawHighlight():void
		{
			highlight.visible = true;
		}
		
		public function hideHighlight():void
		{
			highlight.visible = false;
		}
		
		public function isHighlighted():Boolean
		{
			return highlight.visible;
		}
		

		
	}

}