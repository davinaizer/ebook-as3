package com.unboxds.ebook.pages
{
	import com.gaiaframework.api.Gaia;
	import com.unboxds.ebook.Ebook;
	import com.unboxds.ebook.pages.EbookPage;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	
	public class M_02_P_00 extends EbookPage
	{
		
		public function M_02_P_00()
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
			Ebook.getInstance().getDataController().finishEbook();
		}
	}
}
