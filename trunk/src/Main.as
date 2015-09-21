package
{
	/*
	 * [UNBOX® 2009-2013 — http://www.unbox.com.br — All rights reserved.]
	 * */
	import com.unboxds.ebook.EbookContext;
	import com.unboxds.ebook.GaiaContext;
	import com.unboxds.utils.Logger;
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class Main extends Sprite
	{
		private var gaiaContext:GaiaContext;
		private var ebookContext:EbookContext;
		
		public function Main()
		{
			startup();
		}
		
		private function startup():void
		{
			Logger.log("Main.startup");
			
			// Register domains
			Security.allowDomain("file://");
			Security.allowDomain("localhost");
			Security.allowDomain("127.0.0.1");
			
			gaiaContext = new GaiaContext();
			gaiaContext.onComplete.add(onGaiaComplete);
			
			addChild(gaiaContext);
		}
		
		private function onGaiaComplete():void
		{
			Logger.log("Main.onGaiaComplete");
			
			ebookContext = new EbookContext(this, gaiaContext.data);
			ebookContext.startup();
		}
	}
}
