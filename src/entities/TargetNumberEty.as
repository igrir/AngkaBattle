package entities
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class TargetNumberEty extends MovieClip
	{
		public var randomNumberMC:TargetNumber = new TargetNumber();
		public var arrNumber:Array = new Array();
		
		public var arrPosition:Array = new Array();
		public var rowlength:Number;
		public var collength:Number;
		
		public var number:Number;
		
		public function TargetNumberEty(arrNumber:Array)
		{
			this.arrNumber = arrNumber;
			
			addChild(randomNumberMC);
			
			//init arrPosition untuk index
			rowlength = arrNumber.length;
			collength = arrNumber[0].length;
			for (var i:int = 0; i < rowlength; i++) {
				for (var j:int = 0; j < collength; j++) {
					var pos:Array = new Array(i,j);
					arrPosition.push(pos);
				}
			}
			
		}
		
		public function random():void{
			
			//reset number
			number = 0;
			
			var numNumber:int = Math.floor(Math.random()*5)+2;
			var numberArray:Array = new Array();
			
			var i:int;
			
			for (i = 0; i < numNumber;i++) {
				var randomInt:int;
				do{
					randomInt = Math.floor(Math.random()*(rowlength*collength));
					trace("search");
				}while(numberArray.indexOf(randomInt) > -1);
				numberArray.push(randomInt);
			}
			
			//set the random
			for ( i= 0; i < numberArray.length; i++) {
				var randomSign:Number = Math.floor(Math.random()*2);
				
				if (randomSign == 1) {
					
					number += arrNumber[arrPosition[i][0]][arrPosition[i][1]];	
				}else{
					number -= arrNumber[arrPosition[i][0]][arrPosition[i][1]];
				}
				
			}
			
			//set to the text
			randomNumberMC.label.text = number.toString();
			
		}
	}
}