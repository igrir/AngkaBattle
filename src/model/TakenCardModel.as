package model
{
	public class TakenCardModel
	{
		
		public var sign:int;	//positif = 1,negatif = 2
		public var value:int;
		public var row:int;
		public var col:int;
		
		
		public function TakenCardModel(_row:int, _col:int, _value:int, _sign:int)
		{
			row = _row;
			col = _col;
			value = _value;
			sign = _sign;
		}
	}
}