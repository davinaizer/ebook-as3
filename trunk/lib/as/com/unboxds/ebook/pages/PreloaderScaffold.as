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
	import assets.PreloaderSymbol;
	import com.gaiaframework.events.AssetEvent;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class PreloaderScaffold extends Sprite
	{
		private var view:PreloaderSymbol;
		
		public var TXT_Overall:TextField;
		public var TXT_Bytes:TextField;
		public var MC_Bar:Sprite;
		
		public function PreloaderScaffold()
		{
			super();
			
			alpha = 0;
			visible = false;
			mouseEnabled = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onResize);
			
			init();
			onResize();
		}
		
		private function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			view = new PreloaderSymbol();
			addChild(view);
			
			MC_Bar = view.MC_Bar;
			TXT_Bytes = view.TXT_Bytes;
			TXT_Overall = view.TXT_Overall;
		}
		
		public function transitionIn():void
		{
			TweenLite.to(this, .25, {autoAlpha: 1});
		}
		
		public function transitionOut():void
		{
			TweenLite.to(this, .25, {autoAlpha: 0});
		}
		
		public function onProgress(event:AssetEvent):void
		{
			visible = event.bytes ? (event.loaded > 0) : (event.perc > 0);
			
			var assetPerc:int = Math.round(event.asset.percentLoaded * 100) || 0;
			
			TweenLite.to(MC_Bar, .1, {scaleX: event.perc});
			//MC_Bar.scaleX = event.perc;
			//TXT_Bytes.text = (event.bytes) ? event.loaded + " / " + event.total : "";
			//TXT_Bytes.autoSize = TextFieldAutoSize.LEFT;
			
			TXT_Overall.text = assetPerc + "%";
		}
		
		private function onResize(event:Event = null):void
		{
			x = (stage.stageWidth - width) / 2;
			y = (stage.stageHeight - height) / 2;
		}
	}
}
