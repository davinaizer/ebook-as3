package com.unboxds.ebook.pages
{
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */

	public class M_02_P_01 extends EbookPage
	{
		public function M_02_P_01()
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
			//Gaia.api.getPage(Pages.NAV).content.enableNextButton();
		}

	}
}
