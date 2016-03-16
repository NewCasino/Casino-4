

/*********VARIABLE DECLARATION****************/
var WIDTH:Number;
var HEIGHT:Number;
var COUNT:Number = 1;
var depth:Number = -5000;
var latestX:Number = 30;
var latestY:Number = 180;
var frameW;
var frameH;
var currentSelDoor:Number;
var curSelFrame:String;
var curSelFrameID:Number;
var topbar_mc:MovieClip;
var doorsContainer_mc:MovieClip = this.createEmptyMovieClip("doorsContainer_mc", 0);
var doorArray:Array = new Array();
var doorSelectArray:Array = new Array();
var sheetArray:Array = new Array("valkoinensileä","valkoinenväre","valkoinenpuusyy","pyökki","tammi","lehtikuusi","kirsikka","leppä","mänty","koivu","mahonki","musta lasi","vaaleapähkinä","tummapähkinä","wenge","harmaaväre","harmaapuusyy","rottinki","valkoinen lasi","pyökki","kirsikka","hopea lasi","tammi","koivu","pähkinä","wenge","musta lasi","valkoinen lasi","hopea lasi","tammi","koivu","pähkinä","pyökki","kirsikka","musta lasi","wenge");
var glassArray:Array = new Array("kirkas","pronssi","harmaa","opaali","maitolasi","kirkas","kirkas","pronssi","valkoinen lasi","hopea lasi","punainen lasi","sininen lasi","musta lasi","pronssi","pronssi","harmaa","harmaa");
var bothArray:Array = new Array("kirkas","pronssi","harmaa","opaali","maitolasi","kirkas","kirkas","pronssi","valkoinen lasi","hopea lasi","punainen lasi","sininen lasi","musta lasi","pronssi","pronssi","harmaa","harmaa","valkoinensileä","valkoinenväre","valkoinenpuusyy","pyökki","tammi","lehtikuusi","kirsikka","leppä","mänty","koivu","mahonki","musta lasi","vaaleapähkinä","tummapähkinä","wenge","harmaaväre","harmaapuusyy","rottinki","valkoinen lasi","pyökki","kirsikka","hopea lasi","tammi","koivu","pähkinä","wenge","musta lasi","valkoinen lasi","hopea lasi","tammi","koivu","pähkinä","pyökki","kirsikka","musta lasi","wenge");
var framesMcArray:Array = new Array();
var frameArray:Array = new Array("hopea lasi","tummapähkinä","valkoinen lasi","pronssi","musta lasi","hopea lasi","pyökki","tammi","kirsikka","vaaleapähkinä","tummapähkinä","valkotammi","koivu","mänty","mahonki","wenge","messinki","hopea lasi","nikkeli");
var internalFrameArray1:Array = new Array();
var internalFrameArray2:Array = new Array();
var internalFrameArray3:Array = new Array();
var internalFrameArray4:Array = new Array();
var bothTypeArray:Array = new Array();
var btnArray:Array = new Array();
var comboArray:Array = new Array();


/************ComboBox Events*******************************/
var cbListener1:Object = new Object();
var cbListener2:Object = new Object();
var cbListener3:Object = new Object();
var cbListener4:Object = new Object();

