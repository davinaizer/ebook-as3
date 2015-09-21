/**
 * Created by davinaizer on 9/17/15.
 */
package com.unboxds.ebook.view.components
{
	import com.unboxds.ebook.view.ui.ContentObject;

	import flash.events.Event;
	import flash.text.StyleSheet;

	public class AbstractProgressMeter extends ContentObject
	{
		protected var progress:uint;
		protected var secondaryProgress:uint;
		protected var max:uint;

		public function AbstractProgressMeter(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			super(contentXML, stylesheet);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}

		protected function init():void
		{
			progress = 0;
			secondaryProgress = 0;
			max = 100;
		}

		/**
		 * Defines the default progress value, between 0 and max.
		 * @value progress
		 */
		public function setProgress(progress:uint):void
		{
			this.progress = progress;
		}

		/**
		 * Defines the secondary progress value, between 0 and max.
		 * This progress is drawn between the primary progress and the background.
		 * It can be ideal for media scenarios such as showing the buffering progress while the default progress shows the play progress.
		 * @value progress
		 */
		public function setSecondaryProgress(progress:uint):void
		{
			this.secondaryProgress = progress;
		}

		/**
		 * Specifies whether this object receives mouse, or other user input, messages.
		 * @value max
		 */
		public function setMax(max:uint):void
		{
			this.max = max;
		}

		/**
		 * Specifies whether this object receives mouse, or other user input, messages.
		 * @value value
		 */
		public function enable(value:Boolean):void
		{
			this.mouseEnabled = value;
			this.mouseChildren = value;
		}
	}
}
