package com.unboxds.ebook.pages
{
	import assets.CourseBgSymbol;

	import com.gaiaframework.templates.AbstractPage;
	import com.greensock.TweenLite;
	import com.unboxds.utils.Align;
	import com.unboxds.utils.Logger;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	
	public class IndexPage extends AbstractPage
	{
		private var courseBg:CourseBgSymbol;
		
		public function IndexPage()
		{
			Logger.log("IndexPage.IndexPage");
			
			super();
			alpha = 0;
		}
		
		override public function transitionIn():void
		{
			super.transitionIn();
			transitionInComplete();
			TweenLite.to(this, .25, {alpha: 1});
			
			init();
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
			transitionOutComplete();
			TweenLite.to(this, .25, {alpha: 0});
		}

		private function init():void
		{
			courseBg = new CourseBgSymbol();
			addChild(courseBg);
			Align.to(courseBg, stage, {align: Align.TOP_RIGHT});
		}

	}
}
