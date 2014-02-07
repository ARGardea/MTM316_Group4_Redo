package
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class MyShape extends Sprite
	{
		public var shapeType: MyShapeType
		
		public var color: uint;
		public var xOffset: Number;
		public var yOffset: Number;
		
		public var endX: Number;
		public var endY: Number;
		
		public var endXDifferent: Boolean;
		public var endYDifferent: Boolean;
		
		public var lineXDifference: Number;
		public var lineYDifference: Number;
		
		public var textBox: TextField;
		public var textFormat: TextFormat;
		
		public function MyShape(shapeType: MyShapeType)
		{
			this.shapeType = shapeType;
			super();
		}
		
		public function BeginColor(newColor:uint){
			this.color = newColor;
			this.graphics.beginFill(color);
		}
		
		public function ChangeColor(newColor:uint){
			var transform: ColorTransform = new ColorTransform();
			color = newColor;
			transform.color = newColor;
			this.transform.colorTransform = transform;
		}
		
		public function setSelectable(value: Boolean){
			if(textBox != null){
				textBox.selectable = value;
			}
		}
		
		public function RedrawLine(endX:Number, endY:Number){
			graphics.clear();
			DrawLine(endX, endY);
		}
		
		public function DrawLine(endX:Number, endY:Number){
			graphics.lineStyle(5, color, 1);
			
			this.endX = endX;
			this.endY = endY;
			
			this.endXDifferent = (this.endX < 0);
			this.endYDifferent = (this.endY < 0);
			
			graphics.lineTo(endX, endY);
			
		}
		
		public function DrawTextBox(w:Number, h:Number){
			textBox = new TextField();
			textFormat = new TextFormat();
			
			textFormat.size = 15;
			
			textBox.text = "Enter Text Here.";
			textBox.height = h;
			textBox.width = w;
			textBox.type = TextFieldType.INPUT;
			textBox.defaultTextFormat = textFormat;
			textBox.border = true;
			textBox.wordWrap = true;
			
			addChild(textBox);
		}
		
		public function DrawShape(w:Number, h:Number){
			if(shapeType == MyShapeType.RECTANGLE){
				this.graphics.drawRect(0, 0, w, h);
			}else if(shapeType == MyShapeType.ELLIPSE){
				this.graphics.drawEllipse(0, 0, w, h);
			}else if(shapeType == MyShapeType.TEXTBOX){
				DrawTextBox(w, h);
			}
			
			graphics.endFill();
		}
	}
}