package com.controls.away3d
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.render.Renderer;
	import away3d.events.MouseEvent3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.data.CubeMaterialsData;
	
	import com.elements.BmpGradient;
	import com.events.CustomEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import gs.TweenMax;
	import gs.easing.Quad;

	public class Book3d extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _bookWidth:Number;
		private var _bookHeight:Number;
		private var _bookDepth:Number;
		
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var gizmo:ObjectContainer3D;
		private var gizmoBook:ObjectContainer3D;
		
		private var floor:Object3D;
		private var book:Object3D;
		private var portada:Plane;
		
		private const _time:Number = 1.0;
		
		private var _open:Boolean = false;
		private var _zoom:Boolean = false;
		
		private var _initRotX:Number;
		private var _initRotY:Number;
		
		private var cover:Bitmap;
		
		public function Book3d(cover:Bitmap, _bookWidth:Number, _bookHeight:Number, _bookDepth:Number)
		{
			this.cover = cover;
			this._width = cover.width;
			this._height = cover.height;
			this._bookWidth = _bookWidth;
			this._bookHeight = _bookHeight;
			this._bookDepth = _bookDepth;
			
			scene = new Scene3D();
			camera = new Camera3D({zoom:50, focus:30, x:0, y:0, z:-996});
			camera.lens = new PerspectiveLens();
			
			view = new View3D({scene:scene, camera:camera, renderer: Renderer.CORRECT_Z_ORDER});
			view.x = _width;
			view.y = 0.5*_height;
			
			this.addChild(view);
			
			_initRotX = 45; 
			_initRotY = -15;
			
			var textureFloor:Bitmap = new BmpGradient(900, 600, 0xffffff, 0x000000);
			var materialFloor:BitmapMaterial = new BitmapMaterial(textureFloor.bitmapData);
			
			floor = new Plane({material:materialFloor, x:0, y:0, z:0, width:textureFloor.width, height:textureFloor.height, segmentsW:4, segmentsH:4});
			
			var materialPortada:BitmapMaterial = new BitmapMaterial(cover.bitmapData);
			var bmpd:BitmapData = new BitmapData(712, 800, false, 0xEEEEEE);
			var cubeMaterials:CubeMaterialsData = new CubeMaterialsData({	left:new ColorMaterial(0x000000),
																			right:new ColorMaterial(0xCCCCCC),
																			top:new ColorMaterial(0xCCCCCC),
																			bottom:new ColorMaterial(0xCCCCCC),
																			front:new ColorMaterial(0xCCCCCC),
																			back:new ColorMaterial(0x333333)
																		});
			book = new Cube({cubeMaterials:cubeMaterials,	x:0, y:Math.ceil(0.5*_bookDepth), z:0,
															rotationX:90, rotationY:180, rotationZ:0,
															width:_bookWidth, height:_bookHeight, depth:_bookDepth,
															segmentsW:3, segmentsH:3});
			
			portada = new Plane({material:materialPortada,	back:new ColorMaterial(0xCCCCCC),
															x:-0.5*_bookWidth, y:Math.ceil(_bookDepth)+1, z:0,
															width:_bookWidth, height:_bookHeight,
															segmentsW:8, segmentsH:8});
			
			
			materialPortada.smooth = true;
			portada.bothsides = true;
			portada.movePivot(	-0.5*_bookWidth, 0, 0);
			
			gizmoBook = new ObjectContainer3D(book, portada);
			
			gizmo = new ObjectContainer3D(floor,gizmoBook);
			gizmo.x = 0.5*_bookWidth;
			floor.x = -0.5*_bookWidth;
			
			gizmoBook.rotationY = _initRotY;
			gizmo.rotationX = _initRotX;
			scene.addChild(gizmo);
			
			portada.useHandCursor = true;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			portada.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownPortadaHandler);
			book.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownBookHandler);
			
			gizmoBook.x = 1000;
			gizmoBook.z = 1500;
			gizmoBook.rotationY = 360;
			TweenMax.to(gizmoBook, 2.0, {x:0, z:0, rotationY:_initRotY, ease: Quad.easeOut});
			
		}
		
		private function updateInnerBook(leftPage:BitmapData, rightPage:BitmapData):void
		{
			var bmpMaterial:BitmapMaterial;
			if (getQualifiedClassName((book as Cube).cubeMaterials.front) == "away3d.materials::BitmapMaterial") {
				bmpMaterial = (book as Cube).cubeMaterials.front as BitmapMaterial;
				bmpMaterial.bitmap.dispose();
			}
			if (getQualifiedClassName((portada as Plane).back) == "away3d.materials::BitmapMaterial") {
				bmpMaterial = (portada as Plane).back as BitmapMaterial;
				bmpMaterial.bitmap.dispose();
			}
			
			var materialLeftPage:BitmapMaterial = new BitmapMaterial(leftPage);
			materialLeftPage.smooth = true;
			var materialRightPage:BitmapMaterial = new BitmapMaterial(rightPage);
			materialRightPage.smooth = true;
			
			(book as Cube).cubeMaterials.front = materialRightPage;
			(portada as Plane).back = materialLeftPage;
		}
		
		private function enterFrameHandler(event:Event):void
		{
			
			if (view.stage!=null) view.render();
		}
		
		private function mouseDownBookHandler(event:MouseEvent3D):void
		{
			if (open) zoom = true;
		}
		
		private function mouseDownPortadaHandler(event:MouseEvent3D):void
		{
			open = !open;
			if (TweenMax.isTweening(portada)) TweenMax.killTweensOf(portada);
			TweenMax.to(portada, 2.0*_time, {rotationZ:(open)?180:0, ease: Quad.easeInOut});
			book.useHandCursor = open;
		}
		
		private function get open():Boolean
		{
			return _open;
		}
		
		private function set open(value:Boolean):void
		{
			this._open = value;
		}
		
		public function get zoom():Boolean
		{
			return _zoom;
		}
		
		public function set zoom(value:Boolean):void
		{
			if (TweenMax.isTweening(gizmo)) TweenMax.killTweensOf(gizmo);
			if (TweenMax.isTweening(gizmoBook)) TweenMax.killTweensOf(gizmoBook);
			TweenMax.to(gizmo, _time, {z:(value)?-225:0, rotationX:(value)?90:_initRotX, ease: Quad.easeInOut});
			TweenMax.to(gizmoBook, _time, {rotationY:(value)?0:_initRotY, ease: Quad.easeInOut, onComplete:completeZoomHandler, onCompleteParams:[value]});
		}
		
		private function completeZoomHandler(value:Boolean):void
		{
			this._zoom = value;
			dispatchEvent(new CustomEvent(CustomEvent.ZOOM_EVENT, value));
		}
		
		public function updatePages(leftPage:BitmapData, rightPage:BitmapData):void
		{
			updateInnerBook(leftPage, rightPage);
			var materialRightPage:BitmapMaterial = new BitmapMaterial(rightPage);
			var materialLeftPage:BitmapMaterial = new BitmapMaterial(leftPage);
			materialRightPage.smooth = true;
			materialLeftPage.smooth = true;
		}
	}
}