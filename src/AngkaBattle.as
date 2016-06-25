package
{
	import com.zehfernando.input.binding.KeyActionBinder;
	
	import enum.KeyEnum;
	import enum.ScreenEnum;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	
	import screens.GameScreen;
	import screens.MenuScreen;
	
	[SWF(width="1280", height="800")]
	public class AngkaBattle extends Sprite
	{
				
		
		public var binder:KeyActionBinder;
		
		public var gameScreen:GameScreen;
		public var menuScreen:MenuScreen;
		
		public function AngkaBattle()
		{
			binder = new KeyActionBinder(stage);
			binder.onActionDeactivated.add(onActionReleased);
			
			//INITIALIZATION
			gameScreen = new GameScreen(this);
			menuScreen = new MenuScreen(this);
			
			initScreen();
			initKeyBind();
			
			//START
			addEventListener(Event.ENTER_FRAME, update);
			
			changeScreen(ScreenEnum.MENU_SCREEN);
//			changeScreen(ScreenEnum.GAME_SCREEN);
			
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		protected function update(event:Event):void
		{
			gameScreen.update();
			menuScreen.update();
		}
		
		public function initScreen():void{
			gameScreen.hide();
			menuScreen.hide();
			
			addChild(gameScreen);
			addChild(menuScreen);
		}
		
		public function initKeyBind():void{
			//player 1
			binder.addGamepadActionBinding(KeyEnum.P1_UP, "BUTTON_6", 0);
			binder.addGamepadActionBinding(KeyEnum.P1_RIGHT, "BUTTON_9", 0);
			binder.addGamepadActionBinding(KeyEnum.P1_DOWN, "BUTTON_7", 0);
			binder.addGamepadActionBinding(KeyEnum.P1_LEFT, "BUTTON_8", 0);
			binder.addGamepadActionBinding(KeyEnum.P1_1, "BUTTON_10", 0);
			binder.addGamepadActionBinding(KeyEnum.P1_2, "BUTTON_11", 0);
			binder.addGamepadActionBinding(KeyEnum.P1_3, "BUTTON_12", 0);
			binder.addGamepadActionBinding(KeyEnum.P1_4, "BUTTON_13", 0);
			binder.addGamepadActionBinding(KeyEnum.P1_START, "BUTTON_19", 0);
			
			//player 2
			binder.addGamepadActionBinding(KeyEnum.P2_UP, "BUTTON_6", 1);
			binder.addGamepadActionBinding(KeyEnum.P2_RIGHT, "BUTTON_9", 1);
			binder.addGamepadActionBinding(KeyEnum.P2_DOWN, "BUTTON_7", 1);
			binder.addGamepadActionBinding(KeyEnum.P2_LEFT, "BUTTON_8", 1);
			binder.addGamepadActionBinding(KeyEnum.P2_1, "BUTTON_10", 1);
			binder.addGamepadActionBinding(KeyEnum.P2_2, "BUTTON_11", 1);
			binder.addGamepadActionBinding(KeyEnum.P2_3, "BUTTON_12", 1);
			binder.addGamepadActionBinding(KeyEnum.P2_4, "BUTTON_13", 1);
			binder.addGamepadActionBinding(KeyEnum.P2_START, "BUTTON_19", 1);
		}
		
		public function onActionReleased(__action:String):void{
			gameScreen.onActionReleased(__action);
			menuScreen.onActionReleased(__action);
		}
		
		public function changeScreen(_screenName:String):void{
			switch(_screenName){
				case ScreenEnum.GAME_SCREEN:
				{
					gameScreen.show();
					menuScreen.hide();
					break;
				}
				case ScreenEnum.MENU_SCREEN:
				{
					gameScreen.hide();
					menuScreen.show();
					break;
				}
			}
		}
	}
}