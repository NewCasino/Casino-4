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
	private var DEFAULT_THUMB_HEIGHT:Number = 68;
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
	private var mask:MovieClip;
	private var tileList:MovieClip;
	private var btnLeft:MovieClip;
	private var btnRight:MovieClip;
	private var lastActiveThumb:MovieClip;
	
	private var _maxThumbsToShow:Number = 7;
	
	private var currentTween:TweenGroup;
	
	public function Gallery() {
		emptyBackground._alpha = 0;
		//btnLeft._visible = false;
		//btnRight._visible = false;
		tileList.setMask(mask);
		xXml = new XML();
		xXml.ignoreWhite = true;
		xXml.onLoad = Delegate.create(this, this.parseXML);
		xXml.load(GALLERY_XML_URL);
		
		mask._width = 500;
		mask._height = 80;
		
		btnLeft.onRelease = Delegate.create(this, this.btnLeftClick);
		btnRight.onRelease = Delegate.create(this, this.btnRightClick);
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
		btnLeft._y = thumbHeight / 2;
		
		var thumb:MovieClip;
		var fullSpace:Number = thumbWidth + thumbsGap;
		
		for (var i:Number = 0; i < numImages; i++) {
			thumb = thumbs[i];
			thumb._x = i * fullSpace;
			imagesCoords.push(thumb._x);
			thumb._y = 10;
		}
		
		mask._width = _maxThumbsToShow * fullSpace;
		mask._x = tileList._x - 2;
		btnRight._x = mask._width + mask._x;
		btnRight._y = btnLeft._y;		
	}
	
	public function setSize($width:Number, $height:Number):Void {
		var cursor:Number = 0;
		btnLeft._x = thumbsGap * 2;
		tileList._x = btnLeft._x + btnLeft._width + thumbsGap;
		btnLeft._y = thumbHeight / 2;
		
		var thumb:MovieClip;
		var fullSpace:Number = thumbWidth + thumbsGap;
		
		mask._width = _maxThumbsToShow * fullSpace;
		mask._x = tileList._x - 2;
		btnRight._x = mask._width + mask._x;
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
		if (imagesCoords[numImages-1] <= mask._width - 10) {
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