cbListener1.change = function(event_obj:Object) {
	trace(glassArray[event_obj.target.selectedItem.data-1]);
	
	var linkageID = glassArray[event_obj.target.selectedItem.data-1];
	drawSelection(doorArray[currentSelDoor-1],linkageID);
	
	doorsMaterial[currentSelDoor-1] = "peili ("+glassArray[event_obj.target.selectedItem.data-1]+")";
	checkForAllDataEntered();
};
cbListener2.change = function(event_obj:Object) {
  var linkageID = sheetArray[event_obj.target.selectedItem.data-1];
  drawSelection(doorArray[currentSelDoor-1],linkageID);
	if (my_cb2.text.substr(0,5)  == "reikä") {
  		reikälevy2(doorArray[currentSelDoor-1],linkageID)
  	} 
  	
	doorsMaterial[currentSelDoor-1] = "levy ("+sheetArray[event_obj.target.selectedItem.data-1]+")";
	checkForAllDataEntered();
};
cbListener3.change = function(event_obj:Object) {
  if(event_obj.target.selectedItem.data > 0)
  showPopUp(event_obj.target.selectedItem.data);
};
cbListener4.change = function(event_obj:Object) {

 var linkageID = frameArray[event_obj.target.selectedItem.data-1];
 curSelFrame = linkageID;
 for(var i:Number = 0;i<framesMcArray.length;i++)
 {
	drawSelection(framesMcArray[i],linkageID);
 }
 drawSelection(topbar_mc,curSelFrame);
 drawOuterFrames();
 drawInternalFrames();
 
 	_root.FRAMEMATERIAL = frameArray[event_obj.target.selectedItem.data-1];
	checkForAllDataEntered();
};

my_cb1.addEventListener("change", cbListener1);
comboArray.push(my_cb1);
my_cb2.addEventListener("change", cbListener2);
comboArray.push(my_cb2);
my_cb3.addEventListener("change", cbListener3);
comboArray.push(my_cb3);
my_cb4.addEventListener("change", cbListener4);
comboArray.push(my_cb4);
showComboBox(-99);
/**********************************************************/


function drawSelected():Void {
	var object:Object = new Object();
	for (var i:Number = 0; i<4; i++) {
		if (comboArray[i]._visible == true) {
			object.target = comboArray[i];
			var name:String = "cbListener" + (i + 1);
			this[name].change(object);
		}
	}
}

function dumpArray(_dumpArray:Array)
{
	for(var i:Number = 0;i<_dumpArray.length;i++)
	{
		_dumpArray[i] = "";
	}
}
function drawOuterFrames()
{
		for(var i:Number = 0 ;i<framesMcArray.length;i++)
		{
			drawSelection(framesMcArray[i],curSelFrame);
		}
		drawSelection(topbar_mc,curSelFrame);
}
function drawInternalFrames1()
{
		for(var i:Number = 0;i<internalFrameArray1.length;i++)
		{
			drawSelection(internalFrameArray1[i],curSelFrame) 
		}
}	
function drawInternalFrames2()	
{
		for(var i:Number = 0;i<internalFrameArray2.length;i++)
		{
			drawSelection(internalFrameArray2[i],curSelFrame) 
		}
}
function drawInternalFrames3()	
{
		for(var i:Number = 0;i<internalFrameArray3.length;i++)
		{
			drawSelection(internalFrameArray3[i],curSelFrame) 
		}
}
function drawInternalFrames4()	
{
		for(var i:Number = 0;i<internalFrameArray4.length;i++)
		{
			drawSelection(internalFrameArray4[i],curSelFrame) 
		}
}
function createDoors():Void
{
	if(PROJECTID == 1)
	{
		WIDTH = (TOTWIDTH / NODOORS);
		HEIGHT = TOTHEIGHT - 50/8;
		frameW = 34/8;
		frameH = 34/8;
	}
	else if(PROJECTID == 2)
	{
		WIDTH = (TOTWIDTH / NODOORS);
		HEIGHT = TOTHEIGHT-35/8;
		frameW = 50/8
		frameH = 50/8;
	}
	drawTopBar();
	for (var i:Number = 1; i <= NODOORS; i++) {
		drawDoors();
	}
	assignEventsToDoors();
}

