package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class SpriteSelector extends Sprite
	{
		public static var theStage: MovieClip;
		
		public var target: MyShape;
		
		public var strokeColor:uint = 0x000000;
		public var anchorColor:uint = 0x000000;
		public var fillColor:uint = 0x00FFFFFF;
		
		public var box:Sprite;
		public var anchors: Dictionary; 
		public var anchorRadius: Number = 4;
		public var anchorNames: Array = [ "Top Left", "Top", "Top Right", "Right", "Bottom Right", "Bottom", "Bottom Left", "Left" ];
		
		public function SpriteSelector(target: MyShape)
		{	
			this.target = target;
			
			drawBox();
			
			this.height = target.height;
			this.width = target.width;
			
			
			this.x = target.x;
			this.y = target.y;
						
			DrawSelection();
		}
		
		private function drawBox(){
			box = new Sprite();
			
			var startX: Number = 0;
			var startY: Number = 0;
			
			box.graphics.beginFill(0, 0);
			box.graphics.lineStyle(1, strokeColor);
			box.graphics.drawRect(startX, startY, target.width, target.height);
			
			addChild(box);
		}
		
		public function ReselectShape(target: MyShape){
			this.target = target;
			
			//box.graphics.clear();
			
			//drawBox();
			
			this.x = target.x;
			this.y = target.y;
			
			this.width = target.width;
			this.height = target.height;
		}
		
		public function SelectShape(target: MyShape){
			this.target = target;
			box = new Sprite();
			
			var startX: Number = 0;
			var startY: Number = 0;
			
			box.graphics.beginFill(0, 0);
			box.graphics.lineStyle(1, strokeColor);
			box.graphics.drawRect(startX, startY, target.width, target.height);
			
			addChild(box);
			
			this.height = target.height;
			this.width = target.width;
			
			this.x = target.x;
			this.y = target.y;
			
			DrawSelection();
		}
		
		public function TrackTarget(){
			this.x = target.x;
			this.y = target.y;
		}
		
		public function ClearSelection(){
			for(var i:int = 0; i < anchorNames.length; i++){
				var node = anchors[anchorNames[i]] as Sprite;
				node.graphics.clear();
			}
			box.graphics.clear();
		}
		
		public function DrawSelection(){
			
			var current: Sprite;
			anchors = new Dictionary();
			
			var minX: Number = 0;
			var midX: Number = target.width/2;
			var maxX: Number = target.width;
			
			var minY: Number = 0;
			var midY: Number = target.height/2;
			var maxY: Number = target.height;
			
			anchors["Top Left"] = new Sprite();
			current = anchors["Top Left"];
			current.graphics.beginFill(anchorColor);
			current.graphics.drawCircle(minX, minY, anchorRadius);
			
			anchors["Top"] = new Sprite();
			current = anchors["Top"];
			current.graphics.beginFill(anchorColor);
			current.graphics.drawCircle(midX, minY, anchorRadius);
			
			anchors["Top Right"] = new Sprite();
			current = anchors["Top Right"];
			current.graphics.beginFill(anchorColor);
			current.graphics.drawCircle(maxX, minY, anchorRadius);
			
			anchors["Right"] = new Sprite();
			current = anchors["Right"];
			current.graphics.beginFill(anchorColor);
			current.graphics.drawCircle(maxX, midY, anchorRadius);
			
			anchors["Bottom Right"] = new Sprite();
			current = anchors["Bottom Right"];
			current.graphics.beginFill(anchorColor);
			current.graphics.drawCircle(maxX, maxY, anchorRadius);
			
			anchors["Bottom"] = new Sprite();
			current = anchors["Bottom"];
			current.graphics.beginFill(anchorColor);
			current.graphics.drawCircle(midX, maxY, anchorRadius);
			
			anchors["Bottom Left"] = new Sprite();
			current = anchors["Bottom Left"];
			current.graphics.beginFill(anchorColor);
			current.graphics.drawCircle(minX, maxY, anchorRadius);
			
			anchors["Left"] = new Sprite();
			current = anchors["Left"];
			current.graphics.beginFill(anchorColor);
			current.graphics.drawCircle(minX, midY, anchorRadius);
			
			for each (var anchor:Sprite in anchors){
				addChild(anchor);
			}
			
		}
	}
}