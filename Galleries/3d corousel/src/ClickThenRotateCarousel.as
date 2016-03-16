package {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.BlurFilter;

	import org.papervision3d.core.effects.view.ReflectionView;
	import org.papervision3d.core.math.Quaternion;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;	

	[SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
	public class ClickThenRotateCarousel extends ReflectionView	{
		[Embed(source="assets/pic.png")]
		private var picAsset:Class;
		
		private const RADIUS:Number = 150;
		private const NUM_OF_PLANES:int = 9;
		private var carousel:DisplayObject3D = new DisplayObject3D();
		
		private var currentQuat:Quaternion = new Quaternion();		
		private var targetQuat:Quaternion = new Quaternion();
		private var slerp:Number = 0;
		
		
		public function ClickThenRotateCarousel() {
			viewportReflection.filters = [new BlurFilter(3,3,3)];
			viewport.interactive = true;
			surfaceHeight = -100; 
			camera.y = 80;
			camera.z = 300; //move camera to the front
			
			var pic:Bitmap = Bitmap(new picAsset());
			
			for(var i:int = 0; i < NUM_OF_PLANES; i++) {
				var material:BitmapMaterial = new BitmapMaterial(pic.bitmapData, true);
				material.doubleSided = true;
				material.interactive = true;
				
				var plane:Plane = new Plane(material, 100, 100);
				plane.rotationY = 360 / NUM_OF_PLANES * i;
				plane.moveForward(RADIUS);
				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, objectOverHandler);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, objectOutHandler);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, objectClickHandler);
				
				carousel.addChild(plane);
			}
			
			scene.addChild(carousel);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function objectOverHandler(event:InteractiveScene3DEvent):void {
			viewport.buttonMode = true;
		}

		private function objectOutHandler(event:InteractiveScene3DEvent):void {
			viewport.buttonMode = false;
		}
		
		private function objectClickHandler(event:InteractiveScene3DEvent):void {
			var radians:Number = (carousel.rotationY - event.displayObject3D.rotationY) * Quaternion.DEGTORAD;

			slerp = 0;
			currentQuat = Quaternion.createFromMatrix(carousel.transform);
			targetQuat = Quaternion.createFromAxisAngle(0, 1, 0, radians);
		}
		
		private function enterFrameHandler(event:Event):void {
			slerp += (1 - slerp) * .05;
			var quat:Quaternion = Quaternion.slerp(currentQuat, targetQuat, slerp);
			
			carousel.transform = quat.matrix;
			
			singleRender();
		}
	}
}