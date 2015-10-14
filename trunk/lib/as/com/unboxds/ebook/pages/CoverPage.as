package com.unboxds.ebook.pages
{
	import com.unboxds.button.SimpleButton;
	import com.unboxds.ebook.EbookApi;

	import flash.events.MouseEvent;

	public class CoverPage extends EbookPage
	{
		public var startBtn:SimpleButton;
		
		public function CoverPage()
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
		}
		
		override public function init():void
		{
			super.init();
			startBtn.addEventListener(MouseEvent.CLICK, mouseHandler);
		}
		
		public function mouseHandler(e:MouseEvent):void
		{
			if (e.type == MouseEvent.CLICK)
			{
				switch (e.target)
				{
					case startBtn:
						startBtn.setLocked(true);
						EbookApi.getEbookController().start();
						break;
					
					default:
						break;
				}
			}
			
			e.stopPropagation();
		}

	}
}
