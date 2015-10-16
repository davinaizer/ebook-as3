package
{
	/*
	 * [UNBOX® 2009-2013 — http://www.unbox.com.br — All rights reserved.]
	 * */

	import com.unboxds.components.FontManager;
	import com.unboxds.ebook.EbookContext;
	import com.unboxds.ebook.GaiaContext;
	import com.unboxds.utils.Logger;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Security;

	public class Main extends Sprite
	{
		private var gaiaContext:GaiaContext;

		public function Main()
		{
			init();
		}

		private function init():void
		{
			Logger.log("Main.init");

			// Register domains
			Security.allowDomain("file://");
			Security.allowDomain("localhost");
			Security.allowDomain("127.0.0.1");

			//- stage config
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			gaiaContext = new GaiaContext();
			gaiaContext.onComplete.add(onGaiaComplete);

			addChild(gaiaContext);
		}

		private function onGaiaComplete():void
		{
			Logger.log("Main.onGaiaComplete");

			FontManager.embedFonts();

			new EbookContext(this, gaiaContext.data).bootstrap();
		}
	}
}
