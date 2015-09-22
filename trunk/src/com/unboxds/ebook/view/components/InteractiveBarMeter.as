/**
 * Created by Naizer on 21/09/2015.
 */
package com.unboxds.ebook.view.components
{
	import assets.buttons.PlaneCursor;

	import com.greensock.TweenLite;
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

			if (!hasInit)
			{
				cursor = new PlaneCursor() as SimpleButton;
				addChild(cursor);
			}
		}

		override protected function update():void
		{
			super.update();

			var cursorX:Number = _width * (progress / max);
			TweenLite.to(cursor, .25, {overwrite: 1, x: cursorX, alpha: 1});
		}
	}
}
