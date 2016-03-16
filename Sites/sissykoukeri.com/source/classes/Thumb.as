import classes.ThumbObject;
import gs.TweenLite;
/**
 * ...
 * @author Michael Pavlov
 */

class classes.Thumb extends MovieClip {
	
	private var loader:MovieClipLoader;
	private var thumbData:ThumbObject;
	private var container:MovieClip;
	private var border:MovieClip;
	private var tintMask:MovieClip;
	
	private var _clickFunc:Function;
	
	public var active:Boolean = false;
	
	public function Thumb() {
		loader = new MovieClipLoader();
		loader.addListener(this);
	}
	
	public function init($vo:ThumbObject):Void {
		thumbData = $vo;
		this.loadThumb();
	}
	
	private function loadThumb():Void {
		container = this.createEmptyMovieClip("container", this.getNextHighestDepth());
		loader.loadClip(thumbData.thumbUrl, container);
	}
	
	private function onLoadInit($target:MovieClip):Void {
		var w:Number = $target._width;
		var h:Number = $target._height;
		
		createEmptyMovieClip("border", getNextHighestDepth());
		createEmptyMovieClip("tintMask", getNextHighestDepth());
		
		/*$target.lineStyle(2, thumbData.thumbBorderColor);
		$target.moveTo(0, 0);
		$target.lineTo(w, 0);
		$target.lineTo(w, h);
		$target.lineTo(0, h);
		$target.lineTo(0, 0);*/
		
		if (thumbData.thumbBorder) {
			border.lineStyle(2, thumbData.thumbBorderColor);
			border.moveTo(0, 0);
			border.lineTo(w, 0);
			border.lineTo(w, h);
			border.lineTo(0, h);
			border.lineTo(0, 0);		
		}
		
		//border.lineStyle(2, thumbData.thumbBorderColor);
		/*tintMask.beginFill(0x000000);
		tintMask.moveTo(0, 0);
		tintMask.lineTo(w, 0);
		tintMask.lineTo(w, h);
		tintMask.lineTo(0, h);
		tintMask.lineTo(0, 0);	
		tintMask.endFill();*/
		
		this.deActivate();
	}
	
	public function onRelease():Void {
		if (_clickFunc != undefined) {
			_clickFunc(thumbData, this);
		}
	}
	
	public function onRollOver():Void {
		if (active) {
			return
		}
		TweenLite.to(border, 0.5, { _alpha:100 } );
		TweenLite.to(container, 0.5, { _alpha:100 } );
	}
	
	public function onRollOut():Void {
		//trace (this + "  " +active);
		if (active) {
			return;
		}
		TweenLite.to(border, 0.5, { _alpha:0 } );
		TweenLite.to(container, 0.5, { _alpha:70 } );
	}
	
	public function activate():Void {
		active = true;
		TweenLite.to(border, 0.5, { _alpha:100 } );
		TweenLite.to(container, 0.5, { _alpha:100 } );
		
		//TweenLite.to(tintMask, 0.5, {_alpha:0});
	}
	
	public function deActivate():Void {		
		active = false;
		TweenLite.to(border, 0.5, { _alpha:0 } );
		TweenLite.to(container, 0.5, { _alpha:70 } );
		//TweenLite.to(tintMask, 0.5, {_alpha:30});
	}
	
	public function set clickFunction($func:Function):Void {
		_clickFunc = $func;
	}
	
	public function get clickFunction() { 
		return _clickFunc;
	}
}