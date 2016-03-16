/**
 * ...
 * @author Michael Pavlov
 */

import classes.Thumb;
import classes.ThumbObject;
import gs.TweenGroup;
import gs.TweenLite;
import mx.utils.Delegate;
 
class classes.Gallery extends MovieClip {
	//CONSTANTS
	private var GALLERY_XML_URL:String = "data/gallery.xml";
	private var DEFAULT_THUMB_WIDTH:Number = 100;
	private var DEFAULT_THUMB_HEIGHT:Number = 95;
	private var DEFAULT_THUMB_GAP:Number = 10;
	
	public var imagesData:Array = new Array();
	public var thumbs:Array = new Array();
	private var imagesCoords:Array = new Array();
	
	
	private var width:Number;
	private var height:Number;
	
	private var xXml:XML;
	public var thumbBorder:Boolean = false;
	public var thumbBorderColor:Number
	public var numImages:Number;
	private var thumbWidth:Number;
	private var thumbHeight:Number;
	private var thumbsGap:Number;
	
	private var emptyBackground:MovieClip;
	private var mcMask:MovieClip;
	private var tileList:MovieClip;
	private var btnLeft:MovieClip;
	private var btnRight:MovieClip;
	private var lastActiveThumb:MovieClip;
	
	private var _maxThumbsToShow:Number = 4;
	
	private var nMovement:Number = 0;
	private var nSpace:Number = 10;
	private var nSpeed:Number = 10;
	private var paddingRight:Number = 20;
	private var paddingLeft:Number = 20;
	private var nSeparation:Number = 15;
	private var nThumbWidth:Number = 15;
	private var nThumbHeight:Number = 15;
	private var nChainWidth:Number = 15;
	
	private var currentTween:TweenGroup;
	
	public function Gallery() {
		this.setVariables();
		//emptyBackground._alpha = 0;
		//btnLeft._visible = false;
		//btnRight._visible = false;
		tileList.setMask(mcMask);
		xXml = new XML();
		xXml.ignoreWhite = true;
		xXml.onLoad = Delegate.create(this, this.parseXML);
		xXml.load(GALLERY_XML_URL);
		
		mcMask._width = 500;
		mcMask._height = 96;
		
		//btnLeft.onRelease = Delegate.create(this, this.btnLeftClick);
		//btnRight.onRelease = Delegate.create(this, this.btnRightClick);
		
	}
	
	private function setVariables():Void {
		//nMaxWidth = 624;//stage.stageWidth;
		//nMaxHeight = 432;//stage.stageHeight;
		nSpeed = 10;
		nMovement = 0;
		paddingRight = 20;
		paddingLeft = 20;
		nSeparation = 15;
		nThumbWidth = 75;
		nThumbHeight = 42;
		nSpace = nThumbWidth + nSeparation;
	}	
	
	public function fadeIn():Void {		
		this._visible = true;
		TweenLite.to(this, 0.5, { _alpha:100 } );
	}
	
	public function fadeOut():Void {
		var $this = this;
		TweenLite.to(this, 0.5, { _alpha:0, onComplete:function(){$this._visible = false} } );
	}
	
	private function parseXML():Void {
		var node:XMLNode = xXml.firstChild;
		var thumbFolder:String = node.attributes.thumbFolder;
		var fullFolder:String = node.attributes.fullFolder;
		
		if (node.attributes.thumbBorder == "true") {
			thumbBorder = true;
			thumbBorderColor = node.attributes.thumbBorderColor;
		} else {
			thumbBorder = false;
		}
		
		if (node.attributes.thumbsGap != "" || node.attributes.thumbsGap != undefined) {
			thumbsGap = Number(node.attributes.thumbsGap);			
		} else {
			thumbsGap = DEFAULT_THUMB_GAP;
		}
		
		if (node.attributes.thumbHeight != "" || node.attributes.thumbHeight != undefined) {
			thumbHeight = Number(node.attributes.thumbHeight);			
		} else {
			thumbHeight = DEFAULT_THUMB_HEIGHT;
		}
		
		if (node.attributes.thumbWidth != "" || node.attributes.thumbWidth != undefined) {
			thumbWidth = Number(node.attributes.thumbWidth);			
		} else {
			thumbWidth = DEFAULT_THUMB_WIDTH
		}
		
		node = node.childNodes[0];
		numImages = node.childNodes.length;		
		var tmpNode:XMLNode;
		
		for (var i:Number = 0; i < numImages; i++) {
			tmpNode = node.childNodes[i];
			var obj:ThumbObject = new ThumbObject();
			obj.thumbUrl = thumbFolder + "/" + tmpNode.attributes.thumbUrl;
			obj.imageUrl = fullFolder + "/" + tmpNode.attributes.url;
			obj.thumbBorderColor = thumbBorderColor;
			obj.thumbBorder = thumbBorder;
			imagesData.push(obj);
		}
		
		this.createTileList();
	}
	
	private function createTileList():Void {
		var counter:Number = 0;
		thumbs = new Array();
		var thumb:MovieClip;
		for (var i:Number = 0; i < numImages; i++) {
			var name:String = "thumb_" + counter;
			thumb = tileList.attachMovie("mcThumbSymbol", name, counter);			
			thumb.init(imagesData[i]);
			thumbs.push(thumb);
			thumb.clickFunction = onThumbClick;
			counter++;
		}
		
		this.repositionate();
		_global.setTimeout(onThumbClick, 1500, imagesData[0], thumbs[0]);
		//this.onThumbClick(imagesData[0], thumbs[0]);		
	}
	
