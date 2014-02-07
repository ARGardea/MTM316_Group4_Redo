package {
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.display.Loader;
	import flash.display.LoaderInfo;

	public class ShapeSaver {

		private var xmlData: XML;
		public var button: Sprite;
		public var button2: Sprite;
		public var buttonWidth: Number = 50;
		public var buttonHeight: Number = 25;
		public var theStageRef: MovieClip
		public var myShapesRef: Array;
		public var loadedShapes: Array;
		
		public var shapesLoaded: Function;
		
		public var fileLoader: FileReference;

		public function ShapeSaver(theStage: MovieClip, shapesRef: Array, shapesLoaded: Function) {
			// constructor code
			theStageRef = theStage;
			myShapesRef = shapesRef;
			this.shapesLoaded = shapesLoaded;
			this.Initialize();
		}

		private function DrawButton() {
			button = new Sprite();
			button.x = 10;
			button.y = 10;
			button.graphics.beginFill(0xFF00FF);
			button.graphics.lineStyle(1, 0xFFFFFF);
			button.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
			theStageRef.addChild(button);
			
			button2 = new Sprite();
			button2.x = buttonWidth + 20;
			button2.y = 10;
			button2.graphics.beginFill(0xFFFFFF);
			button2.graphics.lineStyle(1, 0x000000);
			button2.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
			theStageRef.addChild(button2);
		}

		private function Initialize() {
			//DrawButton();
			//button2.addEventListener(MouseEvent.MOUSE_DOWN, LoadButtonHandler);
			//button.addEventListener(MouseEvent.MOUSE_DOWN, MouseDownHandler);

			xmlData = <xmlData> 
						<test> data </test>
					  </xmlData>;
		}

		function SaveButtonHandler(e: MouseEvent) {
			var ba: ByteArray = new ByteArray();
			ba.writeUTFBytes(ProcessShapeArray(myShapesRef));

			var fr: FileReference = new FileReference();
			fr.addEventListener(Event.SELECT, RefSelectHandler);
			fr.addEventListener(Event.CANCEL, RefSelectCancel);

			fr.save(ba, "filename.xml");
		}

		function LoadButtonHandler(e:Event){
			LoadXML();
		}
		
		function LoadXML(){
			fileLoader = new FileReference();
			fileLoader.addEventListener(Event.SELECT, LoadSelectHandler);
			var fileFilter: FileFilter = new FileFilter("XML files: ( *.xml )", "*.xml");
			fileLoader.browse([fileFilter]);
		}
		
		function LoadSelectHandler(e:Event){
			fileLoader.removeEventListener(Event.SELECT, LoadSelectHandler);
			
			fileLoader.addEventListener(Event.COMPLETE, LoadCompleteHandler);
			fileLoader.load();
		}
		
		function LoadCompleteHandler(e:Event){
			fileLoader.removeEventListener(Event.COMPLETE, LoadCompleteHandler);

			xmlData = new XML(fileLoader.data);
			
			trace(xmlData);
			ProcessLoadedXML();
		}

		function RefSelectHandler(e: Event) {
			trace('select');
		}

		function RefSelectCancel(e: Event) {
			trace('cancel');
		}
		
		public function AddShapes(){
			for each(var s:MyShape in loadedShapes){
				theStageRef.addChild(s);
			}
		}
		
		public function ProcessLoadedXML(){
			loadedShapes = [];
			for(var i:int = 0; i < xmlData.myShape.length(); i++){
				var tempShape:MyShape = new MyShape(MyShapeType.ReturnType(xmlData.myShape[i].shapeType));
				tempShape.x = xmlData.myShape[i].xPosition;
				tempShape.y = xmlData.myShape[i].yPosition;
				var w: Number = xmlData.myShape[i].width;
				var h: Number = xmlData.myShape[i].height;	
				
//				if(shape.shapeType == MyShapeType.TEXTBOX){
//					s += "<textBox content=\"" + shape.textBox.text + "\"" +
//						" fontSize=\"" + shape.textFormat.size + "\">'";
//				}
				
				tempShape.BeginColor(xmlData.myShape[i].color);
				tempShape.DrawShape(w, h);
				
				if(tempShape.shapeType == MyShapeType.TEXTBOX){
					tempShape.textBox.text = xmlData.myShape[i].textBox.@content;
					tempShape.textFormat.size = xmlData.myShape[i].textBox.@fontSize;
				}
				
				loadedShapes.push(tempShape);
			}
			trace(xmlData);
			trace(xmlData.myShape.length());
			shapesLoaded(loadedShapes);
		}
		
		public function ProcessShapeArray(target:Array): XML{
			var s:String = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
			s += "<shapeData numShapes = \"" + target.length + "\">";
			var index:int = 0;
			for each(var i in target){
				var shape: MyShape = i as MyShape;
				s += "<myShape index=\"" + index + "\">";
				s += "<shapeType>" + shape.shapeType.Value + "</shapeType>";
				s += "<color>" + shape.color + "</color>";
				s += "<height>" + shape.height + "</height>";
				s += "<width>" + shape.width + "</width>";
				s += "<xPosition>" + shape.x + "</xPosition>";
				s += "<yPosition>" + shape.y + "</yPosition>";
				
				if(shape.shapeType == MyShapeType.TEXTBOX){
					s += "<textBox content=\"" + shape.textBox.text + "\"" +
						" fontSize=\"" + shape.textFormat.size + "\"></textBox>";
				}
				if(shape.shapeType == MyShapeType.LINE){
					
				}
				
				s += "</myShape>";
				index++;
			}
			s += "</shapeData>";
			
			var result: XML = new XML(s);
			return result;
		}

	}

}