function drawDoors()
{
	
	var door_mc:MovieClip;
	door_mc = doorsContainer_mc.createEmptyMovieClip("door_mc"+COUNT, depth++);
	select_mc = this.createEmptyMovieClip("select_mc"+COUNT, depth++);
	_select = select_mc.attachMovie("select","select"+COUNT,depth++);
	doorSelectArray.push(_select);
	doorArray.push(door_mc);
	door_mc._x = latestX;
	door_mc._y = latestY;
	var bgColor:Number = 0x000000;
	door_mc.currentSelLineStyle = bgColor;
	
	drawRectangle(door_mc,WIDTH,HEIGHT,bgColor);
	
	latestX = door_mc._x + door_mc._width + (2*frameW);
	_select._x = door_mc._x + (door_mc._width/2) - (_select._width/2);
	_select._y = door_mc._y - 60;
	
	drawFrames(COUNT,door_mc);
	COUNT++;
	if(COUNT>NODOORS)
	{
		btn4.enabled = true;
		loader._visible = false;
	}
}
function drawTopBar()
{
	topbar_mc = this.createEmptyMovieClip("topbar_mc", depth++);
	topbar_mc._x = latestX-frameW;
	topbar_mc._y = latestY;
	var bgColor:Number = 0x000000;
	var W:Number = Number(TOTWIDTH) + Number(NODOORS*2*frameW)
	drawRectangle(topbar_mc,W,frameH,bgColor);
	latestY = topbar_mc._y + topbar_mc._height;
}
function drawFrames(_doorID,_mc)
{
	
	var _mc = _mc;
	var _doorID = _doorID-1;
	for (var i:Number = 0; i<4; i++)
	{
		
		if(i==0)
		{
			var frame_mc:MovieClip;
			frame_mc = doorsContainer_mc.createEmptyMovieClip("frame_mc"+i+"_"+_doorID, depth++);
			framesMcArray.push(frame_mc);
			frame_mc._x = doorArray[_doorID]._x - frameW;
			frame_mc._y = doorArray[_doorID]._y - frameH;
			var W = frameW;
			var H = doorArray[_doorID]._height + (2*frameH);
			var bgColor = 0x000000;
			drawRectangle(frame_mc,W,H,bgColor);
		}
		else if(i == 1)
		{
			var frame_mc:MovieClip;
			frame_mc = doorsContainer_mc.createEmptyMovieClip("frame_mc"+i+"_"+_doorID, depth++);
			framesMcArray.push(frame_mc);
			frame_mc._x = doorArray[_doorID]._x + doorArray[_doorID]._width;
			frame_mc._y = doorArray[_doorID]._y - frameH;
			var W = frameW;
			var H = doorArray[_doorID]._height + (2*frameH);
			drawRectangle(frame_mc,W,H,bgColor);
			
		}
		else if(i == 2)
		{
			var frame_mc:MovieClip;
			frame_mc = doorsContainer_mc.createEmptyMovieClip("frame_mc"+i+"_"+_doorID, depth++);
			framesMcArray.push(frame_mc);
			frame_mc._x = doorArray[_doorID]._x;
			frame_mc._y = doorArray[_doorID]._y - frameH;
			var W = doorArray[_doorID]._width;
			var H = frameH;
			drawRectangle(frame_mc,W,H,bgColor);
			
		}
		else if(i == 3)
		{
			var frame_mc:MovieClip;
			frame_mc = doorsContainer_mc.createEmptyMovieClip("frame_mc"+i+"_"+_doorID, depth++);
			framesMcArray.push(frame_mc);
			frame_mc._x = doorArray[_doorID]._x;
			frame_mc._y = doorArray[_doorID]._y + doorArray[_doorID]._height;
			var W = doorArray[_doorID]._width;
			var H = frameH;
			drawRectangle(frame_mc, W,H,bgColor);
		}
		
	}	
}
function drawRectangle(_mc:MovieClip,W:Number,H:Number,bgColor:Number):Void
{
	_mc.lineStyle(0, bgColor);
	_mc.lineTo(W, 0);
	_mc.lineTo(W, H);
	_mc.lineTo(0, H);
	_mc.lineTo(0, 0);
}
function drawSelection(_mc:MovieClip,_id:String):Void
{

	var select_mc = doorsContainer_mc.createEmptyMovieClip("select_mc", depth++);
	select_mc._x = _mc._x;
	select_mc._y = _mc._y;
	var tile:BitmapData = BitmapData.loadBitmap(_id);
	select_mc.beginBitmapFill(tile);
	select_mc.lineStyle(0, _mc.currentSelLineStyle);
	select_mc.lineTo(_mc._width, 0);
	select_mc.lineTo(_mc._width, _mc._height);
	select_mc.lineTo(0, _mc._height);
	select_mc.lineTo(0, 0);
	select_mc.endFill();
}


