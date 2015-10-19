package com.unboxds.ebook.pages
{
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */

	public class M_00_P_04 extends EbookPage
	{
		public function M_00_P_04()
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
