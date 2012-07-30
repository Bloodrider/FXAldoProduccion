/**
Copyright (c) 2006 Adobe Systems Incorporated

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package qs.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mx.core.IFlexDisplayObject;
	import flash.display.DisplayObject;
	import mx.core.IUIComponent;

	public class UIBitmap extends Bitmap
						 implements IFlexDisplayObject
 	{
		public function UIBitmap(bmd:Object = null,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			super((bmd as BitmapData),pixelSnapping,smoothing);
			if(bmd is IUIComponent)
			{				
				var data:BitmapData = new BitmapData(bmd.width,bmd.height);
				var o:* = bmd;
				data.draw(o);
				bitmapData = data;
			}
		}
		public function get measuredHeight():Number
		{
			return bitmapData.height;
		}
		public function get measuredWidth():Number
		{
			return bitmapData.width;
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	
		/**
		 *  Sets the height and width of this object.
		 */
		public function setActualSize(newWidth:Number, newHeight:Number):void
		{
			width = newWidth;
			height = newHeight;
		}								
	}
}