function showComboBox(id)
{
	for (var i:Number = 0; i<4; i++)
	{
		if(i != id)
		comboArray[i]._visible = false;
		else
		{
			comboArray[i]._visible = true;
			comboArray[i].selectedIndex = 0;
		}
	}
}
function assignButtonEvents()
{
	for (var i:Number = 1; i<=4; i++)
	{
		_btn = eval("btn"+i);
		_btn.ID = i;
		_btn.enabled = false;
		btnArray.push(_btn);
		_btn.onRollOver = function()
		{
			this.gotoAndStop("over");
		}
		_btn.onRollOut = _btn.onReleaseOutside = function()
		{
			this.gotoAndStop("normal");
		}
		_btn.onRelease = function()
		{
			showComboBox(this.ID-1);
		}
		
	}
	
	btnShowDetails.onRelease = function() {
		
	}
	createDoors();
}

function showDetails():Void {
	var aDetails:Array = new Array();
	if (PROJECTID == 1) {
		oDetails.Tyyppi = "Teräs";
	} else if (PROJECTID == 1) {
		oDetails.Tyyppi =  "Alumini";
	}
	oDetails.Leveys = TOTWIDTH;
	oDetails.Korkeus = TOTHEIGHT;
	oDetails.OvienMäärä = NODOORS;
	
	for (var i:Number = 0; i < NODOORS; i++) {
		var oDetails:Object = { };
		
		
		
		
		
		oDetails.KehyksenVäri = 
		oDetails.Peiliovi = 
		oDetails.Levyovi = 
		oDetails.JaettuOvi =
		aDetails.push(oDetails);
	}
	 
	
	mcAllData.dgAllData.dataProvider = oDetails;
	mcAllData._visible = true;
}

