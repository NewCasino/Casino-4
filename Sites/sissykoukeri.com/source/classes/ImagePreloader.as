import flash.display.BitmapData;
import gs.TweenLite;
/**
 * ...
 * @author Michael Pavlov
 */

class classes.ImagePreloader extends MovieClip {
	
	private var tintMask:MovieClip;
	private var imageContainer:MovieClip;
	private var loader:MovieClipLoader;
	private var tmpMovie:MovieClip;
	private var preloader:MovieClip;
	
	private var imageUrl:String = "";
	private var completeSound:Sound;
	
	public function ImagePreloader() {
		imageContainer = createEmptyMovieClip("imageContainer", -6);
		tintMask = createEmptyMovieClip("tintMask", this.getNextHighestDepth());
		
		tintMask.beginFill(0x333333);
		tintMask.moveTo(0, 0);
		tintMask.lineTo(Stage.width, 0);
		tintMask.lineTo(Stage.width, Stage.height);
		tintMask.lineTo(0, Stage.height);
		tintMask.lineTo(0, 0);	
		tintMask.endFill();
		
		loader = new MovieClipLoader();
		loader.addListener(this);
		tintMask._alpha = 0;
		tmpMovie = createEmptyMovieClip("tmpMovie", -10000);
		//tmpMovie._alpha = 0;
		Stage.addListener(this);
		completeSound = new Sound(this);
		completeSound.attachSound("bell");
		preloader._visible = false;
		preloader.swapDepths(1000);
	}
	
	private function onLoadInit($target:MovieClip):Void {		
		$target._visible = false;
		var bitmap:BitmapData = new BitmapData($target._width, $target._height, true);		
		imageContainer.attachBitmap(bitmap, imageContainer.getNextHighestDepth(), "auto", true);
		bitmap.draw($target);
		this.onResize();
		completeSound.start();		
		TweenLite.to(tintMask, 0.75, { _alpha:0 } );
		//preloader._visible = false;
	}
	
	private function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
		var perc:Number = (bytesLoaded / bytesTotal) * 100;
		preloader.gotoAndStop(Math.round(perc));
		//trace(target + ".onLoadProgress with " + bytesLoaded + " bytes of " + bytesTotal);
	}
	
	public function load($url:String):Void {
		imageUrl = $url;
		TweenLite.to(tintMask, 0.5, { _alpha:100, onComplete:mx.utils.Delegate.create(this, this.startLoading)} );
	}
	
	public function fadeIn():Void {
		this._alpha = 0;
		this._visible = true;
		TweenLite.to(this, 0.5, { _alpha:100 } );
	}
	
	public function fadeOut():Void {
		this._alpha = 100;
		var $this = this;
		TweenLite.to(this, 0.5, { _alpha:0, onComplete:function(){$this._visble = false} } );
	}
	
	private function startLoading():Void {
		//preloader._visible = true;
		preloader.gotoAndStop(1);
		imageContainer.clear();
		imageContainer = createEmptyMovieClip("imageContainer", -6);		
		loader.unloadClip(tmpMovie);
		loader.loadClip(imageUrl, tmpMovie);
	}
	
	public function onResize():Void {
		var middleX = Stage.width/2;
		var middleY = Stage.height / 2;
		imageContainer._width = Stage.width;
		imageContainer._height = Stage.height;
		tintMask._width = Stage.width;
		tintMask._height = Stage.height
		
		// see if it grew bigger horizontally or vertically and adjust other to match
		// to maintain aspect ratio
		imageContainer._xscale > imageContainer._yscale ? imageContainer._yscale = imageContainer._xscale : imageContainer._xscale = imageContainer._yscale;

	}
}