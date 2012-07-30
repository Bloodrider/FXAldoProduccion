package com.elements
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	public class BmpGradient extends Bitmap
	{
		public function BmpGradient(_width:Number, _height:Number, _frontColor:uint, _bgColor:uint)
		{
			var bmpd:BitmapData = new BitmapData(_width, _height, false, _bgColor);
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_width, _height);
			var shape:Shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.RADIAL, [_frontColor, _frontColor, _frontColor], [1.0, 0.5, 0.0], [0, 127, 255], matrix, SpreadMethod.PAD, InterpolationMethod.RGB);
			shape.graphics.drawRect(0, 0, _width, _height);
			
			bmpd.draw(shape);
			this.bitmapData = bmpd;
		}
		
	}
}