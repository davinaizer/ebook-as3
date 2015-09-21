package com.unboxds.ebook.pages
{
	import com.gaiaframework.api.*;
	import com.gaiaframework.debug.*;
	import com.gaiaframework.events.*;
	import com.greensock.TweenMax;
	import com.unboxds.components.assessment.Assessment;
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * Assessment Component
	 */
	public class M_01_P_02 extends EbookPage
	{
		private var testID:int;
		
		public function M_01_P_02()
		{
			super();
			//isOpen = false;
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
			//Gaia.api.getPage(Pages.NAV).content.enableNextButton();
		}
		
		private function initInteraction():void
		{
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var assessment:Assessment = new Assessment(this, XMLList(assets.assessmentXML.xml), stylesheet);
			assessment.onComplete.add(onComplete);
			assessment.init();
			//assessment.onChengeExercise.add(onQuestionChange);
		}
		
		//private function onQuestionChange(question:int):void
		//{
		//var txtField:TextField = TextField(getChildByName("text_1"));
		//
		//if (question != 10)
		//{
		//txtField.htmlText = "<p class=\"quizIndex\">0" + question + "</p>";
		//} else 
		//{
		//txtField.htmlText = "<p class=\"quizIndex\">" + question + "</p>";
		//}
		//
		//TweenMax.from(txtField, 0.3, { alpha: 0 } );
		//}
		
		private function onComplete():void
		{
			//TODO: Save score
			Gaia.api.getPage(Pages.NAV).content.enableNextButton();
		}
	
	}
}