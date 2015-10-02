package com.unboxds.ebook.pages
{
	import assets.sounds.ClickSound;

	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.api.IStyleSheet;
	import com.gaiaframework.api.IXml;
	import com.gaiaframework.events.GaiaEvent;
	import com.gaiaframework.templates.AbstractPage;
	import com.unboxds.ebook.controller.UIController;
	import com.unboxds.ebook.view.utils.PageAnimator;

	import flash.text.StyleSheet;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class NavPage extends AbstractPage
	{
		private var contentXML:XML;
		private var stylesheet:StyleSheet;
		private var navPanel:UIController;
		private var clickSound:ClickSound;

		//TODO This class should be a Context Class to link View, Controller and Model
		public function NavPage()
		{
			super();
			alpha = 0;
		}

		override public function transitionIn():void
		{
			init();

			super.transitionIn();
			PageAnimator.fadeIn(this, .3, 0, transitionInComplete);
		}

		override public function transitionOut():void
		{
			super.transitionOut();
			PageAnimator.fadeOut(this, .3, 0, transitionOutComplete);
		}

		public function init():void
		{
			if (Gaia.api.getPage("index").assets.styles)
				stylesheet = IStyleSheet(Gaia.api.getPage("index").assets.styles).style;
			if (assets)
				contentXML = IXml(assets.contentXML).xml;

			navPanel = new UIController(contentXML, stylesheet);
			addChild(navPanel);

			clickSound = new ClickSound();

			Gaia.api.beforeGoto(beforeGoto, false, false);
			Gaia.api.afterGoto(afterGoto, false, true);
		}

		private function beforeGoto(e:GaiaEvent):void
		{
			clickSound.play();
		}

		private function afterGoto(e:GaiaEvent):void
		{
			navPanel.show();
		}

		//TODO EXTERNAL METHODS used by other Classes - REFACTOR
		public function enableNextButton(value:Boolean = true):void
		{
			navPanel.enableNextButton(value);
		}

		public function setNavStatus(value:String):void
		{
			navPanel.setNavStatus(value);
		}
	}
}