function assignEventsToDoors()
{
	for (var i:Number = 1; i<=doorSelectArray.length; i++)
	{
		var _btn = doorSelectArray[i-1];
		_btn.ID = i;
		_btn.Selected = false;
		_btn.onRollOver = function()
		{
			this.gotoAndStop(2);
		}
		_btn.onRollOut = _btn.onReleaseOutside = function()
		{
			if(this.Selected)
			this.gotoAndStop(2);
			else
			this.gotoAndStop(1);
		}
		_btn.onRelease = function()
		{
			makeOtherNornal();
			currentSelDoor = this.ID;
			this.Selected = true;
			this.gotoAndStop(2);
			addToTypeArray();
			enableButtons();
			drawSelected();
		}
	}
	trace ("doorSelectArray: " + doorSelectArray[0]);
	doorSelectArray[0].onRelease();
}
function addToTypeArray()
{
	for(var i:Number = 1;i<=4;i++)
	{
		bothTypeArray[i-1] = eval("type"+i+"_pop");
	}
}
function showPopUp(_id:Number)
{
	var _id = _id;
	for(var i:Number = 0;i<4;i++)
	{
		bothTypeArray[i].gotoAndStop(1);
	}
	disableBtnProp();
	bothTypeArray[_id-1].swapDepths(15000);
	bothTypeArray[_id-1].gotoAndStop(2);
}
function disableBtnProp()
{
	disable_btn.swapDepths(14000);
	disable_btn._visible = true;
	disable_btn.useHandCursor = false;
	disable_btn.onRelease = function()
	{
	
	}

}
function makeOtherNornal()
{
	for (var i:Number = 1; i<=doorSelectArray.length; i++)
	{
		doorSelectArray[i-1].Selected = false;
		doorSelectArray[i-1].gotoAndStop(1);
	}
}
function enableButtons():Void
{
	btn1.enabled = true;
	btn1.gotoAndStop(1);
	btn2.enabled = true;
	btn2.gotoAndStop(1);
	btn3.enabled = true;
	btn3.gotoAndStop(1);
}
function reikälevy2(_mc:MovieClip,_id:String):Void
{
	var r:MovieClip = doorsContainer_mc.createEmptyMovieClip("r_mc",depth ++);
	r._x = _mc._x;
	r._y = _mc._y;
	var offset:Number = 45/8
	var montakoY:Number = Math.floor((_mc._height -5)/offset);
	for (var i:Number = 0; i < 6 ; i++){
		for (var j=0; j < montakoY ; j++) {
			r.beginFill(0x99CC33, 100);
			r.lineStyle(0, 0x000033, 100);
			alkuX = _mc._width/2 - 125/8 + (i * offset);
			alkuY = 5 + (j * offset);
			r.moveTo( alkuX, alkuY);
			r.lineTo( alkuX + 2, alkuY);
			r.lineTo( alkuX + 2, alkuY + 2);
			r.lineTo( alkuX, alkuY + 2);
			r.endFill();
		}
	}
}
function reikälevy(_mc:MovieClip,W:Number,H:Number):Void
{
	var r:MovieClip = doorsContainer_mc.createEmptyMovieClip("r_mc",depth ++);
	r._x = _mc._x;
	r._y = _mc._y;
	var offset:Number = 45/8
	var montakoY:Number = Math.floor((H -5)/offset);
	for (var i:Number = 0; i < 6 ; i++){
		for (var j=0; j < montakoY ; j++) {
			r.beginFill(0x99CC33, 100);
			r.lineStyle(0, 0x000033, 100);
			alkuX = W/2 - 125/8 + (i * offset);
			alkuY = 5 + (j * offset);
			r.moveTo( alkuX, alkuY);
			r.lineTo( alkuX + 2, alkuY);
			r.lineTo( alkuX + 2, alkuY + 2);
			r.lineTo( alkuX, alkuY + 2);
			r.endFill();
		}
	}
 }
