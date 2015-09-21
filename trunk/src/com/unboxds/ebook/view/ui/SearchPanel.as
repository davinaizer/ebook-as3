package com.unboxds.ebook.view.ui
{
	import assets.SearchPanelSymbol;
	import assets.TickerSymbol;
	import assets.buttons.btSearchResult;

	import com.chewtinfoil.utils.StringUtils;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TweenEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.ebook.Ebook;
	import com.unboxds.ebook.model.events.SearchEvent;
	import com.unboxds.ebook.model.vo.PageData;
	import com.unboxds.ebook.view.components.List;
	import com.unboxds.ebook.view.components.ListBuilder;
	import com.unboxds.ebook.view.components.StepperBar;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.TweenParser;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;

	import net.tw.util.StringUtil;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class SearchPanel extends UIPanel
	{
		public var summary:String;
		public var pageTitle:String;
		public var pageModuleIndex:int;
		public var pageLocalIndex:int;
		public var firstItem:uint;
		public var lastItem:uint;
		public var totalItems:uint;

		private var view:SearchPanelSymbol;
		private var openTween:TweenMax;
		private var btnNext:SimpleButton;
		private var btnBack:SimpleButton;
		private var list:List;
		private var scrollBar:StepperBar;
		private var statusTxt:TextField;
		private var panelBg:Sprite;
		private var iniTimer:int;
		private var pages:Vector.<PageData>;
		private var contentBuffer:Vector.<String>;
		private var pageCount:int;
		private var summaryLength:int;
		private var statusStr:String;
		private var itemLabel:String;
		private var statusNotFoundStr:String;

		public function SearchPanel(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			super(contentXML, stylesheet);

			Logger.log("SearchPanel.SearchPanel");

			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		public function init():void
		{
			Logger.log("SearchPanel.init");

			alpha = 1;
			visible = true;

			view = new SearchPanelSymbol();
			view.cacheAsBitmap = true;
			view.baseBox_Placeholder.alpha = 0;
			view.x = parseFloat(contentXML.@x);
			view.y = parseFloat(contentXML.@y);
			view.alpha = 0;
			view.visible = false;
			addChild(view);

			target = view;

			statusTxt = view.statusTxt;
			btnNext = view.btnNext as SimpleButton;
			btnBack = view.btnBack as SimpleButton;
			panelBg = view.panelBg;

			//-- Default text placeholders
			statusStr = contentXML.content.(@type == "text").content.(@instanceName == "statusTxt").title.toString();
			itemLabel = contentXML.content.(@type == "text").content.(@instanceName == "itemLabel").title.toString();
			statusNotFoundStr = contentXML.content.(@type == "text").content.(@instanceName == "statusNotFound").title.toString();

			var listData:XMLList = contentXML.object.(@type == "List");
			list = new ListBuilder().fromXML(listData[0]).build();
			list.buttonClass = btSearchResult;
			list.buttonPrefix = "btSearchResult";
			list.stylesheet = stylesheet;
			list.onChange.add(onListChange);

			var scrollbarData:XMLList = contentXML.object.(@type == "Scrollbar");
			scrollBar = new StepperBar();
			scrollBar.x = parseFloat(scrollbarData[0].@x);
			scrollBar.y = parseFloat(scrollbarData[0].@y);
			scrollBar.barWidth = parseInt(scrollbarData[0].@width);
			scrollBar.barHeight = parseInt(scrollbarData[0].@height);
			scrollBar.barColor = parseInt(scrollbarData[0].@scrollbarColor);
			scrollBar.barColorAlpha = parseFloat(scrollbarData[0].@scrollbarColorAlpha);
			scrollBar.thumbColor = parseInt(scrollbarData[0].@thumbColor);
			scrollBar.thumbColorAlpha = parseFloat(scrollbarData[0].@thumbColorAlpha);
			scrollBar.autoHideThumb = (scrollbarData[0].@autoHideThumb == "true");

			view.addChild(list);
			view.addChild(scrollBar);

			iniTimer = getTimer();
			summaryLength = parseInt(contentXML.@summaryLength);
			contentBuffer = new Vector.<String>();
			pages = Ebook.getInstance().getNav().getPages();
			pageCount = pages.length;

			//-- get Open Tweeen
			var tweenData:XMLList = contentXML.tween.tween.(@id == "openTween");
			openTween = TweenParser.getTweenFromXML(view, tweenData[0]);
			openTween.addEventListener(TweenEvent.COMPLETE, onCompleteShow);
			openTween.addEventListener(TweenEvent.REVERSE_COMPLETE, onCompleteHide);

			//-- load XML and INDEX XML files
			var queue:LoaderMax = new LoaderMax({
				name: "mainQueue",
				onComplete: completeHandler,
				onError: errorHandler
			});
			for (var i:int = 0; i < pageCount; ++i)
			{
				if (pages[i].contentURL != null && pages[i].contentURL != "")
					queue.append(new XMLLoader(pages[i].contentURL, {name: "contentXML_" + i, maxConnections: 3}));
			}
			queue.load();
		}

		public function search(keyword:String):void
		{
			Logger.log("SearchPanel.search > keyword : " + keyword);

			if (keyword != "" && keyword != null)
			{
				list.destroy();
				iniTimer = getTimer();

				var hasFound:Boolean = false;
				for (var i:int = 0; i < pageCount; ++i)
				{
					var str:String = StringUtil.cleanSpecialChars(contentBuffer[i].toLowerCase());
					var foundStr:int = str.search(keyword);
					if (foundStr > -1)
					{
						hasFound = true;
						summary = parseSummary(contentBuffer[i], keyword);
						insert(pages[i]);
					}
				}

				Logger.log("SearchPanel.search > TIME TO SEARCH A WORD: " + (getTimer() - iniTimer) + "ms");

				list.update();
			}

			invalidate();
			dispatchEvent(new SearchEvent(SearchEvent.SEARCH_COMPLETE));
		}

		public function insert(page:PageData):void
		{
			pageTitle = page.title;
			pageModuleIndex = page.moduleIndex + 1;
			pageLocalIndex = page.localIndex + 1;
			totalItems = list.totalItems + 1;

			list.insert(page.index, com.unboxds.utils.StringUtils.parseTextVars(itemLabel, this));
			list.update(page.index);
		}

		private function initEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			view.addEventListener(MouseEvent.CLICK, navHandler, false, 0, true);
		}

		private function onListChange(listP:List):void
		{
			var isNextEnabled:Boolean = listP.totalItems > 0 && !(listP.currentPage == listP.totalPages - 1);
			var isBackEnabled:Boolean = listP.totalItems > 0 && listP.currentPage != 0;

			btnNext.setEnabled(isNextEnabled);
			btnBack.setEnabled(isBackEnabled);

			if (scrollBar)
			{
				scrollBar.steps = listP.totalPages;
				scrollBar.current = listP.currentPage + 1;
			}

			//-- RESULT REPORT
			if (list.totalItems > 0)
			{
				firstItem = list.maxItensPerPage * list.currentPage + 1;
				lastItem = (list.maxItensPerPage * (list.currentPage + 1));
				lastItem = lastItem > list.totalItems ? list.totalItems : lastItem;
				totalItems = list.totalItems;

				statusTxt.htmlText = com.unboxds.utils.StringUtils.parseTextVars(statusStr, this);
			}
			else
			{
				statusTxt.text = com.unboxds.utils.StringUtils.parseTextVars(statusNotFoundStr, this);
			}
		}

		private function invalidate():void
		{
			//TODO Remove EbookFramework dependecy
			if (Ebook.getInstance().getDataController().isConsultMode == false)
			{
				var maxPageIndex:int = Ebook.getInstance().getNav().getUserLastPage().index;
				for (var i:int = 0; i < list.totalItems; i++)
				{
					var btn:SimpleButton = list.getButtonByIndex(i);
					btn.setEnabled(true);

					if (list.listButtonsKeys[i] > maxPageIndex)
					{
						btn.setEnabled(false);
					}
					else
					{
						var ticker:Sprite = new TickerSymbol();
						btn.addChild(ticker);
					}
				}
			}
		}

		private function parseSummary(value:String, keyword:String):String
		{
			var kArr:Array = value.split("]]>");
			var kArrLen:int = kArr.length;
			var tmpStr:String = "";

			for (var i:int = 0; i < kArrLen; ++i)
			{
				var str:String = StringUtil.cleanSpecialChars(kArr[i].toLowerCase());
				var foundStr:int = str.search(keyword);
				if (foundStr > -1)
				{
					var fstInd:int = 0;
					var lstInd:int = 0;
					var strLen:int = summaryLength;

					strLen -= keyword.length;
					lstInd = Math.min(foundStr + int(strLen * .5), str.length);

					strLen -= lstInd - foundStr;
					fstInd = foundStr - strLen;

					//-- find word begining
					while (fstInd >= 0)
					{
						if (str.charAt(fstInd) == " " || str.charAt(fstInd) == ".")
						{
							fstInd++;
							break;
						}
						fstInd--;
					}

					while (lstInd <= str.length)
					{
						if (str.charAt(lstInd) == " " || str.charAt(lstInd) == ".")
							break;
						lstInd++;
					}

					if (fstInd < 0)
						fstInd = 0;

					tmpStr = kArr[i].substring(fstInd, lstInd);

					if (fstInd > 0)
						tmpStr = "..." + tmpStr;

					if (lstInd < str.length)
						tmpStr += "...";

					break;
				}
			}

			return tmpStr;
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			init();
			initEvents();
			parseContent();
		}

		private function onMouseWheel(e:MouseEvent):void
		{
			e.delta > 0 ? list.backPage() : list.nextPage();
		}

		private function navHandler(e:MouseEvent):void
		{
			var src:DisplayObject = e.target as DisplayObject;
			if (src == btnNext)
			{
				list.nextPage();
			}
			else if (src == btnBack)
			{
				list.backPage();
			}
		}

		private function completeHandler(event:LoaderEvent):void
		{
			Logger.log("SearchPanel.completeHandler!");

			for (var i:int = 0; i < pages.length; ++i)
			{
				var xml:XML = LoaderMax.getContent("contentXML_" + i);
				if (xml != null)
				{
					//-- remove non-content nodes
					delete xml..tween.*;
					delete xml..vars.*;
					delete xml..action.*;
					delete xml..config.*;

					var str:String = xml.toString();
					str = StringUtils.stripTags(str);
					str = StringUtils.removeExtraWhitespace(str);

					contentBuffer.push(str);
				}
			}

			Logger.log("SearchPanel >> TIME TO LOAD AND PROCESS " + pages.length + " FILES: " + (getTimer() - iniTimer) + "ms");

			dispatchEvent(new SearchEvent(SearchEvent.INDEX_COMPLETE));
		}

		private function errorHandler(event:LoaderEvent):void
		{
			Logger.log("error occured with " + event.target + ": " + event.text);
		}

		public override function show():void
		{
			Logger.log("SearchPanel.show");

			invalidate();
			openTween.play();
		}

		public override function hide():void
		{
			Logger.log("SearchPanel.hide");

			openTween.reverse();
		}
	}

}