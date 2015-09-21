/*****************************************************************************************************
 * Gaia Framework for Adobe Flash ©2007-2009
 * Author: Steven Sacks
 *
 * blog: http://www.stevensacks.net/
 * forum: http://www.gaiaflashframework.com/forum/
 * wiki: http://www.gaiaflashframework.com/wiki/
 *
 * By using the Gaia Framework, you agree to keep the above contact information in the source code.
 *
 * Gaia Framework for Adobe Flash is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license
 *****************************************************************************************************/

package com.unboxds.ebook.pages
{
	import com.gaiaframework.events.AssetEvent;
	import com.gaiaframework.templates.AbstractPreloader;
	
	public class Preloader extends AbstractPreloader
	{
		public var scaffold:PreloaderScaffold;
		
		public function Preloader()
		{
			super();
			init();
		}
		
		private function init():void
		{
			scaffold = new PreloaderScaffold();
			addChild(scaffold);
		}
		
		override public function transitionIn():void
		{
			scaffold.transitionIn();
			transitionInComplete();
		}
		
		override public function transitionOut():void
		{
			scaffold.transitionOut();
			transitionOutComplete();
		}
		
		override public function onProgress(event:AssetEvent):void
		{
			scaffold.onProgress(event);
		}
	}
}