function drawType1(_H:Number,linkageID1:String,linkageID2:String,part11:Boolean,part12:Boolean):Void
{
			var linkageID1 = linkageID1;
			var linkageID2 = linkageID2;
			var part11 = part11;
			var part12 = part12;			
			
			var _H = _H;
			
			preview_mc1_1 = doorsContainer_mc.createEmptyMovieClip("preview_mc1_1", depth++);
			preview_frame_1 = doorsContainer_mc.createEmptyMovieClip("preview_frame_1", depth++);
			preview_mc1_2 = doorsContainer_mc.createEmptyMovieClip("preview_mc1_2", depth++);
		
			preview_mc1_1._x = doorArray[currentSelDoor-1]._x;
			preview_frame_1._x = doorArray[currentSelDoor-1]._x;
			preview_mc1_2._x = doorArray[currentSelDoor-1]._x;
			
			preview_mc1_1._y = doorArray[currentSelDoor-1]._y;		
			preview_mc1_2._y = doorArray[currentSelDoor-1]._y + doorArray[currentSelDoor-1]._height -_H;
			preview_frame_1._y = preview_mc1_2._y - frameH;
			
			var W1 = doorArray[currentSelDoor-1]._width;
			var H1 = doorArray[currentSelDoor-1]._height -_H - frameH;
			var W2 = doorArray[currentSelDoor-1]._width;
			var H2 = _H;
			var W3 = doorArray[currentSelDoor-1]._width;
			var H3 = frameH;
			
			drawRectangle(preview_mc1_1,W1,H1,0x000000);
			drawRectangle(preview_frame_1,W3,H3,0x000000);
			drawRectangle(preview_mc1_2,W2,H2,0x000000);
			dumpArray(internalFrameArray1);
			internalFrameArray1[0] = preview_frame_1;
			drawSelection(preview_mc1_1,linkageID1);
			drawSelection(preview_mc1_2,linkageID2);
			if (part11 == true){
				reikälevy(preview_mc1_1,W1,H1);
			}
			if (part12 == true){
				reikälevy(preview_mc1_2,W2,H2);
			}
			drawOuterFrames();
			drawInternalFrames1();
			
}
function drawType2(_H:Number,linkageID1:String,linkageID2:String,linkageID3:String,part21:Boolean,part22:Boolean,part23:Boolean):Void
{

			var linkageID1 = linkageID1;
			var linkageID2 = linkageID2;
			var linkageID3 = linkageID3;
			
			var part21 = part21;
			var part22 = part22;
			var part23 = part23;
			
			var _H = _H;
			
			preview_frame_1 = doorsContainer_mc.createEmptyMovieClip("preview_frame_1", depth++);
			preview_frame_2 = doorsContainer_mc.createEmptyMovieClip("preview_frame_2", depth++);
			preview_mc2_1 = doorsContainer_mc.createEmptyMovieClip("preview_mc2_1", depth++);
			preview_mc2_2 = doorsContainer_mc.createEmptyMovieClip("preview_mc2_2", depth++);
			preview_mc2_3 = doorsContainer_mc.createEmptyMovieClip("preview_mc2_3", depth++);
			var W1 = doorArray[currentSelDoor-1]._width;
			var W2 = doorArray[currentSelDoor-1]._width;
			var W3 = doorArray[currentSelDoor-1]._width;
			var H1 = _H;
			var H2 = doorArray[currentSelDoor-1]._height - (2*_H) - (2*frameH);
			var H3 = _H;
			var W4 = doorArray[currentSelDoor-1]._width;
			var H4 = frameH;
			var W5 = doorArray[currentSelDoor-1]._width;
			var H5 = frameH;
			
			preview_mc2_1._x = doorArray[currentSelDoor-1]._x;
			preview_mc2_2._x = doorArray[currentSelDoor-1]._x;
			preview_mc2_3._x = doorArray[currentSelDoor-1]._x;
			preview_frame_1._x = doorArray[currentSelDoor-1]._x;
			preview_frame_2._x = doorArray[currentSelDoor-1]._x;
			
			preview_mc2_1._y = doorArray[currentSelDoor-1]._y;
			preview_mc2_3._y = doorArray[currentSelDoor-1]._y +doorArray[currentSelDoor-1]._height - _H;
			preview_frame_1._y = preview_mc2_1._y + _H;
			preview_frame_2._y = preview_mc2_3._y - frameH;
			preview_mc2_2._y = preview_frame_1._y + frameH;
			
			dumpArray(internalFrameArray2);
			internalFrameArray2[0] = preview_frame_1;
			internalFrameArray2[1] = preview_frame_2;
			
			drawRectangle(preview_mc2_1,W1,H1,0x000000);
			drawRectangle(preview_mc2_3,W3,H3,0x000000);
			drawRectangle(preview_frame_1,W4,H4,0x000000);
			drawRectangle(preview_frame_2,W5,H5,0x000000);
			drawRectangle(preview_mc2_2,W2,H2,0x000000);
			
			drawSelection(preview_mc2_1,linkageID1);
			drawSelection(preview_mc2_3,linkageID3);
			drawSelection(preview_mc2_2,linkageID2);
			if (part21 == true){
				reikälevy(preview_mc2_1,W1,H1);
			}
			if (part22 == true){
				reikälevy(preview_mc2_2,W2,H2);
			}
			if (part23 == true){
				reikälevy(preview_mc2_3,W3,H3);
			}
			drawOuterFrames();
			drawInternalFrames2();
			
}

