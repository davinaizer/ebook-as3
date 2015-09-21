package com.unboxds.ebook.pages
{
	import com.gaiaframework.api.*;
	import com.gaiaframework.debug.*;
	import com.gaiaframework.events.*;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import com.unboxds.ebook.Ebook;
	import com.unboxds.ebook.model.Status;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.StringUtils;
	import com.unboxds.utils.TextFieldUtils;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	
	/**
	 * Assessment Result
	 * This page, as is can be copied and pasted in any
	 * eLearning. What have to be changed:
		 * Names obviously (page name, textfield instances in the fla, etc)
		 * XML values (also, the assessment xml must be embedded in the fla)
	 */
	public class M_01_P_03 extends EbookPage
	{
		private var testID:int;
		private var assessmentXML:XML;
		
		//Public vars for TextFieldUtils
		public var correctQuestions:int;
		public var userScore:int;
		public var minScore:int;	//Minimum score to be approved
		public var score:int = 0;
		public var triesLeft:int;
		public var userName:String;
		public var userId:String = Ebook.getInstance().getDataController().ebookData.student_id;
		
		public function M_01_P_03()
		{
			if (String(Ebook.getInstance().getDataController().ebookData.student_name).indexOf(",") > -1)
			{
				userName = StringUtils.trimWhitespace(String(Ebook.getInstance().getDataController().ebookData.student_name).split(",")[1]) + " " + String(Ebook.getInstance().getDataController().ebookData.student_name).split(",")[0];
			} else {
				userName = String(Ebook.getInstance().getDataController().ebookData.student_name)
			}
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
			var resultTitle:TextField = TextField(this.getChildByName("titleTxt"));
			TextFieldUtils.initTextField(resultTitle, stylesheet);
			
			var resultBody:TextField = TextField(this.getChildByName("bodyTxt"));
			TextFieldUtils.initTextField(resultBody, stylesheet);
			
			assessmentXML = assets.assessmentXML.xml;
			
			//Public vars for TextFieldUtils
			minScore = parseInt(assessmentXML.config.@minScore);
			var maxTries:int = parseInt(assessmentXML.config.@maxTries);
			triesLeft = maxTries - Ebook.getInstance().getStatus().quizTries;
			
			userScore = Ebook.getInstance().getStatus().quizScore;
			trace( "userScore : " + userScore );
			
			/*--  Changing the calculation of the correcQuestions  --*/
			//correctQuestions = userScore / parseInt(assessmentXML.config.@scorePerExercise);
			correctQuestions = userScore / int(100 / int(assessmentXML.config.@numberOfQuestions));
			trace( "correctQuestions : " + correctQuestions );
			
			if (Ebook.getInstance().getStatus().quizScore >= minScore)
			{
				//Approved
				resultTitle.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "approved").title, this);
				resultBody.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "approved").body, this);
				
				Ebook.getInstance().getStatus().quizStatus = Status.STATUS_COMPLETED;
				Ebook.getInstance().getDataController().ebookData.scoreRaw = Ebook.getInstance().getStatus().quizScore;
				Gaia.api.getPage("index/nav").content.setNavStatus("0110");
				Ebook.getInstance().getNav().onBeforeNextPage = null;
				Ebook.getInstance().getNav().onBeforeBackPage = gotoIntro;
				
				Logger.log("4:Result.show >> APPROVED");
				
			} 
			else 
			{
				//Micro-management of triesLeft is necessary for custom messages
				//TODO: Make this easier to set via XML
				if (triesLeft == 2) 
				{
					Logger.log("3:Two tries left.");
					resultTitle.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "try_again").title, this);
					resultBody.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "try_again").body, this);
					//Enable Menu
					Gaia.api.getPage("index/nav").content.setNavStatus("0100");
					
					Ebook.getInstance().getStatus().quizStatus = Status.STATUS_INITIALIZED;
					Ebook.getInstance().getNav().onBeforeNextPage = gotoIntro;
					Logger.log("2:Result.show >> TRY_AGAIN");
				} 
				else if (triesLeft == 1) 
				{
					Logger.log("3:Only one try left!");
					var lastChance:String = assessmentXML.result.feedback.(@type == "last_chance").title;
					trace( "lastChance : " + lastChance );
					if (lastChance.length > 0) 
					{
						resultTitle.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "last_chance").title, this);
						resultBody.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "last_chance").body, this);
						//Enable Menu
						Gaia.api.getPage("index/nav").content.setNavStatus("0100");
						
						Ebook.getInstance().getStatus().quizStatus = Status.STATUS_INITIALIZED;
						Ebook.getInstance().getNav().onBeforeNextPage = gotoIntro;
						Logger.log("2:Result.show >> TRY_AGAIN");
					}
					else 
					{
						resultTitle.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "try_again").title, this);
						resultBody.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "try_again").body, this);
						//Enable Menu
						Gaia.api.getPage("index/nav").content.setNavStatus("0100");
						
						Ebook.getInstance().getStatus().quizStatus = Status.STATUS_INITIALIZED;
						Ebook.getInstance().getNav().onBeforeNextPage = gotoIntro;
						
						Logger.log("2:Result.show >> TRY_AGAIN");
					}
				}
				else 
				{
					resultTitle.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "not_approved").title, this);
					resultBody.htmlText = StringUtils.parseTextVars(assessmentXML.result.feedback.(@type == "not_approved").body, this);
					
					Ebook.getInstance().getStatus().quizStatus = Status.STATUS_COMPLETED;
					Ebook.getInstance().getDataController().ebookData.scoreRaw = Ebook.getInstance().getStatus().quizScore;
					Gaia.api.getPage("index/nav").content.setNavStatus("0110");
					Ebook.getInstance().getNav().onBeforeNextPage = null;
					Ebook.getInstance().getNav().onBeforeBackPage = gotoIntro;
					
					Logger.log("3:Result.show >> NOT_APPROVED");
				}
				
				Ebook.getInstance().getDataController().save();
				//Gaia.api.getPage("index/nav").content.enableNextButton();
				
				Logger.log("ASSESSMENT RESUME:");
				Logger.log(">>> ASSESSMENT STATUS : " + Ebook.getInstance().getStatus().quizStatus);
				Logger.log(">>> ASSESSMENT SCORE : " + Ebook.getInstance().getStatus().quizScore);
				Logger.log(">>> ASSESSMENT TRIES : " + Ebook.getInstance().getStatus().quizTries);
				
				
			}
			
			
			TweenMax.to(this, 1.5, { score:userScore, onUpdate:showScore, ease:Sine.easeOut, delay:0.8 } );
		}
		
		private function gotoIntro():void
		{
			Ebook.getInstance().getNav().navigateTo(assessmentXML.config.@introPage);
		}
		
		private function showScore() {
			
			TextField(Sprite(getChildByName("scoreMc")).getChildByName("text_1")).htmlText = "<p class=\"scoreText\"><span class=\"center\">" + int(score) + "</span></p>"; 
			
		}
	}
}
