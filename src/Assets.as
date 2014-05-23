package  
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.text.TextField;
	/**
	 * ...
	 * @author dan
	 */
	public class Assets 
	{
		
		// embed welcome screen background
		[Embed(source = "../assets/graphics/WelcomeScreenBG.png")]
		public static const WelcomeScreenBG:Class;
		
		// embed game screen background
		[Embed(source = "../assets/graphics/GameScreenBG.png")]
		public static const GameScreenBG:Class;
		
		//collection of textures
		private static var gameTextures:Dictionary = new Dictionary();
		
		//texture atlas
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source = "../assets/graphics/spriteSheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source = "../assets/graphics/spriteSheet.xml", mimeType = "application/octet-stream")]
		public static const AtlasXMLGame:Class;
		
		
		//fonts
		[Embed (source = "../assets/fonts/BBfont/font.fnt", mimeType = "application/octet-stream")]
		public static const FontXML:Class;
		
		[Embed(source = "../assets/fonts/BBfont/font.png")]
		public static const FontTexture:Class;
		
		public static var BBfont:BitmapFont;
		
		
		//use this in the font for the textfield
		public static function getFont():BitmapFont
		{
			var fontTexture:Texture = Texture.fromBitmap(new FontTexture());
			var fontXML:XML = XML(new FontXML);
			
			var font:BitmapFont = new BitmapFont(fontTexture, fontXML);
			TextField.registerBitmapFont(font);
			
			return font;
		}
		
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
				{
					var texture:Texture = getTexture("AtlasTextureGame");
					var xml:XML = XML(new AtlasXMLGame());
					gameTextureAtlas = new TextureAtlas(texture, xml);
				}
			return gameTextureAtlas;
		}
		
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
				{
					var bitmap:Bitmap = new Assets[name]();
					gameTextures[name] = Texture.fromBitmap(bitmap);
				}
			return gameTextures[name];	
		}
		
	}

}