function drawType3(_H1:Number,_H2:Number,linkageID1:String,linkageID2:String,linkageID3:String,part31:Boolean,part32:Boolean,part33:Boolean):Void
{
			var linkageID1 = linkageID1;
			var linkageID2 = linkageID2;
			var linkageID3 = linkageID3;
			
			var part31 = part31;
			var part32 = part32;
			var part33 = part33;
			
			var _H1 = _H1;
			var _H2 = _H2;
			
			preview_mc3_1 = doorsContainer_mc.createEmptyMovieClip("preview_mc3_1", depth++);
			preview_mc3_2 = doorsContainer_mc.createEmptyMovieClip("preview_mc3_2", depth++);
			preview_mc3_3 = doorsContainer_mc.createEmptyMovieClip("preview_mc3_3", depth++);
			preview_frame_1 = doorsContainer_mc.createEmptyMovieClip("preview_frame_1", depth++);
			preview_frame_2 = doorsContainer_mc.createEmptyMovieClip("preview_frame_2", depth++);

			var W1 = doorArray[currentSelDoor-1]._width;
			var W2 = doorArray[currentSelDoor-1]._width;
			var W3 = doorArray[currentSelDoor-1]._width;
			var H1 = _H1;
			var H2 = doorArray[currentSelDoor-1]._height - _H1 - _H2 - 2* frameH;
			var H3 = _H2;
			var W4 = doorArray[currentSelDoor-1]._width;
			var H4 = frameH;
			var W5 = doorArray[currentSelDoor-1]._width;
			var H5 = frameH;
			
			
			preview_mc3_1._x = doorArray[currentSelDoor-1]._x;
			preview_mc3_2._x = doorArray[currentSelDoor-1]._x;
			preview_mc3_3._x = doorArray[currentSelDoor-1]._x;
			preview_frame_1._x = doorArray[currentSelDoor-1]._x;
			preview_frame_2._x = doorArray[currentSelDoor-1]._x;
			
			preview_mc3_1._y = doorArray[currentSelDoor-1]._y;
			preview_mc3_3._y = doorArray[currentSelDoor-1]._y +doorArray[currentSelDoor-1]._height - _H2;
			preview_frame_1._y = preview_mc3_1._y + _H1;
			preview_frame_2._y = preview_mc3_3._y - frameH;
			preview_mc3_2._y = preview_frame_1._y + frameH;
			
			dumpArray(internalFrameArray3);
			internalFrameArray3[0] = preview_frame_1;
			internalFrameArray3[1] = preview_frame_2;

			drawRectangle(preview_mc3_1,W1,H1,0x000000);
			drawRectangle(preview_mc3_2,W2,H2,0x000000);
			drawRectangle(preview_mc3_3,W3,H3,0x000000);
			drawRectangle(preview_frame_1,W4,H4,0x000000);
			drawRectangle(preview_frame_2,W5,H5,0x000000);
			
			drawSelection(preview_mc3_1,linkageID1);
			drawSelection(preview_mc3_2,linkageID2);
			drawSelection(preview_mc3_3,linkageID3);

			if (part31 == true){
				reikälevy(preview_mc3_1,W1,H1);
			}
			if (part32 == true){
				reikälevy(preview_mc3_2,W2,H2);
			}
			if (part33 == true){
				reikälevy(preview_mc3_3,W3,H3);
			}
			drawOuterFrames();
			drawInternalFrames3();
			
}

