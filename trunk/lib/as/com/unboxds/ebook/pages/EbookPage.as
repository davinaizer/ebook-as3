package com.unboxds.ebook.pages
{
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.api.IStyleSheet;
	import com.gaiaframework.api.IXml;
	import com.gaiaframework.templates.AbstractPage;
	import com.unboxds.ebook.Ebook;
	import com.unboxds.ebook.view.parser.ContentParser;
	import com.unboxds.ebook.model.vo.PageData;
	import com.unboxds.ebook.view.utils.PageAnimator;
	import com.unboxds.utils.TweenParser;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	
	//Refactor class. To big, to many imports
	public class EbookPage extends AbstractPage
	{
		private var _contentXML:XML;
		private var _stylesheet:StyleSheet;
		private var _data:PageData;
		
		public function EbookPage()
		{
			super();
			alpha = 0;
			this.scrollRect = new Rectangle(0, 0, 1000, 600);
		}
		
		override public function transitionIn():void
		{
			init();
			
			_data = Ebook.getInstance().getNav().getCurrentPage();
			
			super.transitionIn();
			try
			{
				PageAnimator[_data.pageTransitionIn](this, .5, Ebook.getInstance().getNav().navDirection, transitionInComplete);
			}
			catch (err:Error)
			{
				PageAnimator.fadeIn(this, .5, Ebook.getInstance().getNav().navDirection, transitionInComplete);
			}
			
			if (_data.contentTransitionIn != "none")
				PageAnimator.contentFadeIn(this, .5, .5);
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
			try
			{
				PageAnimator[_data.pageTransitionOut](this, .5, Ebook.getInstance().getNav().navDirection, transitionOutComplete);
			}
			catch (err:Error)
			{
				PageAnimator.fadeOut(this, .5, Ebook.getInstance().getNav().navDirection, transitionOutComplete);
			}
		}
		
		public function init():void
		{
			stylesheet = IStyleSheet(Gaia.api.getPage("index").assets.styles).style;
			if (assets)
				contentXML = IXml(assets.contentXML).xml;
			
			parseContent();
		}
		
		public function parseContent():void
		{
			new ContentParser(this, contentXML, stylesheet).parse();
			
			var tweenXML:XML = XML(XMLList(_contentXML.tween).toXMLString());
			if (tweenXML.hasComplexContent())
				new TweenParser(this, tweenXML).parse();
		}
		
		/***** GETTERS & SETTERS ****/
		public function get contentXML():XML
		{
			return _contentXML;
		}
		
		public function set contentXML(value:XML):void
		{
			_contentXML = value;
		}
		
		public function get stylesheet():StyleSheet
		{
			return _stylesheet;
		}
		
		public function set stylesheet(value:StyleSheet):void
		{
			_stylesheet = value;
		}
		
		public function get data():PageData
		{
			return _data;
		}
		
		public function set data(value:PageData):void
		{
			_data = value;
		}
	
	}
}
