package com.unboxds.ebook.pages
{
	import com.gaiaframework.api.Gaia;
	import com.unboxds.ebook.EbookApi;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */

	public class M_01_P_06 extends EbookPage
	{
		public var userName:String;
		public var today:Date;

		public function M_01_P_06()
		{
			super();
			alpha = 0;
			userName = EbookApi.getEbookModel().studentName;
			today = new Date();
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
			Gaia.api.getPage(Pages.NAV).content.enableNextButton();
		}

	}
}