	public function repositionate():Void {
		var cursor:Number = 0;
		btnLeft._x = thumbsGap * 2;
		tileList._x = btnLeft._x + btnLeft._width + thumbsGap;
		btnLeft._y = (thumbHeight - btnLeft._height) / 2;
		
		var thumb:MovieClip;
		var fullSpace:Number = thumbWidth + thumbsGap;
		
		for (var i:Number = 0; i < numImages; i++) {
			thumb = thumbs[i];
			thumb._x = i * fullSpace;
			imagesCoords.push(thumb._x);
			thumb._y = 3;
		}
		
		nChainWidth = fullSpace * numImages;
		
		mcMask._width = _maxThumbsToShow * fullSpace;
		emptyBackground._width = this._width;
		emptyBackground._height = this._height;
		mcMask._x = tileList._x - 2;
		btnRight._x = mcMask._width + mcMask._x;
		btnRight._y = btnLeft._y;
	}
	
	public function setSize($width:Number, $height:Number):Void {
		var cursor:Number = 0;
		btnLeft._x = thumbsGap * 2;
		tileList._x = btnLeft._x + btnLeft._width + thumbsGap;
		btnLeft._y = thumbHeight / 2;
		
		var thumb:MovieClip;
		var fullSpace:Number = thumbWidth + thumbsGap;
		
		mcMask._width = _maxThumbsToShow * fullSpace;
		mcMask._x = tileList._x - 2;
		btnRight._x = mcMask._width + mcMask._x;
		btnRight._y = btnLeft._y;
	}
	
	public function onThumbClick($vo:ThumbObject, $caller:MovieClip):Void {
		if (_root.section != $vo.imageUrl) {
			_root.section = $vo.imageUrl;
			_root.imagePreloader.load($vo.imageUrl);			
			$caller._parent.lastActiveThumb.deActivate()
			$caller._parent.lastActiveThumb = $caller;
			$caller.activate();
			//trace (lastActiveThumb)
		}
		//trace ($vo.imageUrl);
	}
	
	
	
	private function deactivateAll():Void {
		trace ("deactivateAll" )
		for (var i:Number = 0; i < thumbs.length; i++) {		
			thumbs[i].deActivate();
		}
	}
	
	public function get maxThumbsToShow():Number { 
		return _maxThumbsToShow; 
	}
	
	public function set maxThumbsToShow(value:Number):Void {
		_maxThumbsToShow = value;
	}
	
	private function btnRightClick():Void {
		if (imagesCoords[numImages-1] <= mcMask._width - 10) {
			return;
		}
		var fullSpace:Number = thumbWidth + thumbsGap;
		var aTweens:Array = new Array();
		for (var i:Number = 0; i < thumbs.length; i++) {
			imagesCoords[i] = imagesCoords[i] - fullSpace;
			var tween:TweenLite = new TweenLite(thumbs[i], 0.5, { _x:imagesCoords[i] } );
			aTweens.push(tween);
		}
		
		currentTween.clear(true);
		
		currentTween = TweenGroup(aTweens)
		currentTween.align = TweenGroup.ALIGN_START;
	}
	
	
	private function onMouseMove():Void {		
		if (this._xmouse >= mcMask._x && this._xmouse-paddingLeft <= mcMask._width && this._ymouse >= mcMask.y && this._ymouse <= mcMask._height) {
			nMovement = Math.round(((this._xmouse - (mcMask._width / 2)) / -(mcMask._width / 2)) * nSpeed);				
		} else {
			nMovement = 0
		}
	}
	
	private function onEnterFrame():Void {
		
		for (var i:Number = 0; i < thumbs.length; i++ ) {
			thumbs[i]._x += nMovement;
			if (thumbs[i]._x > nChainWidth - nSpace) {
				thumbs[i]._x -= nChainWidth;
			} else if (thumbs[i]._x < -nThumbWidth) {
				thumbs[i]._x += nChainWidth;
			}
		}
		trace ("nChainWidth " + nChainWidth);
		if (this._xmouse >= mcMask._x && this._xmouse-paddingLeft <= mcMask._width && this._ymouse >= mcMask.y && this._ymouse <= mcMask._height) {
			nMovement =  Math.round(((this._xmouse - (mcMask._width / 2)) / -(mcMask._width / 2)) * nSpeed);
		} else {
			nMovement = 0
		}
		
		//trace ("nMovement  " + ((this._xmouse - (mcMask._width / 2)) / -(mcMask._width / 2)) * nSpeed);
	}
	
	private function btnLeftClick():Void {
		if (imagesCoords[0] >= 0) {
			return;
		}
		
		var fullSpace:Number = thumbWidth + thumbsGap;
		var aTweens:Array = new Array();
		for (var i:Number = 0; i < thumbs.length; i++) {
			imagesCoords[i] = imagesCoords[i] + fullSpace;
			var tween:TweenLite = new TweenLite(thumbs[i], 0.5, { _x:imagesCoords[i] } );
			aTweens.push(tween);
		}
		
		currentTween.clear(true);
		
		currentTween = TweenGroup(aTweens)
		currentTween.align = TweenGroup.ALIGN_START;
	}
}