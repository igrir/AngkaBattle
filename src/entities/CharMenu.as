package entities
{
	import flash.display.MovieClip;
	
	public class CharMenu extends MovieClip
	{
		
		private var mc:CharMenuMC = new CharMenuMC;
		private var playerNum:int;
		
		public function CharMenu(playerNum:int)
		{
			super();
			
			addChild(mc);
			this.playerNum = playerNum;
			
			if (playerNum == 1) {
				mc.p2_mc.visible = false;
			}else if (playerNum == 2) {
				mc.p1_mc.visible = false;
			}
			
			start();
		}
		
		public function ready():void{
			mc.gotoAndPlay("ready");
			
			if (playerNum == 1) {
				mc.label.text = "Player 1 Ready";
			}else if (playerNum == 2) {
				mc.label.text = "Player 2 Ready";
			}
		}
		
		public function start():void{
			mc.gotoAndStop("start");
			
			if (playerNum == 1) {
				mc.label.text = "Player 1 Press Start";
			}else if (playerNum == 2) {
				mc.label.text = "Player 2 Press Start";
			}
			
		}
		
	}
}