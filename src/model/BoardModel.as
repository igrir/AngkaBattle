package model
{
	import flash.geom.Point;
	import enum.*;
	
	public class BoardModel
	{
		/*
		 * Board berisi angka-angka yang ada di dalam permainan
		 */
		public var boardArr:Array = new Array();
		
		/*
		* Board berisi kondisi permainan
		* 0 = kosong
		* 1 = pemain 1
		* 2 = pemain 2
		*/
		public var playBoardArr:Array = new Array();
		
		/*
		 * Posisi board sesungguhnya untuk posisi player
		 */
		public var charPosArr:Array = new Array();
		
		/*
		 * index pemain di atas papan dalam bentuk matrix 2x2
		*/
		public var char1Index:CharIndex = new CharIndex(0,0);
		public var char2Index:CharIndex = new CharIndex(0,0);
		
		/*
		* model pemain, seperti arah terakhir pemain
		*/
		public var char1Model:CharModel = new CharModel();
		public var char2Model:CharModel = new CharModel();
						
		/*
		* posisi flag dari kepemilikan karakter
		* hanya flag yang sudah dipilih dimasukkan ke dalam array ini
		* !! menggunakan TakenCardModel !!
		*/
		public var p1TakenCards:Array = new Array();
		public var p2TakenCards:Array = new Array();
		
		/*
		 * Total nilai kartu yang diambil pemain
		 */
		public var p1Sum:Number = 0;
		public var p2Sum:Number = 0;
		
		/*
		 * players HP
		 */
		public var p1HP:Number = 0;
		public var p2HP:Number = 0;
		
		public var row:int;
		public var column:int;
		
		public var numbersArr:Array = new Array(1,2,3,4,5,6,7,8,9);
		
		
		public function BoardModel(row:int, column:int)
		{
			this.row = row;
			this.column = column;
			
			for (var i:int=0;i<row;i++) {
				
				var _boardArr:Array = new Array();
				
				var _playBoardArr:Array = new Array();
				
				var charPos:Array = new Array();
				
				for (var j:int=0;j<column;j++) {
					_boardArr.push(0);
					_playBoardArr.push(0);
					
					charPos.push(new Point(0,0));
						
				}
				
				boardArr.push(_boardArr);
				playBoardArr.push(_playBoardArr);
				charPosArr.push(charPos);
				
			}
			
			randomBoard();
		}
		
		
		public function reset():void{
			for (var i:int=0;i<row;i++) {
								
				for (var j:int=0;j<column;j++) {
					boardArr[i][j] = 0;
					playBoardArr[i][j] = 0;
				}				
			}
			
			//random
			randomBoard();
			p1Sum = 0;
			p2Sum = 0;
			
		}
		
		
		/**
		 * Random angka pada board
		 */		
		public function randomBoard():void{

			for (var i:Number = 0; i < row; i++) {
				for (var j:Number = 0; j < column; j++) {
					var number:Number = numbersArr[Math.floor(Math.random()*numbersArr.length)];
					
					boardArr[i][j] = number;
				}
			}
		}
		
		/**
		 * Menggerakkan posisi karakter
		 */
		public function charMove(charNumber:int, charpos_movement:int):void{

			var char:CharIndex;
			if (charNumber == 1) {
				char = char1Index;
			}else if(charNumber == 2){
				char = char2Index;
			}else{
				return;
			}
			

			switch(charpos_movement)
			{
				case CharposEnum.UP:
				{
					if (char.row >= 0 && char.row < row && char.row-1 > -1) {
						char.row--;
					}
					break;
				}
				case CharposEnum.RIGHT:
				{
					if (char.col >= 0 && char.col < column-1 && char.col-1 < column-1) {
						char.col++;
					}
					break;
				}
				case CharposEnum.DOWN:
				{
					if (char.row >= 0 && char.row < row-1 && char.col-1 < column-1) {
						char.row++;
					}
					break;	
				}
				case CharposEnum.LEFT:
				{
					if (char.col >= 0 && char.col < column && char.col-1 > -1) {
						char.col--;
					}
					break;	
				}
					
				default:
				{
					break;
				}
			}
		}
		
		/**
		 * Kepemilikan papan permainan
		 * 0 = kosong
		 * 1 = pemain 1
		 * 2 = pemain 2
		 **/
		public function setPlayBoardArr(_row:int, _col:int, _value:int):void{
			playBoardArr[_row][_col] = _value;
		}
		
		/**
		 * Menambah flag kepemilikan pemain
		 */
		public function addTakenCard(playerNum:Number, _row:int, _col:int, _value:int, _sign:int):void{
			var fm:TakenCardModel = new TakenCardModel(_row, _col, _value, _sign);
			if (playerNum == 1) {
				p1TakenCards.push(fm);
			}else if (playerNum == 2) {
				p2TakenCards.push(fm);
			}
		}
	
		public function getBoardValueAt(_row:int, _col:int):int{
			var number:int = boardArr[_row][_col];
			
			return number;
		}
		
		/**
		 * Sum of taken cards
		 **/
		public function getSumTaken(playerNum:Number):Number{
			var totalNum:Number = 0;
			var i:int;
			var arrTaken:Array;
			
			if (playerNum == 1) {
				arrTaken = p1TakenCards;	
			}else if (playerNum == 2) {
				arrTaken = p2TakenCards;
			}
			
			//Summarize in takenCardModel belongs to player
			for (i = 0; i < arrTaken.length; i++) {
				var _takenCardModel:TakenCardModel = arrTaken[i];
				
				if (_takenCardModel.sign == 1) {
				//if positive
					totalNum +=  _takenCardModel.value;	
				}else if (_takenCardModel.sign == 2) {
				//if negative
					totalNum -=  _takenCardModel.value;
				}
				
			}
			
			if (playerNum == 1) {
				p1Sum = totalNum;
			}else if (playerNum == 2) {
				p2Sum = totalNum;
			}
			
			return totalNum;
		}
		
		/**
		 * Mencari kartu sudah pernah diambil
		 */
		public function takenCardIndex(playerNum:Number, _row:int, _col:int):int{
			var i:int;
			var takenCards:Array;
			if (playerNum == 1) {
				takenCards = p1TakenCards;
			}else if (playerNum == 2) {
				takenCards = p2TakenCards;
			}
			
			var found:Boolean = false;
			
			while (!found && i < takenCards.length) {
				var _takenCard:TakenCardModel = takenCards[i];
				if (_takenCard.row == _row && _takenCard.col == _col) {
					return i;
				}else{
					i++;	
				}

			}
			
			return -1;
		}
		
	}
}