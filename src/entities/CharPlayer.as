package entities
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class CharPlayer extends Sprite
	{
		public var p:MovieClip;
		
		private var isMale:Boolean;
		
		public function CharPlayer(isMale:Boolean)
		{
			if (isMale) {
				p = new CharCowok();
				addChild(p);
			}else{
				p = new CharCewek();
				addChild(p);
			}
		}
	}
}