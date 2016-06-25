package cklibs
{
	import flash.display.Sprite;

	public class Screen extends Sprite
	{
		public var main:AngkaBattle;
		public var isPlay:Boolean = false;
		
		public function Screen(main:AngkaBattle)
		{
			super();
			this.main = main;
		}
		
		public function update():void{
			
		}
		
		public function setPlay(_isPlay:Boolean):void{
			this.isPlay = _isPlay;
		}
		
		public function show():void{
			this.visible = true;
			isPlay = true;
		}
		
		public function hide():void{
			this.visible = false;
			isPlay = false;
		}
		
		public function onActionReleased(__action:String):void{
			
		}
	}
}