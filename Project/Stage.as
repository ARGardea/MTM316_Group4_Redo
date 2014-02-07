package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.globalization.LastOperationStatus;
	import flash.text.engine.TextBaseline;
	
	import fl.motion.MotionEvent;

	public class Stage extends MovieClip {
		var MasterMC: MovieClip;

		var Buttons: Array;
		var ButtonTexts: Array;
		var Tools: Array;
		var ToolIcons: Array;
		var ChangeColor: ColorTransform;
		var BasicShape: MyShape;
		var MouseTracker: Sprite;
		var shape: MyShape;
		
		var saver: ShapeSaver;
		var ourTextBox: TextBoxes;
		
		var shapeMover: ShapeMover;
		
		var myShapes: Array = [];
		var textBoxes: Array = [];
		
		var randomColor: uint;
		var random: Boolean;
		
		public function Stage() {
			MasterMC = new Master_MC();
			ChangeColor = new ColorTransform();
			random = true;
			MasterMC.x = 0;
			MasterMC.y = 0;
			
			MyShapeType.InitTypes();
			SpriteSelector.theStage = MasterMC.DrawingStage;
			shapeMover = new ShapeMover(MasterMC.DrawingStage);
			shapeMover.validSelection = SelectShape;
			saver = new ShapeSaver(MasterMC.DrawingStage, myShapes, AddShapes);

			SetupButtons();
			SetupTools();

			(MasterMC.FileWindow as MovieClip).visible = false;
			MasterMC.FileButton.gotoAndStop(1);
			MasterMC.FileWindow.FileLoadButton.addEventListener(MouseEvent.MOUSE_DOWN, saver.LoadButtonHandler);
			MasterMC.FileWindow.FileSaveButton.addEventListener(MouseEvent.MOUSE_DOWN, saver.SaveButtonHandler);
			MasterMC.FileButton.addEventListener(MouseEvent.CLICK, FileWindowClicked);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, DeleteHandler);
			
			MasterMC.DrawingStage.addEventListener(MouseEvent.MOUSE_MOVE, MouseOverStage);
			MasterMC.DrawingStage.addEventListener(MouseEvent.MOUSE_OUT, MouseOutOfStage);
			MasterMC.gotoAndStop(1);

			addChild(MasterMC);
		}
		
		function FileWindowClicked(e:MouseEvent){
			MasterMC.FileButton.gotoAndStop(2);
			MasterMC.FileButton.removeEventListener(MouseEvent.CLICK, FileWindowClicked);
			MasterMC.FileButton.addEventListener(MouseEvent.CLICK, HideFileWindowClicked);
			(MasterMC.FileWindow as MovieClip).visible = true;
		}
		
		function HideFileWindowClicked(e:MouseEvent){
			MasterMC.FileButton.gotoAndStop(1);
			MasterMC.FileButton.addEventListener(MouseEvent.CLICK, FileWindowClicked);
			MasterMC.FileButton.removeEventListener(MouseEvent.CLICK, HideFileWindowClicked);
			(MasterMC.FileWindow as MovieClip).visible = false;
		}
		
		public function DeleteShapes(){
			for each(var i: MyShape in myShapes){
				i.graphics.clear();
				i = null;
			}
			myShapes = [];
		}

		public function AddShapes(target:Array){
			DeleteShapes();
			for each(var i: MyShape in target){
				MasterMC.DrawingStage.addChild(i);
				myShapes.push(i);
			}
		}
		
		function RemoveShapeFromArray(target: MyShape, targetArray: Array){
			var index:Number = targetArray.indexOf(target);
			if(index >= 0){
				targetArray.splice(index, 1);
			}
		}
		
		function DeleteShape(target: MyShape){
			if(target.shapeType == MyShapeType.TEXTBOX){
				RemoveShapeFromArray(target, textBoxes);
			}
			RemoveShapeFromArray(target, myShapes);
			shapeMover.ClearSelection();
			target.graphics.clear();
			target = null;
		}
		
		function DeleteHandler(e: KeyboardEvent){
			var deleteCode:int = 46;
			if(shapeMover.selector != null){
				if(e.keyCode == deleteCode && shapeMover.selector.target != null){
					DeleteShape(shapeMover.selector.target);
				}
			}
		}
		
		function SelectShape(target: MyShape){
			if(target.shapeType == MyShapeType.ELLIPSE){
				MasterMC.gotoAndStop(2);
			}else if(target.shapeType == MyShapeType.RECTANGLE){
				MasterMC.gotoAndStop(3);
			}else if(target.shapeType == MyShapeType.LINE){
				MasterMC.gotoAndStop(4);
			}else if(target.shapeType == MyShapeType.TEXTBOX){
				MasterMC.gotoAndStop(5);
			}
			
			MasterMC.TextFieldBasicShapeY.text = target.y;
			MasterMC.TextFieldBasicShapeX.text = target.x;
			MasterMC.TextFieldBasicShapeWidth.text = target.width;
			MasterMC.TextFieldBasicShapeHeight.text = target.height;
			MasterMC.TextFieldBasicShapeFill.addEventListener(Event.CHANGE, UpdateShapePreview);
			MasterMC.TextFieldBasicShapeFill.text = target.color as uint;
			MasterMC.TextFieldBasicShapeWidth.addEventListener(Event.CHANGE, UpdateShapeDimensions);
			MasterMC.TextFieldBasicShapeHeight.addEventListener(Event.CHANGE, UpdateShapeDimensions);
			MasterMC.TextFieldBasicShapeX.addEventListener(Event.CHANGE, UpdateShapePosition);
			MasterMC.TextFieldBasicShapeY.addEventListener(Event.CHANGE, UpdateShapePosition);	
		}
		
		function UpdateShapeDimensions(e:Event){
			if(shapeMover.selector.target != null){
				shapeMover.selector.target.width = MasterMC.TextFieldBasicShapeWidth.text;
				shapeMover.selector.target.height = MasterMC.TextFieldBasicShapeHeight.text;
				
				var tempShape: MyShape = shapeMover.selector.target;
				shapeMover.SelectShape(tempShape);
			}
		}
		
		function UpdateShapePosition(e:Event){
			
			if(shapeMover.selector.target != null){
				shapeMover.selector.target.x = MasterMC.TextFieldBasicShapeX.text;
				shapeMover.selector.target.y = MasterMC.TextFieldBasicShapeY.text;
				
				shapeMover.selector.TrackTarget();
			}
		}
		
		function DeSelect(){
			if(shapeMover.selector != null){
				shapeMover.selector.ClearSelection();
			}
			MasterMC.TextFieldBasicShapeFill.removeEventListener(Event.CHANGE, UpdateShapePreview);
			MasterMC.TextFieldBasicShapeWidth.removeEventListener(Event.CHANGE, UpdateShapeDimensions);
			MasterMC.TextFieldBasicShapeHeight.removeEventListener(Event.CHANGE, UpdateShapeDimensions);
			MasterMC.TextFieldBasicShapeX.removeEventListener(Event.CHANGE, UpdateShapePosition);
			MasterMC.TextFieldBasicShapeY.removeEventListener(Event.CHANGE, UpdateShapePosition);
		}
		
		function CircleToolButtonPressed() {
			MasterMC.gotoAndStop(2);
			MouseTracker = DrawBasicShape(18, 18, 10, 10, 0x000000);
			MasterMC.DrawingStage.removeEventListener(MouseEvent.MOUSE_DOWN, shapeMover.ShapeClickHandler);
			DeSelect();
			DrawBasicShapeOnStage();
		}

		function DrawBasicShape(_x: int, _y: int, _width: int, _height: int, _fill: int) : MyShape {
			//BasicShape = new MyShape(MyShapeType.RECTANGLE);
			var newShape = new MyShape(MyShapeType.RECTANGLE);
			
			newShape.graphics.clear();
			
			newShape.x = _x;
			newShape.y = _y;
			
			newShape.BeginColor(_fill);
			
			if (MasterMC.currentFrame == 2){
				newShape.shapeType = MyShapeType.ELLIPSE;
			}
			else if (MasterMC.currentFrame == 3){
				newShape.shapeType = MyShapeType.RECTANGLE;
			}
			else if (MasterMC.currentFrame == 5){
				newShape.shapeType = MyShapeType.TEXTBOX;
			}
			
			newShape.DrawShape(_width, _height);
			newShape.graphics.endFill();
			
			return newShape;
		}
		
		function DrawTextBox(_x: int, _y: int, _width: int, _height: int) : TextBoxes {
			return new TextBoxes(_x, _y, _width, _height);
		}
		
		function DrawBasicShapeOnStage() {
			MouseTracker.x = MasterMC.mouseX;
			MouseTracker.y = MasterMC.mouseY;			
			
			AddDrawingEvents();
			SetupPreviewShape();
			addChild(MouseTracker);
		}
		
		function AddDrawingEvents() {
			MasterMC.addEventListener(MouseEvent.MOUSE_MOVE, MoveMouseTracker);			
			MasterMC.DrawingStage.addEventListener(MouseEvent.MOUSE_MOVE, UpdateXYTextField);
			MasterMC.TextFieldBasicShapeFill.addEventListener(Event.CHANGE, UpdateShapePreview);
			
			if(MasterMC.currentFrame == 4)
			{
				MasterMC.DrawingStage.addEventListener(MouseEvent.MOUSE_DOWN, DrawStartOfLine);
				MasterMC.DrawingStage.addEventListener(MouseEvent.MOUSE_UP, DrawEndOfLine);
			}else{
				MasterMC.DrawingStage.addEventListener(MouseEvent.CLICK, DrawBasicShapeOnClick);
			}
		}
		
		function RandomInt(): int {
			return (Math.random() * 100);
		}
		
		function RandomColor(): uint {
			randomColor = new uint();
			
			var values: Array = new Array(6);
			
			for (var index:int = 0; index < values.length; index++) {
				var num: String = new String();
				
				var ranNum:uint = uint(Math.random() * 15);
					
				num = "" + ranNum;

				if (num == "10")
					num = "A";
				else if (num == "11")
					num = "B";
				else if (num == "12")
					num = "C";
				else if (num == "13")
					num = "D";
				else if (num == "14")
					num = "E";
				else if (num == "15")
					num = "F";
				
				values[index] = num
			}
			
			var color: String = new String();
			color = ("0x") + (values[0]) + (values[1]) + (values[2]) + (values[3]) + (values[4]) + (values[5]);
			randomColor = uint(color); 
			
			
			return randomColor;
		}
		
	/*	function RandomColor(): Number {
			
		}*/
		
		function LineToolButtonPressed() {
			MasterMC.gotoAndStop(4);
			
			MouseTracker = DrawBasicShape(15, 15, 7, 7, 0x000000);
			//MasterMC.DrawingStage.addEventListener(MouseEvent.MOUSE_DOWN, shapeMover.ShapeClickHandler);
			DrawBasicShapeOnStage();
		}
		
		function DrawStartOfLine(e: MouseEvent)	{
			BasicShape = new MyShape(MyShapeType.LINE);
			BasicShape.x = MasterMC.MouseX.text;
			BasicShape.y = MasterMC.MouseY.text;
			//MasterMC.DrawingStage.addChild(BasicShape);
		}
		
		function DrawEndOfLine(e: MouseEvent) {
			BasicShape.RedrawLine(MasterMC.MouseX.text - BasicShape.x, MasterMC.MouseY.text - BasicShape.y);
			//BasicShape.graphics.lineTo(MasterMC.MouseX.text, MasterMC.MouseY.text);
			MasterMC.DrawingStage.addChild(BasicShape);
			myShapes.push(BasicShape);
		}
		
		function RectangleToolButtonPressed() {
			MasterMC.gotoAndStop(3);
			
			MouseTracker = DrawBasicShape(17, 17, 9, 9, 0x000000);
			MasterMC.DrawingStage.removeEventListener(MouseEvent.MOUSE_DOWN, shapeMover.ShapeClickHandler);
			DeSelect();
			DrawBasicShapeOnStage();
		}
		
		function SelectorToolButtonPressed() {
			MasterMC.gotoAndStop(1);
			
			RemoveDrawingEvents();
			MasterMC.DrawingStage.addEventListener(MouseEvent.MOUSE_DOWN, shapeMover.ShapeClickHandler);
		}
		
		function TextToolButtonPressed() {
			MasterMC.gotoAndStop(5);
			
			MouseTracker = DrawTextBox(16, 16, 8, 8);
			DrawBasicShapeOnStage();
		}
		
		function SetupButtons() {
			Buttons = new Array(4);

			Buttons[0] = MasterMC.FileButton;
			Buttons[1] = MasterMC.EditButton;
			Buttons[2] = MasterMC.ImageButton;
			Buttons[3] = MasterMC.ViewButton;
			Buttons[4] = MasterMC.ModeStaticButton;
			MasterMC.ModeStaticButton.addEventListener(MouseEvent.CLICK, ModeButtonClicked);

			Buttons[5] = MasterMC.ModeRandomButton;
			MasterMC.ModeRandomButton.addEventListener(MouseEvent.CLICK, ModeButtonClicked);
			
			SetupButtonText();
		}
		
		function ModeButtonClicked(e: MouseEvent) {
			
			trace("lel- " + e.target.name);
			if (e.target.name == "ModeStaticButton"){
					ChangeColor.color = 0x335D33;
				random = false;
				e.currentTarget.transform.colorTransform = ChangeColor;
				ChangeColor.color = 0x000000;
				MasterMC.ModeRandomButton.transform.colorTransform = ChangeColor;
			}
			else if (e.target.name == "ModeRandomButton") {
					ChangeColor.color = 0x335D33;
				random = true;
				e.currentTarget.transform.colorTransform = ChangeColor;
				ChangeColor.color = 0x000000;
				MasterMC.ModeStaticButton.transform.colorTransform = ChangeColor;
			}
		} 
		
		function SetupButtonText() {
			ButtonTexts = new Array(4);

			ButtonTexts[0] = MasterMC.FileButtonText;
			ButtonTexts[1] = MasterMC.EditButtonText;
			ButtonTexts[2] = MasterMC.ImageButtonText;
			ButtonTexts[3] = MasterMC.ViewButtonText;
			
			ButtonTexts[4] = MasterMC.ModeStaticText;
			//MasterMC.ModeStaticText.text.addEventListener(MouseEvent.CLICK, ModeTextClicked);
			ButtonTexts[5] = MasterMC.ModeRandomText;
			//MasterMC.ModeRandomText.text.addEventListener(MouseEvent.CLICK, ModeTextClicked);
		}
		
		function SetupPreviewShape() {
			if (shape == null) {
				shape = DrawBasicShape(15, 6, 50, 50, MasterMC.TextFieldBasicShapeFill.text);
				MasterMC.ShapePreview.addChild(shape);
			} else {
				if (MasterMC.ShapePreview.contains(shape))
					MasterMC.ShapePreview.removeChild(shape);
				shape = DrawBasicShape(15, 6, 50, 50, MasterMC.TextFieldBasicShapeFill.text);
				MasterMC.ShapePreview.addChild(shape);
			}
		}
		
		function SetupTools() {
			Tools = new Array(6);

			Tools[0] = MasterMC.CircleTool;
			Tools[1] = MasterMC.RectangleTool;
			Tools[2] = MasterMC.LineTool;
			Tools[3] = MasterMC.TextTool;
			Tools[4] = MasterMC.TriangleTool;
			Tools[5] = MasterMC.SelectorTool;

			SetupToolsIcons();

			for (var index: int = 0; index < Tools.length; index++) {
				Tools[index].addEventListener(MouseEvent.MOUSE_MOVE, ToolButtonMouseOver);
				Tools[index].addEventListener(MouseEvent.MOUSE_OUT, ToolButtonMouseOut);
				Tools[index].addEventListener(MouseEvent.MOUSE_DOWN, ToolButtonMouseDown);
				Tools[index].addEventListener(MouseEvent.MOUSE_UP, ToolButtonMouseUp);
			}
		}
		
		function SetupToolsIcons() {
			ToolIcons = new Array(6);

			ToolIcons[0] = MasterMC.CircleToolIcon;
			ToolIcons[1] = MasterMC.RectangleToolIcon;
			ToolIcons[2] = MasterMC.LineToolIcon;
			ToolIcons[3] = MasterMC.TextToolIcon;
			ToolIcons[4] = MasterMC.TriangleToolIcon;
			ToolIcons[5] = MasterMC.SelectorToolIcon;
		}
		
		function UpdateShapePreview(e: Event) {
			SetupPreviewShape();
			if(shapeMover.selector.target != null){
				shapeMover.selector.target.ChangeColor(MasterMC.TextFieldBasicShapeFill.text);
			}
		}

		function DrawBasicShapeOnClick(e: MouseEvent) {
			
			if (random) {
				MasterMC.TextFieldBasicShapeFill.text = RandomColor();
				MasterMC.TextFieldBasicShapeWidth.text = RandomInt();
				MasterMC.TextFieldBasicShapeHeight.text = RandomInt();
				MasterMC.TextFieldBasicShapeFill.text = "0x" + MasterMC.TextFieldBasicShapeFill.text;
			}
			
			var newShape: MyShape = DrawBasicShape(MasterMC.MouseX.text, MasterMC.MouseY.text, MasterMC.TextFieldBasicShapeWidth.text, MasterMC.TextFieldBasicShapeHeight.text, MasterMC.TextFieldBasicShapeFill.text);
			MasterMC.DrawingStage.addChild(newShape);
			myShapes.push(newShape);
			
			if(MasterMC.currentFrame == 5){
				textBoxes.push(newShape);
			}
			
			//if(MasterMC.currentFrame == 5)
			//{
			//	var textBox: MyShape = DrawBasicShape(MasterMC.MouseX.text, MasterMC.MouseY.text, MasterMC.TextFieldBasicShapeWidth.text, MasterMC.TextFieldBasicShapeHeight.text, MasterMC.TextFieldBasicShapeFill.text);
				//ourTextBox = DrawTextBox(MasterMC.MouseX.text, MasterMC.MouseY.text, MasterMC.TextFieldBasicShapeWidth.text, MasterMC.TextFieldBasicShapeHeight.text);
			//	MasterMC.DrawingStage.addChild(textBox);
			//	myShapes.push(textBox);
			//	textBoxes.push(textBox);
			//}
			//else
			//{
			//	var shape: MyShape = DrawBasicShape(MasterMC.MouseX.text, MasterMC.MouseY.text, MasterMC.TextFieldBasicShapeWidth.text, MasterMC.TextFieldBasicShapeHeight.text, MasterMC.TextFieldBasicShapeFill.text);
			//	MasterMC.DrawingStage.addChild(shape);
			//	myShapes.push(shape);
				//ourTextBox = DrawTextBox(MasterMC.MouseX.text, MasterMC.MouseY.text, MasterMC.TextFieldBasicShapeWidth.text, MasterMC.TextFieldBasicShapeHeight.text);
				//MasterMC.DrawingStage.addChild(ourTextBox);
			//}
		}

		function MouseOutOfStage(e: MouseEvent) {
			MasterMC.LineX.visible = false;
			MasterMC.LineY.visible = false;
		}
		
		function MouseOverStage(e: MouseEvent) {
			MasterMC.MouseX.text = MasterMC.DrawingStage.mouseX;
			MasterMC.MouseY.text = MasterMC.DrawingStage.mouseY;

			MasterMC.LineX.visible = true;
			MasterMC.LineX.x = MasterMC.DrawingStage.mouseX + 50;

			MasterMC.LineY.visible = true;
			MasterMC.LineY.y = MasterMC.DrawingStage.mouseY + 100;
		}		
		
		function MoveMouseTracker(e: MouseEvent) {
				MouseTracker.x = MasterMC.mouseX + MouseTracker.width;
				MouseTracker.y = MasterMC.mouseY + MouseTracker.height;
		}
		
		function RemoveDrawingEvents() {
			MasterMC.DrawingStage.removeEventListener(MouseEvent.MOUSE_MOVE, UpdateXYTextField);
			MasterMC.removeEventListener(MouseEvent.MOUSE_MOVE, MoveMouseTracker);
			
			MasterMC.DrawingStage.removeEventListener(MouseEvent.MOUSE_DOWN, DrawStartOfLine);
			MasterMC.DrawingStage.removeEventListener(MouseEvent.MOUSE_UP, DrawEndOfLine)

			MasterMC.DrawingStage.removeEventListener(MouseEvent.CLICK, DrawBasicShapeOnClick);
			if (MouseTracker != null && contains(MouseTracker))
				removeChild(MouseTracker);
		}
		
		function SetTextBoxesSelectable(value: Boolean){
			for each(var i in textBoxes){
				var box:MyShape = i as MyShape;
				box.setSelectable(value);
			}
		}
		
		function ToolButtonMouseDown(e: MouseEvent) {
			ChangeColor.color = 0x993830;
			e.currentTarget.transform.colorTransform = ChangeColor;
			
			if (e.currentTarget.name == "TextTool"){
				SetTextBoxesSelectable(true);
			}else{
				SetTextBoxesSelectable(false);
			}

			if (e.currentTarget.name == "CircleTool") {
				RemoveDrawingEvents();
				CircleToolButtonPressed();
			}
			else if (e.currentTarget.name == "RectangleTool") {
				RemoveDrawingEvents();
				RectangleToolButtonPressed();
				
			}
			else if (e.currentTarget.name == "SelectorTool") {
				SelectorToolButtonPressed();
				RemoveDrawingEvents();
			}
			else if (e.currentTarget.name == "TextTool") {
				RemoveDrawingEvents();				
				TextToolButtonPressed();
			}
			else if (e.currentTarget.name == "LineTool") {
				RemoveDrawingEvents();
				LineToolButtonPressed();
			}
		}
		
		function ToolButtonMouseOut(e: MouseEvent) {
			ChangeColor.color = 0x443835;
			e.currentTarget.transform.colorTransform = ChangeColor;
		}
	
		function ToolButtonMouseOver(e: MouseEvent) {
			ChangeColor.color = 0x663835;
			e.currentTarget.transform.colorTransform = ChangeColor;
		}

		function ToolButtonMouseUp(e: MouseEvent) {
			ChangeColor.color = 0x663835;
			e.currentTarget.transform.colorTransform = ChangeColor;
		}
		
		function UpdateXYTextField(e: MouseEvent) {
			MasterMC.TextFieldBasicShapeX.text = MasterMC.MouseX.text;
			MasterMC.TextFieldBasicShapeY.text = MasterMC.MouseY.text;
		}
	}	
}