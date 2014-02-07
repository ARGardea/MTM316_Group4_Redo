package
{
	public class MyShapeType{
		
		public var Value:int;
		public static const RECTANGLE: MyShapeType = new MyShapeType();
		public static const ELLIPSE: MyShapeType = new MyShapeType();
		public static const TEXTBOX: MyShapeType = new MyShapeType();
		
		public static var AllTypes: Array = [];
		
		public static function InitTypes(){
			RECTANGLE.Value = 0;
			ELLIPSE.Value = 1;
			TEXTBOX.Value = 2;
			
			AllTypes.push(RECTANGLE);
			AllTypes.push(ELLIPSE);
			AllTypes.push(TEXTBOX);
		}
		
		public static function ReturnType(target:int): MyShapeType{
			var result: MyShapeType = null;
			for each (var m:MyShapeType in AllTypes){
				if(m.Value == target){
					result = m;
				}
			}
			return result;
		}
	}
}