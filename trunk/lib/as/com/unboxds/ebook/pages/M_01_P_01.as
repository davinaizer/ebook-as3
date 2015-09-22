package com.unboxds.ebook.pages
{
	import com.gaiaframework.api.*;
	import com.gaiaframework.debug.*;
	import com.gaiaframework.events.*;
	import com.greensock.TweenMax;
	import com.unboxds.ebook.Ebook;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.TextFieldUtils;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	
	/**
	 * Assessment Intro
	 */
	public class M_01_P_01 extends EbookPage
	{
		private var testID:int;
		private var assessmentXML:XML;
		
		public function M_01_P_01()
		{
			super();
		}
		
		override public function transitionIn():void
		{
			super.transitionIn();
			TweenMax.to(this, 0.3, {alpha: 1, onComplete: transitionInComplete});
			
			initInteraction();
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
			TweenMax.to(this, 0.3, {alpha: 0, onComplete: transitionOutComplete});
		}
		
		override public function transitionInComplete():void
		{
			super.transitionInComplete();
			Gaia.api.getPage(Pages.NAV).content.enableNextButton();
		}
		
		private function initInteraction():void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var introTitle:TextField = TextField(this.getChildByName("titleTxt"));
			TextFieldUtils.initTextField(introTitle, stylesheet);
			
			var introBody:TextField = TextField(this.getChildByName("bodyTxt"));
			TextFieldUtils.initTextField(introBody, stylesheet);
			
			assessmentXML = assets.assessmentXML.xml;
			var maxTries:int = parseInt(assessmentXML.config.@maxTries);
			var triesLeft:int = maxTries - Ebook.getInstance().getStatus().quizTries;
			Logger.log( "0:maxTries : " + assessmentXML.config.@maxTries );
			Logger.log( "0:Ebook.getInstance().getStatus().quizTries : " + Ebook.getInstance().getStatus().quizTries );
			Logger.log( "0:QuizIntro ->> triesLeft : " + triesLeft );
			
			
			if (Ebook.getInstance().getStatus().quizStatus == EbookModel.STATUS_COMPLETED)
			{
				Logger.log("2:QUIZ INTRO -> QUIZ STATUS COMPLETED!");
				//Show completed text
				introTitle.htmlText = assessmentXML.intro.state.(@type == "completed").title;
				introBody.htmlText = assessmentXML.intro.state.(@type == "completed").body;
				       
				//onBeforeNextPage set to Conclusion
				Ebook.getInstance().getNav().onBeforeNextPage = gotoCover;
			} else {
				Logger.log("2:QUIZ INTRO -> QUIZ STATUS INCOMPLETE!");
				//Show not completed text
				if (triesLeft > 0)
				{
					introTitle.htmlText = assessmentXML.intro.state.(@type == "not_completed").title;
					introBody.htmlText = assessmentXML.intro.state.(@type == "not_completed").body;
				} else {
					//Show completed text
					introTitle.htmlText = assessmentXML.intro.state.(@type == "completed").title;
					introBody.htmlText = assessmentXML.intro.state.(@type == "completed").body;
					
					//onBeforeNextPage set to Conclusion
					Ebook.getInstance().getNav().onBeforeNextPage = gotoCover;
				}
			}
			
			//TweenMax.allFrom([introTitle, introBody], 0.5, { autoAlpha:1 } );
		}
		
		private function gotoCover():void
		{
			Logger.log("4:Navigating to : " + assessmentXML.config.@conclusionPage);
			Ebook.getInstance().getNav().navigateTo(assessmentXML.config.@conclusionPage);
		}
	}
}
