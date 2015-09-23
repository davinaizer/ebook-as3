/**
 * Created by Naizer on 21/09/2015.
 */
package com.unboxds.ebook.view.components
{
	import assets.buttons.ProgressCursor;

	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.utils.Logger;

	import flash.text.StyleSheet;

	public class InteractiveBarMeter extends BarMeter
	{
		private var cursor:SimpleButton;

		public function InteractiveBarMeter(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			Logger.log("InteractiveBarMeter.InteractiveBarMeter");
			super(contentXML, stylesheet);
		}

		override protected function init():void
		{
			Logger.log("InteractiveBarMeter.init");

			super.init();

			cursor = new ProgressCursor() as SimpleButton;
			cursor.name = "progressCursor";
			addChild(cursor);

			parseContent();
		}

		override protected function update():void
		{
			super.update();

			var cursorX:Number = _width * (progress / max);
			TweenLite.to(cursor, .5, {overwrite: 1, x: cursorX, ease: Strong.easeOut});
		}

		public function get progressPercent():Number
		{
			return (progress / max) * 100;
		}
	}
}
