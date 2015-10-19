package com.unboxds.ebook.pages
{
	import com.unboxds.button.SimpleButton;
	import com.unboxds.ebook.EbookApi;

	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */

	public class M_00_P_03 extends EbookPage
	{
		public function M_00_P_03()
		{
			super();
			alpha = 0;
		}

		override public function transitionIn():void
		{
			super.transitionIn();
		}

		override public function transitionOut():void
		{
			super.transitionOut();
		}

		override public function transitionInComplete():void
		{
			super.transitionInComplete();
			init();
		}

		override public function init():void
		{
			super.init();

			var btn:SimpleButton = this.getChildByName("nextBtn") as SimpleButton;
			if(btn)
				btn.addEventListener(MouseEvent.CLICK, mouseHandler, false, 0, true);
		}

		private function mouseHandler(e:MouseEvent):void
		{
			EbookApi.getNavController().nextPage();
		}
	}
}
