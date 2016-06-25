package screens
{
	import cklibs.Screen;
	
	import com.eclecticdesignstudio.motion.Actuate;
	
	import entities.CharMenu;
	
	import enum.KeyEnum;
	import enum.ScreenEnum;
	
	import model.KeyDict;
	
	public class MenuScreen extends Screen 
	{
		
		private var PLAYER1_MARGIN_LEFT:Number = 150;
		private var PLAYER2_MARGIN_LEFT:Number = 1000;
		
		private var PLAYER1_MARGIN_TOP:Number = 600;
		private var PLAYER2_MARGIN_TOP:Number = 600;
		
		private var CHARA_MARGIN_LEFT:Number = 100;
		private var CHARA_MARGIN_TOP:Number = -50;
		
		private var LOGO_MARGIN_TOP:Number = 500;
		
		public var logo:LogoAnim = new LogoAnim();
		
		public var charaImg:CharaImg = new CharaImg();
		
		//background
		private var gameBG:GameBG_MC = new GameBG_MC();
		
		private var charMenuP1:CharMenu = new CharMenu(1);
		private var charMenuP2:CharMenu = new CharMenu(2);
		
		/*
		* Pressed key status
		*/
		private var keyDict:KeyDict = new KeyDict();
		
		private var p1Ready:Boolean = false;
		private var p2Ready:Boolean = false;
		
		private var controllerMC:ControllerMC = new ControllerMC();
		
		public function MenuScreen(main:AngkaBattle)
		{
			super(main);
			addChild(gameBG);
			
			logo.x = main.stage.stageWidth/2;
			logo.y = LOGO_MARGIN_TOP;
			
			charMenuP1.scaleX = 1.5;
			charMenuP1.scaleY = 1.5;
			charMenuP2.scaleX = 1.5;
			charMenuP2.scaleY = 1.5;
			
			addChild(charMenuP1);
			addChild(charMenuP2);
			
			charMenuP1.x = PLAYER1_MARGIN_LEFT;
			charMenuP1.y = PLAYER1_MARGIN_TOP;
			
			charMenuP2.x = PLAYER2_MARGIN_LEFT;
			charMenuP2.y = PLAYER2_MARGIN_TOP;
			
			addChild(charaImg);
			
			addChild(logo);
			
			
			
			addChild(controllerMC);
			controllerMC.scaleX = 0.8;
			controllerMC.scaleY = 0.8;
			controllerMC.x = (main.stage.stageWidth/2)-(controllerMC.width/2)+50;
			controllerMC.y = 600;
			
			
		}
		
		override public function update():void{
			if (isPlay) {
				
				//P1
				if (main.binder.isActionActivated(KeyEnum.P1_START) && keyDict.pressed["P1_START"] == false) {
					charMenuP1.ready();
					keyDict.pressed["P1_START"] = true;
					p1Ready = true;
				}
				
				//P2
				if (main.binder.isActionActivated(KeyEnum.P2_START) && keyDict.pressed["P2_START"] == false) {
					charMenuP2.ready();
					keyDict.pressed["P2_START"] = true;
					p2Ready = true;
				}

				if (p1Ready && p2Ready) {
					main.changeScreen(ScreenEnum.GAME_SCREEN);
				}
				
				
			}
		}
		
		override public function show():void{
			super.show();
			
			charMenuP1.start();
			charMenuP2.start();
			
			charaImg.x = CHARA_MARGIN_LEFT;
			charaImg.y = CHARA_MARGIN_TOP+100;
			charaImg.alpha = 0;
			Actuate.tween(charaImg, 1, {y: CHARA_MARGIN_TOP, alpha:1});
			
			keyDict.pressed["P1_START"] = false;
			keyDict.pressed["P2_START"] = false;
			
			p1Ready = false;
			p2Ready = false;
			
		}
		
		override public function hide():void{
			super.hide();
			
			keyDict.pressed["P1_START"] = false;
			keyDict.pressed["P2_START"] = false;
			
			p1Ready = false;
			p2Ready = false;
		}
		
		override public function onActionReleased(__action:String):void{
			
		}
	}
}