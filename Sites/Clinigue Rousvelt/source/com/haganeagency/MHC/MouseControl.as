/**
* ...
* @author Misuta Hagane / Aleksandar Gvozden
*/
import com.pixelbreaker.ui.MouseWheel;
import flash.geom.Rectangle;

class com.haganeagency.MHC.MouseControl {
	
	public static var instance : MouseControl = null;
	
	private var _mouseListener : Object;
	
	private var _triggers : Array;
	

	public function MouseControl() {
		
		init();
		
	}
	
	public function init(Void):Void {
		
		_initMouseListener();
		
	}
	
	private function _initMouseListener(Void):Void {
		
		var $class = this;
		
		_mouseListener = new Object();
		_mouseListener.onMouseWheel = function(delta) {
			$class._mouseScroll(delta);
		}
		//Mouse.addListener(_mouseListener);
		MouseWheel.addListener( _mouseListener );
		
		_triggers = new Array();
		
	}
	
	public function resetScroll(Void):Void {
		
		_triggers = new Array();
	}
	
	public function addScroll(id:String, mc:MovieClip, func:Function):Void {
		
		removeScroll(id);	
		_triggers.push( { id: id, mc: mc, func:func, enabled : true } );
		
	}
	
	public function addScrollArea(id:String, area: Rectangle, func: Function):Void {
		
		removeScroll(id);	
		_triggers.push( { id: id, area: area, func:func, enabled : true } );
		
	}
	
	public function updateScroll(id:String, mc: MovieClip, func:Function):Void {
		
		if (mc != undefined) {
			for (var i : Number = 0; i < _triggers.length; i++) {
				if (_triggers[i].id == id) {
					_triggers.mc = mc;
					if (func != undefined) {
						_triggers.func = func;
					}
					return;
				}
			}
		}
		
	}
	
	public function updateScrollArea(id:String, area: Rectangle, func:Function):Void {
		
		if (area != undefined) {
			for (var i : Number = 0; i < _triggers.length; i++) {
				if (_triggers[i].id == id) {
					_triggers.area = area;
					if (func != undefined) {
						_triggers.func = func;
					}
					return;
				}
			}
		}
		
	}
	
	public function enableScroll(id:String, fEnable : Boolean):Void {
		
		for (var i : Number = 0; i < _triggers.length; i++) {
			if (_triggers[i].id == id) {
				_triggers[i].enabled = fEnable;
			}
		}
		
	}
	
	public function removeScroll(id:String):Void {
		
		var aTemp : Array = new Array();
		
		for (var i : Number = 0; i < _triggers.length; i++) {
			if (_triggers[i].id != id) {
				aTemp.push(_triggers[i]);
			}
		}
		
		_triggers = aTemp;
				
	}
	
	private function _mouseScroll(delta):Void {
		//trace("Mouse scroll : " + delta);
		
		for (var i : Number = 0; i < _triggers.length; i++) {

			if (_triggers[i].enabled && (_triggers[i].mc != undefined && _triggers[i].mc.hitTest(_root._xmouse, _root._ymouse)) || (_triggers[i].area != undefined && _triggers[i].area.contains(_root._xmouse, _root._ymouse))) {
				_triggers[i].func(delta);
			}
		}
		
	}
	
	public function destroy(Void):Void {
		
		Mouse.removeListener(_mouseListener);
		_triggers = new Array();
			
	}
	
	public static function getInstance() : MouseControl {
		if (instance == null) instance = new MouseControl();
		return instance;
	} 
	
}