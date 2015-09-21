package com.unboxds.ebook.pages
{
	import com.gaiaframework.api.Gaia;
	import com.unboxds.ebook.pages.EbookPage;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	
	public class M_01_P_00 extends EbookPage
	{
		
		public function M_01_P_00()
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
			Gaia.api.getPage(Pages.NAV).content.enableNextButton();
		}
	}
}
