package com.unboxds.ebook.pages
{
	import com.gaiaframework.templates.AbstractPage;
	
	public class ModulePage extends AbstractPage
	{
		//-- DUMMY PAGE
		public function ModulePage()
		{
			super();
			alpha = 0;
		}
		
		override public function transitionIn():void
		{
			super.transitionIn();
			transitionInComplete();
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
			transitionOutComplete();
		}
	}
}
