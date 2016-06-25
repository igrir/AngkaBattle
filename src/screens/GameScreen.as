package screens
{
	import cklibs.Screen;
	
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Quad;
	
	import entities.CharPlayer;
	import entities.TargetNumberEty;
	
	import enum.CharanimEnum;
	import enum.CharposEnum;
	import enum.FlaganimEnum;
	import enum.KeyEnum;
	import enum.ScreenEnum;
	
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import model.BoardModel;
	import model.KeyDict;
	import model.TakenCardModel;

	public class GameScreen extends Screen 
	{
		
		[Embed(source="res/131660__bertrof__game-sound-correct.mp3")] public static const PressMusic:Class;
		
		[Embed(source="res/211340__rjonesxlr8__explosion-03.mp3")] public static const ExplodeMusic:Class;
		
		private var CARD_ROW:int = 6;
		private var CARD_COL:int = 8;
		private var PLAYER_HP:Number = 50;
		private var CARD_MARGIN_RIGHT:Number = 260;
		private var CARD_MARGIN_TOP:Number = 180;
		private var CARD_MARGIN_RIGHT_SINGLE:Number = 20;
		private var CARD_MARGIN_TOP_SINGLE:Number = 20;
		private var CARD_WIDTH:Number = 80;
		private var CARD_HEIGHT:Number = 80;
		private var CHARACTER_MOVEMENT_INTERVAL:Number = 1.2;
		private var TAKEN_CARD_MARGIN_TOP:Number = 100;
		private var TOTAL_TAKEN_MARGIN_Y:Number = 50;
		private var LIFEBAR_MARGIN_Y:Number = 20;
		
		private var P1_ANIM_END_MARGIN_LEFT:Number = 100;
		private var P2_ANIM_END_MARGIN_RIGHT:Number = 350;
		private var ANIM_END_MARGIN_TOP:Number = 30;
		
		//LIFE BAR WIDTH GOT AFTER INITIALIZED
		private var LIFEBAR_WIDTH:Number;
		
		private var targetNumber:TargetNumberEty;
		
		private var boardModel:BoardModel = new BoardModel(CARD_ROW, CARD_COL);
		
		private var p1:CharPlayer = new CharPlayer(true);
		private var p2:CharPlayer = new CharPlayer(false);
		
		private var arrNumberCard:Array = new Array();
		
		/*
		* 	Array gambar kartu yang terpilih
		*/
		private var p1TakenCardMCs:Array = new Array();
		private var p2TakenCardMCs:Array = new Array();
		
		/*
		* Tulisan jumlah 
		*/
		private var p1TotalTakenMC:TakenTotal = new TakenTotal();
		private var p2TotalTakenMC:TakenTotal = new TakenTotal();
		
		/*
		* Life Bar di atas pemain
		*/
		private var p1LifeBarMC:LifeBar = new LifeBar();
		private var p2LifeBarMC:LifeBar = new LifeBar();
		
		/*
		* Polling key player status
		*/
		private var p1_poll:Boolean = true;
		private var p2_poll:Boolean = true;
		
		/*
		* Pressed key status
		*/
		private var keyDict:KeyDict = new KeyDict();
		
		/*
		*  SOUND
		*/
		private var soundBlip:Sound;
		private var soundBoom:Sound;
		
		/*
		* Win and lose graphic
		*/
		private var p1AnimEnd:P1FrontAnimEnd = new P1FrontAnimEnd();
		private var p2AnimEnd:P2FrontAnimEnd = new P2FrontAnimEnd();
		
		//background
		private var gameBG:GameBG_MC = new GameBG_MC();
		
		private var gameOver:Boolean = false;
		
		private var textEnding:TextField = new TextField();
		
		public function GameScreen(main:AngkaBattle)
		{
			super(main);
			
			//INITIALIZE
			initGUI();
			initModel();
			initSounds();
			
			
		}
		
		override public function onActionReleased(__action:String):void{
			var playerId:String = __action.slice(0,2);
			
			keyDict.pressed[__action] = false;
			
			if (playerId == "P1") {
				switch (boardModel.char1Model.lastCharPos) {
					case CharposEnum.UP:
					{
						p1.p.gotoAndStop(CharanimEnum.BACK_STOP);
						break;
					}
					case CharposEnum.RIGHT:
					{
						p1.p.gotoAndStop(CharanimEnum.RIGHT_STOP);
						break;
					}
					case CharposEnum.DOWN:
					{
						p1.p.gotoAndStop(CharanimEnum.FRONT_STOP);
						break;
					}
					case CharposEnum.LEFT:
					{
						p1.p.gotoAndStop(CharanimEnum.LEFT_STOP);
						break;
					}
				}
			}else if (playerId == "P2") {
				switch (boardModel.char2Model.lastCharPos) {
					case CharposEnum.UP:
					{
						p2.p.gotoAndStop(CharanimEnum.BACK_STOP);
						break;
					}
					case CharposEnum.RIGHT:
					{
						p2.p.gotoAndStop(CharanimEnum.RIGHT_STOP);
						break;
					}
					case CharposEnum.DOWN:
					{
						p2.p.gotoAndStop(CharanimEnum.FRONT_STOP);
						break;
					}
					case CharposEnum.LEFT:
					{
						p2.p.gotoAndStop(CharanimEnum.LEFT_STOP);
						break;
					}
				}
			}
		}
		
		override public function update():void{
			if (isPlay) {
				//DO SOMETHING
				
				keypadPolling();
				
				//--------------------BOARDS NUMBER--------------------
				for (var i:int=0;i<CARD_ROW;i++) {
					for (var j:int=0;j<CARD_COL;j++) {
						
						var numberCard:NumberCard = arrNumberCard[i][j];
						var number:int = boardModel.boardArr[i][j];
						numberCard.label.text = number.toString();
						
					}
				}
				
				
				//--------------------HEALTH POINT--------------------
				
				//player 1
				p1LifeBarMC.lbindicator.x = LIFEBAR_WIDTH - ((boardModel.p1HP/PLAYER_HP)*LIFEBAR_WIDTH);
				
				//player 2
				p2LifeBarMC.lbindicator.x = LIFEBAR_WIDTH - ((boardModel.p2HP/PLAYER_HP)*LIFEBAR_WIDTH);
				
				
				//--------------------MOVEMENT--------------------
				
				//Char 1 movement
				var coPoint:Point = boardModel.charPosArr[boardModel.char1Index.row][boardModel.char1Index.col];
				p1.y = p1.y-(p1.y-coPoint.y)/CHARACTER_MOVEMENT_INTERVAL;
				p1.x = p1.x-(p1.x-coPoint.x)/CHARACTER_MOVEMENT_INTERVAL;
				
				if (Math.abs(p1.x-coPoint.x) < 0.3 &&
					Math.abs(p1.y-coPoint.y) < 0.3) {
					p1_poll = true;
				}else{
					p1_poll = false;
				}
				
				//Char 2 movement			
				var cePoint:Point = boardModel.charPosArr[boardModel.char2Index.row][boardModel.char2Index.col];
				p2.x = p2.x-(p2.x-cePoint.x)/CHARACTER_MOVEMENT_INTERVAL;
				p2.y = p2.y-(p2.y-cePoint.y)/CHARACTER_MOVEMENT_INTERVAL;
				
				if (Math.abs(p2.x-cePoint.x) < 0.3 &&
					Math.abs(p2.y-cePoint.y) < 0.3) {
					p2_poll = true;
				}else{
					p2_poll = false;
				}
				
			}
			
			if (gameOver == true) {
				//main
				if (main.binder.isActionActivated(KeyEnum.P1_START) || main.binder.isActionActivated(KeyEnum.P2_START)) {
					main.changeScreen(ScreenEnum.MENU_SCREEN);
					reset();
				}	
			}
			
		}
		
		
		public function reset():void{
			keyDict.pressed["P1_1"] = false;
			keyDict.pressed["P1_2"] = false;
			keyDict.pressed["P1_3"] = false;
			keyDict.pressed["P1_4"] = false;
			
			keyDict.pressed["P2_1"] = false;
			keyDict.pressed["P2_2"] = false;
			keyDict.pressed["P2_3"] = false;
			keyDict.pressed["P2_4"] = false;
			
			initModel();
			
			gameOver = false;
			endingAnim(false, 0);
			
			//random angka
			boardModel.randomBoard();
			
			
		}
		
		override public function show():void{
			super.show();
			
			keyDict.pressed["P1_1"] = false;
			keyDict.pressed["P1_2"] = false;
			keyDict.pressed["P1_3"] = false;
			keyDict.pressed["P1_4"] = false;
			
			keyDict.pressed["P2_1"] = false;
			keyDict.pressed["P2_2"] = false;
			keyDict.pressed["P2_3"] = false;
			keyDict.pressed["P2_4"] = false;
			
			gameOver = false;
		}
		
		
		override public function hide():void{
			super.hide();
		}
		
		public function initModel():void{
			boardModel.char1Index.row = 0;
			boardModel.char1Index.col = 0;
			
			boardModel.char2Index.row = 0;
			boardModel.char2Index.col = boardModel.column-1;
			
			boardModel.char1Model.lastCharPos =	CharposEnum.DOWN;
			boardModel.char2Model.lastCharPos =	CharposEnum.DOWN;
			
			boardModel.p1HP = PLAYER_HP;
			boardModel.p2HP = PLAYER_HP;
		}
		
		public function initAngka():void{
			for (var i:int=0;i<CARD_ROW;i++) {
				var arrNumberColumn:Array = new Array(); 
				for (var j:int=0;j<CARD_COL;j++) {
					var numberCard:NumberCard = new NumberCard();
					addChild(numberCard);
					arrNumberColumn.push(numberCard);
				}
				arrNumberCard.push(arrNumberColumn);
			}
		}
		
		
		public function initSounds():void{
			soundBlip = (new PressMusic) as Sound;
			soundBoom = (new ExplodeMusic) as Sound;
			
		}
		
		public function initGUI():void{
			
			
			addChild(gameBG);
			
			var board_width:Number = CARD_COL * (CARD_WIDTH+CARD_MARGIN_RIGHT_SINGLE);
			CARD_MARGIN_RIGHT = (main.stage.stageWidth - board_width)/2;
			
			//Number Cards
			initAngka();
			for (var i:int=0;i<CARD_ROW;i++) {
				for (var j:int=0;j<CARD_COL;j++) {
					
					var numberCard:NumberCard = arrNumberCard[i][j];
					
					//flag
					numberCard.blueFlag.gotoAndStop(FlaganimEnum.PLUS);
					numberCard.redFlag.gotoAndStop(FlaganimEnum.PLUS);
					numberCard.blueFlag.visible = false;
					numberCard.redFlag.visible = false;
					
					numberCard.x = CARD_MARGIN_RIGHT + (j*(CARD_WIDTH+CARD_MARGIN_RIGHT_SINGLE));
					numberCard.y = CARD_MARGIN_TOP + (i*(CARD_HEIGHT + CARD_MARGIN_TOP_SINGLE));
					
					var posArr:Point = boardModel.charPosArr[i][j];
					posArr.x = numberCard.x+10;
					posArr.y = numberCard.y-50;
					
				}
			}
			
			
			//INITIALIZE PLAYER ANIMATION
			p1.p.gotoAndStop(CharanimEnum.FRONT_STOP);
			p2.p.gotoAndStop(CharanimEnum.FRONT_STOP);
			
			
			var coPoint:Point = boardModel.charPosArr[boardModel.char1Index.row][boardModel.char1Index.col];
			p1.x = coPoint.x;
			p1.y = coPoint.y;
			
			var cePoint:Point = boardModel.charPosArr[boardModel.char2Index.row][boardModel.char2Index.col];
			p2.x = cePoint.x;
			p2.y = cePoint.y;	
			
			addChild(p1TotalTakenMC);
			p1TotalTakenMC.x = 0;
			p1TotalTakenMC.y = TOTAL_TAKEN_MARGIN_Y;
			
			addChild(p2TotalTakenMC);
			p2TotalTakenMC.x = main.stage.stageWidth - p2TotalTakenMC.width;
			p2TotalTakenMC.y = TOTAL_TAKEN_MARGIN_Y;
			
			p1TotalTakenMC.label.text = "0";
			p2TotalTakenMC.label.text = "0";
			
			// LIFE BAR
			p1LifeBarMC.x = 0;
			p1LifeBarMC.y = LIFEBAR_MARGIN_Y;
			
			p2LifeBarMC.x = main.stage.stageWidth - p2LifeBarMC.width;
			p2LifeBarMC.y = LIFEBAR_MARGIN_Y;
			
			//take the sample of width from player 1
			LIFEBAR_WIDTH = p1LifeBarMC.width;
			
			addChild(p1LifeBarMC);
			addChild(p2LifeBarMC);
			
			//TARGET NUMBER
			targetNumber = new TargetNumberEty(boardModel.boardArr);
			targetNumber.random();
			addChild(targetNumber);
			targetNumber.x = main.stage.stageWidth/2;
			
			addChild(p1);
			addChild(p2);
			
			//ending
			
			p1AnimEnd.scaleX = 3;
			p2AnimEnd.scaleX = 3;
			
			p1AnimEnd.scaleY = 3;
			p2AnimEnd.scaleY = 3;
			
			p1AnimEnd.mataSedihMC.visible = false;
			p1AnimEnd.mataSenangMC.visible = false;	
			p1AnimEnd.x = P1_ANIM_END_MARGIN_LEFT;
			p1AnimEnd.y = ANIM_END_MARGIN_TOP;
			
			p2AnimEnd.mataSedihMC.visible = false;
			p2AnimEnd.mataSenangMC.visible = false;
			p2AnimEnd.x = main.stage.stageWidth - P2_ANIM_END_MARGIN_RIGHT;
			p2AnimEnd.y = ANIM_END_MARGIN_TOP;
			
			addChild(p1AnimEnd);
			addChild(p2AnimEnd);
			
			var textEndingFormat:TextFormat = new TextFormat();
			textEndingFormat.size = 50;
			textEndingFormat.align = TextAlign.CENTER;
			
			textEnding = new TextField();
			textEnding.defaultTextFormat = textEndingFormat;
			textEnding.width = 550;
			textEnding.backgroundColor = 0xffffff;
			textEnding.background = true;
			
			addChild(textEnding);
			textEnding.text = "Press Start to play again";
			textEnding.x = 400;
			textEnding.y = 500;
			
			
			endingAnim(false, 0);
//			endingAnim(true, 1);
		}
		
		private function keypadPolling():void{
			// --------------- PLAYER 1 --------------- 
			
			if (p1_poll) {
				
				// Movement
				
				//UP
				if (main.binder.isActionActivated("P1_UP")) {
					boardModel.charMove(1, CharposEnum.UP);
					p1.p.gotoAndStop(CharanimEnum.BACK);
					
					boardModel.char1Model.lastCharPos = CharposEnum.UP;
				}
				
				//RIGHT
				if (main.binder.isActionActivated("P1_RIGHT")) {
					boardModel.charMove(1, CharposEnum.RIGHT);
					p1.p.gotoAndStop(CharanimEnum.RIGHT);
					
					boardModel.char1Model.lastCharPos = CharposEnum.RIGHT;
				}
				
				//LEFT
				if (main.binder.isActionActivated("P1_LEFT")) {
					boardModel.charMove(1, CharposEnum.LEFT);
					p1.p.gotoAndStop(CharanimEnum.LEFT);
					
					boardModel.char1Model.lastCharPos = CharposEnum.LEFT;
				}
				
				//DOWN
				if (main.binder.isActionActivated("P1_DOWN")) {
					boardModel.charMove(1, CharposEnum.DOWN);
					p1.p.gotoAndStop(CharanimEnum.FRONT);
					
					boardModel.char1Model.lastCharPos = CharposEnum.DOWN;
				}
			}
			
			
			//ACTION
			if (boardModel.playBoardArr[boardModel.char1Index.row][boardModel.char1Index.col] != 2) {				
				//check the current card doesn't own by another player
				
				//ADDITION
				if (main.binder.isActionActivated("P1_1") &&  keyDict.pressed["P1_1"] == false) {
					
					//set
					setFlagOnNumberCard(boardModel.char1Index.row,
						boardModel.char1Index.col,
						1,
						1);
					
					
					keyDict.pressed["P1_1"] = true;
					
					boardModel.playBoardArr[boardModel.char1Index.row][boardModel.char1Index.col] = 1;
					
					addTakenCard(1, 
						boardModel.char1Index.row, boardModel.char1Index.col,
						boardModel.getBoardValueAt(boardModel.char1Index.row, boardModel.char1Index.col),
						1);
					soundBlip.play();
				}
				
				//SUBTRACTION
				if (main.binder.isActionActivated("P1_2") && keyDict.pressed["P1_2"] == false ) {
					
					setFlagOnNumberCard(boardModel.char1Index.row,
						boardModel.char1Index.col,
						1,
						2);
					
					keyDict.pressed["P1_2"] = true;
					
					boardModel.playBoardArr[boardModel.char1Index.row][boardModel.char1Index.col] = 1;
					
					addTakenCard(1, 
						boardModel.char1Index.row, boardModel.char1Index.col,
						boardModel.getBoardValueAt(boardModel.char1Index.row, boardModel.char1Index.col),
						2);
					soundBlip.play();
				}
				
				//CLEAR
				if (main.binder.isActionActivated("P1_4") && keyDict.pressed["P1_4"] == false) {
					
					setFlagOnNumberCard(boardModel.char1Index.row,
						boardModel.char1Index.col,
						1,
						0);
					
					boardModel.playBoardArr[boardModel.char1Index.row][boardModel.char1Index.col] = 0;
					
					removeTakenCard(1, boardModel.char1Index.row, boardModel.char1Index.col);
				}
			}
			
			//SUM
			if (main.binder.isActionActivated("P1_3") && keyDict.pressed["P1_3"] == false) {
				//TODO: Jumlahkan
				keyDict.pressed["P1_3"] = true;
				
				attack(1, boardModel.p1Sum);
				
			}
			
			
			
			
			// --------------- PLAYER 2 --------------- 
			if (p2_poll) {
				
				if (main.binder.isActionActivated("P2_UP")) {
					boardModel.charMove(2, CharposEnum.UP);
					p2.p.gotoAndStop(CharanimEnum.BACK);
					
					boardModel.char2Model.lastCharPos = CharposEnum.UP;
				}
				
				if (main.binder.isActionActivated("P2_RIGHT")) {
					boardModel.charMove(2, CharposEnum.RIGHT);
					p2.p.gotoAndStop(CharanimEnum.RIGHT);
					
					boardModel.char2Model.lastCharPos = CharposEnum.RIGHT;
				}
				
				if (main.binder.isActionActivated("P2_LEFT")) {
					boardModel.charMove(2, CharposEnum.LEFT);
					p2.p.gotoAndStop(CharanimEnum.LEFT);
					
					boardModel.char2Model.lastCharPos = CharposEnum.LEFT;
				}
				
				if (main.binder.isActionActivated("P2_DOWN")) {
					boardModel.charMove(2, CharposEnum.DOWN);
					p2.p.gotoAndStop(CharanimEnum.FRONT);
					
					boardModel.char2Model.lastCharPos = CharposEnum.DOWN;
				}
			}
			
			//ACTION
			if (boardModel.playBoardArr[boardModel.char2Index.row][boardModel.char2Index.col] != 1) {
				//check the current card doesn't own by another player
				
				//ADDITION
				if (main.binder.isActionActivated("P2_1") && keyDict.pressed["P2_1"] == false) {
					
					//set
					setFlagOnNumberCard(boardModel.char2Index.row,
						boardModel.char2Index.col,
						2,
						1);
					
					keyDict.pressed["P2_1"] = true;
					
					boardModel.playBoardArr[boardModel.char2Index.row][boardModel.char2Index.col] = 2;
					
					addTakenCard(2, 
						boardModel.char2Index.row, boardModel.char2Index.col,
						boardModel.getBoardValueAt(boardModel.char2Index.row, boardModel.char2Index.col),
						1);
					soundBlip.play();
				}
				
				//SUBTRACTION
				if (main.binder.isActionActivated("P2_2") && keyDict.pressed["P2_2"] == false ) {
					
					setFlagOnNumberCard(boardModel.char2Index.row,
						boardModel.char2Index.col,
						2,
						2);
					
					keyDict.pressed["P2_2"] = true;
					
					boardModel.playBoardArr[boardModel.char2Index.row][boardModel.char2Index.col] = 2;
					
					addTakenCard(2, 
						boardModel.char2Index.row, boardModel.char2Index.col,
						boardModel.getBoardValueAt(boardModel.char2Index.row, boardModel.char2Index.col),
						2);
					soundBlip.play();
				}
				
				//CLEAR
				if (main.binder.isActionActivated("P2_4") && keyDict.pressed["P2_4"] == false) {
					
					setFlagOnNumberCard(boardModel.char2Index.row,
						boardModel.char2Index.col,
						2,
						0);
					
					boardModel.playBoardArr[boardModel.char2Index.row][boardModel.char2Index.col] = 0;
					
					removeTakenCard(2, boardModel.char2Index.row, boardModel.char2Index.col);
				}
				
			}
			
			//SUM
			if (main.binder.isActionActivated("P2_3") && keyDict.pressed["P2_3"] == false) {
				//TODO: Jumlahkan
				keyDict.pressed["P2_3"] = true;
				attack(2, boardModel.p2Sum);
				
				
			}
			
			
			checkGame();
		}
		
		
		/**
		 * 	setFlagOnNumberCard untuk tampilan
		 * 
		 *  value:
		 *	0 = kosong
		 *  1 = positif
		 *  2 = negatif
		 * 
		 **/
		public function setFlagOnNumberCard(row:int, column:int, playerNumber:int, value:int):void{
			var numberCard:NumberCard = arrNumberCard[row][column];
			
			if (playerNumber == 1) {
				numberCard.blueFlag.visible = true;
				if (value == 1) {
					numberCard.blueFlag.gotoAndStop(FlaganimEnum.PLUS);
				}else if (value == 2) {
					numberCard.blueFlag.gotoAndStop(FlaganimEnum.MINUS);
				}else if (value == 0) {
					numberCard.blueFlag.visible = false;
				}
				
			}else if(playerNumber == 2){
				numberCard.redFlag.visible = true;
				if (value == 1) {
					numberCard.redFlag.gotoAndStop(FlaganimEnum.PLUS);
				}else if (value == 2) {
					numberCard.redFlag.gotoAndStop(FlaganimEnum.MINUS);
				}else if (value == 0) {
					numberCard.redFlag.visible = false;
				}
			}
			
		}
		
		/*
		*	put taken card on board
		*	
		*	sign
		*  1 = positive
		*  2 = negative
		*/
		public function addTakenCard(playerNum:int, row:int, col:int, valueTaken:int, sign:int):void{
			
			
			var takenCardIndex:int = boardModel.takenCardIndex(playerNum, row, col);
			
			//movie clip
			var _takenCardMC:NumberTaken;
			
			if (takenCardIndex == -1) {
				//check first whether the player had the card
				
				//new card
				
				_takenCardMC = new NumberTaken();
				
				_takenCardMC.label.text = valueTaken.toString();
				_takenCardMC.MinusMC.visible = false;
				_takenCardMC.PlusMC.visible = false;
				
				//sign
				if (sign == 1) {
					_takenCardMC.PlusMC.visible = true;
				}else if (sign == 2) {
					_takenCardMC.MinusMC.visible = true;
				}
				
				addChild(_takenCardMC);
				
				
				
				if (playerNum == 1) {
					
					_takenCardMC.x = 0;
					_takenCardMC.y = (boardModel.p1TakenCards.length*_takenCardMC.height)+TAKEN_CARD_MARGIN_TOP;
					
					//index of this MC
					p1TakenCardMCs.push(_takenCardMC);
					
				}else if (playerNum == 2){
					
					_takenCardMC.x = stage.stageWidth - _takenCardMC.width;
					_takenCardMC.y = (boardModel.p2TakenCards.length*_takenCardMC.height)+TAKEN_CARD_MARGIN_TOP;
					
					//index of this MC
					p2TakenCardMCs.push(_takenCardMC);
				}
				
				
				//add to model
				boardModel.addTakenCard(playerNum, row, col, valueTaken, sign);
				
			}else{
				//change card
				var _takenCardModel:TakenCardModel;
				//index of model and mc is same
				
				if (playerNum == 1) {
					_takenCardMC = p1TakenCardMCs[takenCardIndex];
					_takenCardModel = boardModel.p1TakenCards[takenCardIndex];
				}else{
					_takenCardMC = p2TakenCardMCs[takenCardIndex];
					_takenCardModel = boardModel.p2TakenCards[takenCardIndex];
				}
				
				_takenCardMC.MinusMC.visible = false;
				_takenCardMC.PlusMC.visible = false;
				
				//sign
				if (sign == 1) {
					_takenCardMC.PlusMC.visible = true;
					_takenCardModel.sign = 1;
				}else if (sign == 2) {
					_takenCardMC.MinusMC.visible = true;
					_takenCardModel.sign = 2;
				}
			}
			
			//set the total number in view and model
			if (playerNum == 1) {
				p1TotalTakenMC.label.text = boardModel.getSumTaken(playerNum).toString();
			}else if (playerNum == 2) {
				p2TotalTakenMC.label.text = boardModel.getSumTaken(playerNum).toString();
			}		
		}
		
		public function removeTakenCard(playerNum:int, row:int, col:int):void{
			
			//check first whether the player had the card
			var takenCardIndex:int = boardModel.takenCardIndex(playerNum, row, col);
			var takenCards:Array;
			var takenCardsMC:Array;
			
			if (takenCardIndex > -1) {
				
				//MovieClip
				//simpan movieClip
				var takenCardTmp:NumberTaken;
				
				if (playerNum == 1) {
					
					//hapus di MODEL
					takenCards = boardModel.p1TakenCards;
					
					takenCardsMC = p1TakenCardMCs;
					
					takenCardTmp = p1TakenCardMCs[takenCardIndex];
				}else if (playerNum == 2) {
					
					//hapus di MODEL
					takenCards = boardModel.p2TakenCards;
					
					takenCardsMC = p2TakenCardMCs;
					
					takenCardTmp = p2TakenCardMCs[takenCardIndex];
				}
				
				takenCards.splice(takenCardIndex, 1);
				takenCardsMC.splice(takenCardIndex, 1);
				
				removeChild(takenCardTmp);
				
				var i:int;
				//reposition taken card
				for (i = 0; i < takenCards.length; i++) {
					var _takenCardMC:NumberTaken = takenCardsMC[i];
					
					if (playerNum == 1) {
						_takenCardMC.x = 0;	
					}else if (playerNum == 2) {
						_takenCardMC.x = stage.stageWidth - _takenCardMC.width;;	
					}
					
					_takenCardMC.y = (i*_takenCardMC.height)+TAKEN_CARD_MARGIN_TOP;	
				}
				
			}
			
			//set the total number in view and model
			if (playerNum == 1) {
				p1TotalTakenMC.label.text = boardModel.getSumTaken(playerNum).toString();
			}else if (playerNum == 2) {
				p2TotalTakenMC.label.text = boardModel.getSumTaken(playerNum).toString();
			}
			
		}
		
		public function attack(fromPlayerNum:int, attackPoint:int):void {
			
			if (attackPoint == targetNumber.number) {
				soundBoom.play();
				
				
				if (fromPlayerNum == 1) {
					//player 1 attack player 2
					
					//decrease the player2's HP by number of cards used
					boardModel.p2HP -= boardModel.p1TakenCards.length;
					
					
				}else if (fromPlayerNum == 2) {
					//player 2 attack player 1
					
					//decrease the player1's HP by number of cards used
					boardModel.p1HP -= boardModel.p2TakenCards.length;
					
				}
				
				//random the next sun number
				targetNumber.random();
				
				//reset all players taken cards
				resetTakenCard(fromPlayerNum);
				
				//reset the sum number
				boardModel.p1Sum = 0;
				p1TotalTakenMC.label.text = boardModel.p1Sum.toString();
				
				boardModel.p2Sum = 0;
				p2TotalTakenMC.label.text = boardModel.p2Sum.toString();
				
				
			}
			
		}
		
		public function removeTakenCardAfterAnimate(_takenCard:NumberTaken):void{
			removeChild(_takenCard);
		}
		
		
		public function resetTakenCard(attackerNum:int):void{
			
			var i:int;
			var j:int;
			var _takenCardMC:NumberTaken;
			
			//remove player 1 cards
			var _takenCards:Array = boardModel.p1TakenCards;
			var _takenCardsMC:Array = p1TakenCardMCs;
			
			for (i= 0; i < _takenCards.length; i++) {
				_takenCardMC = _takenCardsMC[i];
				if (attackerNum == 1) {
					//efek attack 
					Actuate.tween(_takenCardMC, 0.6, {x: p2LifeBarMC.x, y:p2LifeBarMC.y}).onComplete(removeTakenCardAfterAnimate, _takenCardMC);	
				}else{
					removeChild(_takenCardMC);	
				}
			}
			
			//remove player 2 cards
			_takenCards = boardModel.p2TakenCards;
			_takenCardsMC = p2TakenCardMCs;
			
			for (i= 0; i < _takenCards.length; i++) {
				_takenCardMC = _takenCardsMC[i];
				if (attackerNum == 2) {
					//efek attack 
					Actuate.tween(_takenCardMC, 0.6, {x: p1LifeBarMC.x, y:p1LifeBarMC.y}).onComplete(removeTakenCardAfterAnimate, _takenCardMC);
				}else{
					removeChild(_takenCardMC);	
				}
				
			}
			
			//empty model
			boardModel.p1TakenCards = [];
			boardModel.p2TakenCards = [];
			
			//empty array of taken cards
			p1TakenCardMCs = [];
			p2TakenCardMCs = [];
			
			for (i = 0; i < CARD_ROW; i++) {
				for (j = 0; j < CARD_COL; j++) {
					
					//reset the play mat
					var numberCard:NumberCard = arrNumberCard[i][j];
					numberCard.blueFlag.visible = false;
					numberCard.redFlag.visible = false;
					
					//reset the board
					boardModel.playBoardArr[i][j] = 0;
				}
			}
			
			//reset the total sum for player
			p1TotalTakenMC.label.text = boardModel.getSumTaken(1).toString();
			p2TotalTakenMC.label.text = boardModel.getSumTaken(2).toString();
			
			
		}
		
		
		private function checkGame():void
		{
			
			
			if (boardModel.p1HP <= 0) {
				//player 1 loose
								
				isPlay = false;
				endingAnim(true, 2);
				
				gameOver = true;
				
			}else if (boardModel.p2HP <= 0) {
				//player 2 loose
				
				isPlay = false;
				endingAnim(true, 1);
			
				gameOver = true;
			}
			
		}
		
		public function endingAnim(visible:Boolean, winner:int):void{
			if (visible){
				
				
				if (winner == 1) {
					p1AnimEnd.mataSedihMC.visible = false;
					p1AnimEnd.mataSenangMC.visible = true;
					
					p2AnimEnd.mataSedihMC.visible = true;
					p2AnimEnd.mataSenangMC.visible = false;
					
					p2AnimEnd.label.text = "You lose :(";
					p1AnimEnd.label.text = "You win! :)";
					
				}else if (winner == 2) {
					p1AnimEnd.mataSedihMC.visible = true;
					p1AnimEnd.mataSenangMC.visible = false;
					
					p2AnimEnd.mataSedihMC.visible = false;
					p2AnimEnd.mataSenangMC.visible = true;
					
					p2AnimEnd.label.text = "You win! :)";
					p1AnimEnd.label.text = "You lose! :(";
				}
				
				p1AnimEnd.visible = true;
				p2AnimEnd.visible = true;
				
				textEnding.visible = true;
				
			}else{
				p1AnimEnd.visible = false;
				p2AnimEnd.visible = false;
				textEnding.visible = false;
			}
		}
		
	}
}