function drawType4(noOfCombos:Number,linkageIDArray:Array,part40:Boolean,part41:Boolean,part42:Boolean,part43:Boolean,part44:Boolean,part45:Boolean):Void
{
					
			
			var HT:Number = (doorArray[currentSelDoor-1]._height- ((noOfCombos-1)* frameH)) /noOfCombos;
			var WW;
			var HH;
			var preview_mc_array:Array = new Array();
			var frame_mc_array:Array = new Array();
			var no_frames:Number = Number(noOfCombos - 1)
			for(var i:Number = 0;i<noOfCombos;i++)
			{
				WW = doorArray[currentSelDoor-1]._width;
				HH = HT;
				preview_mc_array[i] = doorsContainer_mc.createEmptyMovieClip("preview"+i, depth++);
				preview_mc_array[i]._x = doorArray[currentSelDoor-1]._x;
				if(i==0)
				preview_mc_array[i]._y = doorArray[currentSelDoor-1]._y;
				else
				{
					preview_mc_array[i]._y = preview_mc_array[i-1]._y + HT + frameH;
					frame_mc_array[i-1] = doorsContainer_mc.createEmptyMovieClip("preview_frame"+i, depth++);
					frame_mc_array[i-1]._x = doorArray[currentSelDoor-1]._x;
					frame_mc_array[i-1]._y = preview_mc_array[i-1]._y + HT;

				}

				drawRectangle(preview_mc_array[i],WW,HH,0x000000);
				drawSelection(preview_mc_array[i],linkageIDArray[i]);

			}
			

				
				if (part40 == true){
					preview_mc_array[0] = doorsContainer_mc.createEmptyMovieClip("preview0", depth++);
					preview_mc_array[0]._x = doorArray[currentSelDoor-1]._x;
					preview_mc_array[0]._y = doorArray[currentSelDoor-1]._y;
					reikälevy(preview_mc_array[0],WW,HH);
					
				}
				
				if (part41 == true){
					preview_mc_array[1] = doorsContainer_mc.createEmptyMovieClip("preview1", depth++);
					preview_mc_array[1]._x = doorArray[currentSelDoor-1]._x;
					preview_mc_array[1]._y = doorArray[currentSelDoor-1]._y + HT + frameH;
					reikälevy(preview_mc_array[1],WW,HH);
					
				}
				if (part42 == true){
					preview_mc_array[2] = doorsContainer_mc.createEmptyMovieClip("preview2", depth++);
					preview_mc_array[2]._x = doorArray[currentSelDoor-1]._x;
					preview_mc_array[2]._y = doorArray[currentSelDoor-1]._y + 2 * ( HT + frameH);
					reikälevy(preview_mc_array[2],WW,HH);
					
				}
				if  (noOfCombos <4 ){
					}else if (part43 == true){
						preview_mc_array[3] = doorsContainer_mc.createEmptyMovieClip("preview3", depth++);
						preview_mc_array[3]._x = doorArray[currentSelDoor-1]._x;
						preview_mc_array[3]._y = doorArray[currentSelDoor-1]._y + 3 * ( HT + frameH);
						reikälevy(preview_mc_array[3],WW,HH);
					}
				
				if  (noOfCombos <5){
					 }else if (part44 == true){
						preview_mc_array[4] = doorsContainer_mc.createEmptyMovieClip("preview4", depth++);
						preview_mc_array[4]._x = doorArray[currentSelDoor-1]._x;
						preview_mc_array[4]._y = doorArray[currentSelDoor-1]._y + 4 * ( HT + frameH);
						reikälevy(preview_mc_array[4],WW,HH);
						//trace(doorArray[currentSelDoor-1]._y + 4 *(HT + frameH))
					}
				
				if (noOfCombos <6){
					 } else if (part45 == true){
						preview_mc_array[5] = doorsContainer_mc.createEmptyMovieClip("preview5", depth++);
						preview_mc_array[5]._x = doorArray[currentSelDoor-1]._x;
						preview_mc_array[5]._y = doorArray[currentSelDoor-1]._y + 5 * ( HT + frameH);
						reikälevy(preview_mc_array[5],WW,HH);
					}
				
			dumpArray(internalFrameArray4);
			for(var i:Number = 0;i<frame_mc_array.length;i++)
			{
				drawRectangle(frame_mc_array[i],WW,frameH,0x000000);
				

				internalFrameArray4[i] = frame_mc_array[i];
			}
			drawOuterFrames();
			drawInternalFrames4();		
}


