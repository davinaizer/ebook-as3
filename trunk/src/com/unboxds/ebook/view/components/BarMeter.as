package com.unboxds.ebook.view.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.unboxds.utils.Logger;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.StyleSheet;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */
	public class BarMeter extends AbsProgressMeter
	{
		protected var _width:Number;
		protected var _height:Number;
		protected var hasInit:Boolean;

		private var bgView:Sprite;
		private var barView:Sprite;
		private var secondaryBarView:Sprite;

		private var bgColor:Number;
		private var bgColorAlpha:Number;
		private var barColor:Number;
		private var barColorAlpha:Number;
		private var secondaryBarColor:Number;
		private var secondaryBarColorAlpha:Number;

		public function BarMeter(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			super(contentXML, stylesheet);

			_width = 100;
			_height = 2;

			bgColor = 0xE4E4E4;
			bgColorAlpha = 1;
			barColor = 0x006AB6;
			barColorAlpha = 1;
			secondaryBarColor = 0x00A900;
			secondaryBarColorAlpha = 1;

			hasInit = false;

			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}

		protected function init():void
		{
			Logger.log("BarMeter.init");

			bgView = new Sprite();
			barView = new Sprite();
			secondaryBarView = new Sprite();

			addChild(bgView);
			addChild(secondaryBarView);
			addChild(barView);

			parseConfig();
			draw();

			hasInit = true;
		}

		protected function parseConfig():void
		{
			x = parseFloat(contentXML.@x);
			y = parseFloat(contentXML.@y);

			_width = parseInt(contentXML.@width);
			_height = parseInt(contentXML.@height);

			bgColor = parseInt(contentXML.@bgColor);
			bgColorAlpha = parseFloat(contentXML.@bgColorAlpha);
			barColor = parseInt(contentXML.@barColor);
			barColorAlpha = parseFloat(contentXML.@barColorAlpha);
			secondaryBarColor = parseInt(contentXML.@secondaryBarColor);
			secondaryBarColorAlpha = parseFloat(contentXML.@secondaryBarColorAlpha);
		}

		protected function draw():void
		{
			bgView.graphics.clear();
			bgView.graphics.beginFill(bgColor, bgColorAlpha);
			bgView.graphics.drawRect(0, 0, _width, _height);
			bgView.graphics.endFill();

			barView.graphics.clear();
			barView.graphics.beginFill(barColor, barColorAlpha);
			barView.graphics.drawRect(0, 0, _width, _height);
			barView.graphics.endFill();

			secondaryBarView.graphics.clear();
			secondaryBarView.graphics.beginFill(secondaryBarColor, secondaryBarColorAlpha);
			secondaryBarView.graphics.drawRect(0, 0, _width, _height);
			secondaryBarView.graphics.endFill();
		}

		protected function update():void
		{
			var newBarWidth:Number = _width * (progress / max);
			var newSecondaryBarWidth:Number = _width * (secondaryProgress / max);

			TweenLite.to(barView, .5, {overwrite: 1, width: newBarWidth, ease: Strong.easeOut});
			TweenLite.to(secondaryBarView, .5, {overwrite: 1, width: newSecondaryBarWidth, ease: Strong.easeOut});
		}

		override public function setProgress(progress:uint):void
		{
			this.progress = progress;

			if (hasInit)
				update();
		}

		override public function setSecondaryProgress(progress:uint):void
		{
			this.secondaryProgress = progress;

			if (hasInit)
				update();
		}

		override public function setMax(max:uint):void
		{
			this.max = max;

			if (hasInit)
				draw();
		}

	}

}