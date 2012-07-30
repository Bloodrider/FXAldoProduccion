// ActionScript file

private var book3d:Book3d;
import br.com.stimuli.loading.BulkLoader;
import br.com.stimuli.loading.BulkProgressEvent;

import com.controls.away3d.Book3d;
import com.events.CustomEvent;
import com.rubenswieringa.book.Page;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import gs.TweenMax;
import gs.easing.Linear;

import mx.core.UIComponent;
import mx.rpc.events.ResultEvent;

[Embed(	
	source='assets/fonts/BoschSans-Regular.otf',
	fontName='Bosch Sans Regular',
	mimeType='application/x-font',
	advancedAntiAliasing='true'
)]
private var BoschFont:Class;

private var _xml:XML;
private var numImages:int;

private var loaderText:TextField;

private function initApp():void
{
	xmlLoader.url = "xml/libro.xml";
	xmlLoader.send();
}

private function resultHandler(event:ResultEvent):void
{
	_xml = event.result as XML;
	
	var _loader_tf:TextFormat = new TextFormat("Bosch Sans Regular", 20, 0xffffff);
	_loader_tf.align = TextFormatAlign.LEFT;
	
	loaderText = creaTexto("", _loader_tf, 0, 50, 0);
	loaderText.x = -0.5*loaderText.width;
	loaderText.y = -0.5*loaderText.height;
	loaderText.visible = false;
	loaderText.alpha = 0.0;
	loaderText.filters = [new DropShadowFilter(0, 0, 0x000000, 1.0, 4, 4, 1.0, 2)];
	
	preloaderContainer.addChild(loaderText);
	
	var loader:BulkLoader = new BulkLoader("imageLoader");
	
	var i:int;
	numImages = _xml.book.page.length();
	for (i=0; i<numImages; i++) {
		loader.add(_xml.book.page[i].toString(), {id:"image_" + i.toString()});
	}
	
	loader.add(_xml.config.cover.img.toString(), {id:"cover"});
	
	loader.addEventListener(BulkProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
	loader.addEventListener(BulkProgressEvent.COMPLETE, onCompleteHandler, false, 0, true);
	loader.start();
	
	TweenMax.to(loaderText, 0.25, {autoAlpha:1.0, ease: Linear.easeNone});
}

private function onProgressHandler(event:BulkProgressEvent):void
{
	if (event.weightPercent>0) loaderText.text = "Cargando " + Math.round(100*event.weightPercent).toString()+"%";
}

private function onCompleteHandler(event:BulkProgressEvent):void
{
	TweenMax.to(loaderText, 0.1, {autoAlpha:0.0, ease: Linear.easeNone, onComplete:function():void{preloaderContainer.visible = false;}});
	var loader:BulkLoader = BulkLoader.getLoader("imageLoader");
	loader.removeEventListener(BulkProgressEvent.PROGRESS, onProgressHandler);
	loader.removeEventListener(BulkProgressEvent.COMPLETE, onCompleteHandler);
	
	var uiComponent:UIComponent;
	var i:int;
	for (i=0; i<numImages; i++) {
		uiComponent = this["page_" + i.toString()];
		uiComponent.addChild(loader.getBitmap("image_" + i.toString(), true));
		
	}
	
	book3d = new Book3d(loader.getBitmap("cover", true), 240, 300, 20);
	book3d.addEventListener(CustomEvent.ZOOM_EVENT, zoomEventHandler);
	updateInnerBook(book.pages[book.currentPage], book.pages[book.currentPage+1]);
	mainContainer.addChild(book3d);
}

private function updateInnerBook(leftPage:Page, rightPage:Page):void
{
	var matrix:Matrix = new Matrix();
	matrix.scale(-1, 1);
	matrix.translate(leftPage.width, 0);
	
	var startPage:BitmapData = new BitmapData(leftPage.width, leftPage.height, false, 0xffffff);
	startPage.draw(leftPage, matrix);
	
	var mainPage:BitmapData = new BitmapData(rightPage.width, rightPage.height, false, 0xffffff);
	mainPage.draw(rightPage);
	
	book3d.updatePages(startPage, mainPage);
}

private function clickHandler(event:MouseEvent):void
{
	if (book.status == "notFlipping" && book3d.zoom) {
		updateInnerBook(book.pages[book.currentPage], book.pages[book.currentPage+1]);
		book3d.zoom = false;
		containerPages.visible = false;
	}
}

private function loadImageHandler(event:Event):void
{
	(event.target.content as Bitmap).smoothing = true;
}

private function zoomEventHandler(event:CustomEvent):void
{
	if (event.state) containerPages.visible = event.state;
}

public static function creaTexto(texto:String, formato:TextFormat, _width:Number=0, _thickness:Number=0, _sharpness:Number=0, _autosize:String = "left", _selectable:Boolean=false, _antialiasType:String="advanced"):TextField
{
	var campoTexto:TextField = new TextField();
	campoTexto.selectable = _selectable;
	campoTexto.mouseEnabled = _selectable;
	campoTexto.embedFonts = true;
	campoTexto.antiAliasType = _antialiasType;
	campoTexto.autoSize = _autosize;
	/*  
	campoTexto.border = true;
	campoTexto.borderColor = 0x000000;
	 */
	campoTexto.thickness = _thickness;
	campoTexto.sharpness = _sharpness;
	campoTexto.defaultTextFormat = formato;
	campoTexto.text = texto;
	if (_width>0) {
		campoTexto.width = _width;
		campoTexto.wordWrap = true;
	}
	return campoTexto;
}

