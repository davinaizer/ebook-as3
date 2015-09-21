package com.unboxds.ebook.view.ui
{
	import com.adobe.utils.ArrayUtil;
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.events.GaiaEvent;
	import com.greensock.TweenMax;
	import com.unboxds.button.ToggleButton;
	import com.unboxds.ebook.Ebook;
	import com.unboxds.ebook.model.events.NavEvent;
	import com.unboxds.ebook.model.events.SearchEvent;
	import com.unboxds.ebook.model.vo.PageData;
	import com.unboxds.ebook.view.components.*;
	import com.unboxds.utils.ArrayUtils;
	import com.unboxds.utils.KeyObject;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.TweenParser;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 */
	public class UIController extends ContentObject
	{
		private var navBar:NavBar;
		private var dashboard:Dashboard;
		private var progressMeter:AbstractProgressMeter;
		private var helpPanel:HelpPanel;

		private var searchPanel:SearchPanel;
		private var currentPanel:UIPanel;

		private var currentBtn:ToggleButton;
		private var currentPage:PageData;

		private var isNavigationAvailable:Boolean;
		private var keyObj:KeyObject;
		private var contentTween:TweenMax;

		// for import only
		BarMeter;

		public function UIController(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			super(contentXML, stylesheet);

			Logger.log("UIController.UIController > contentXML: " + (contentXML != null) + ", stylesheet: " + (stylesheet != null));

			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}

		public function init():void
		{
			Logger.log("UIController.init");

			isNavigationAvailable = false;

			setupStage();
			initEvents();
			parseContent();

			Gaia.api.beforeGoto(onBeforeGoto, false, true);
		}

		private function setupStage():void
		{
			Logger.log("UIController.setupStage");

			//-- DASHBOARD
			dashboard = new Dashboard();
			dashboard.stylesheet = stylesheet;
			dashboard.contentXML = XML(XMLList(contentXML.object.(@type == "Dashboard")).toXMLString());

			//-- NAVBAR
			navBar = new NavBar();
			navBar.stylesheet = stylesheet;
			navBar.contentXML = XML(XMLList(contentXML.object.(@type == "NavBar")).toXMLString());

			//-- PROGRESS METER
			var pmData:XML = XML(XMLList(contentXML.object.(@type == "ProgressMeter")).toXMLString());
			var PmClass:Class = getDefinitionByName(pmData.@className) as Class;
			progressMeter = new PmClass() as AbstractProgressMeter;
			progressMeter.contentXML = pmData;
			progressMeter.stylesheet = stylesheet;
			progressMeter.setMax(Ebook.getInstance().getNav().totalPages);

			//-- HELP PANEL
			helpPanel = new HelpPanel();
			helpPanel.stylesheet = stylesheet;
			helpPanel.contentXML = XML(XMLList(contentXML.object.(@type == "HelpPanel")).toXMLString());

			//-- SEARCH PANEL
			searchPanel = new SearchPanel();
			searchPanel.contentXML = XML(XMLList(contentXML.object.(@type == "SearchPanel")).toXMLString());
			searchPanel.stylesheet = stylesheet;

			addChild(dashboard);
			addChild(navBar);
			addChild(progressMeter);
			addChild(helpPanel);
			addChild(searchPanel);

			// -- check for depth management
			if ("@depth" in searchPanel.contentXML)
				setChildIndex(searchPanel, parseInt(searchPanel.contentXML.@depth));
			if ("@depth" in helpPanel.contentXML)
				setChildIndex(helpPanel, parseInt(helpPanel.contentXML.@depth));
			if ("@depth" in dashboard.contentXML)
				setChildIndex(dashboard, parseInt(dashboard.contentXML.@depth));
			if ("@depth" in navBar.contentXML)
				setChildIndex(navBar, parseInt(navBar.contentXML.@depth));
			if ("@depth" in progressMeter.contentXML)
				setChildIndex(progressMeter as DisplayObject, parseInt(progressMeter.contentXML.@depth));
		}

		private function initEvents():void
		{
			navBar.addEventListener(MouseEvent.CLICK, navbarHandler);
			navBar.addEventListener(SearchEvent.SEARCH, searchHandler);
			navBar.addEventListener(SearchEvent.SEARCH_END, searchHandler);
			navBar.addEventListener(SearchEvent.SEARCH_COMPLETE, searchHandler);

			dashboard.addEventListener(MouseEvent.CLICK, dashboardClickHandler);
			dashboard.addEventListener(NavEvent.GOTO_PAGE, onGotoPage);

			searchPanel.addEventListener(SearchEvent.INDEX_COMPLETE, searchHandler);
			searchPanel.addEventListener(SearchEvent.SEARCH_COMPLETE, searchHandler);
			searchPanel.addEventListener(MouseEvent.CLICK, searchHandler);

			//check for clicks outside UI
			stage.addEventListener(MouseEvent.CLICK, stageHandler);

			if (Ebook.getInstance().getDataController().enableDebugPanel == true)
			{
				keyObj = new KeyObject(this.stage);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}

			if (navBar.isKeyboardAvailable)
				stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		private function stageHandler(e:MouseEvent):void
		{
			if (e.type == MouseEvent.CLICK)
			{
				if (currentPanel && !this.contains(e.target as DisplayObject))
					closePanels();
			}
		}

		// ************  HANDLERS *****************
		private function keyDownHandler(e:KeyboardEvent):void
		{
			// check keys combination to Debug Panel
			if (keyObj.isDown(Keyboard.CONTROL) && keyObj.isDown(Keyboard.SHIFT) && keyObj.isDown(Keyboard.NUMBER_1))
			{
				if (Ebook.getInstance().getDebugPanel().view.visible)
					Ebook.getInstance().getDebugPanel().hide();
				else
					Ebook.getInstance().getDebugPanel().show();
			}

			if (keyObj.isDown(Keyboard.ESCAPE))
				closePanels();
		}

		private function keyUpHandler(e:KeyboardEvent):void
		{
			if (isNavigationAvailable)
			{
				switch (e.keyCode)
				{
					case Keyboard.RIGHT:
					case Keyboard.SPACE:
						if (navBar.getNextButtonStatus())
						{
							isNavigationAvailable = false;
							Ebook.getInstance().getNav().nextPage();
						}
						break;

					case Keyboard.LEFT:
						if (navBar.getBackButtonStatus())
						{
							isNavigationAvailable = false;
							Ebook.getInstance().getNav().backPage();
						}
						break;
				}
			}
		}

		private function dashboardClickHandler(e:MouseEvent):void
		{
			if (e.target is DisplayObjectContainer)
			{
				var srcName:String = e.target.name;
				var prefix:String = srcName.split("_")[0];
				var index:int = parseInt(srcName.split("_")[1]);

				switch (prefix)
				{
					case "btBookmarkItem":
					case "btSearchResult":
						gotoPage(index);
						break;
				}
			}
		}

		//TODO Refactor Switch-> change the way panels are managed (open and close)
		private function navbarHandler(e:MouseEvent):void
		{
			var sourceName:String = e.target.name;
			switch (sourceName)
			{
				case "nextBtn":
					Ebook.getInstance().getNav().nextPage();
					break;

				case "backBtn":
					Ebook.getInstance().getNav().backPage();
					break;

				case "bookmarkRemoveBtn":
				case "bookmarkAddBtn":
					bookmarkPage();
					break;

				case "dashboardBtn":
					togglePanel(dashboard as UIPanel, e.target as ToggleButton);
					break;

				case "helpBtn":
					togglePanel(helpPanel as UIPanel, e.target as ToggleButton);
					break;

				default:
					break;
			}

			e.stopPropagation();
		}

		private function searchHandler(e:Event):void
		{
			Logger.log("UIController.searchHandler > e.type: " + e.type);

			switch (e.type)
			{
				case SearchEvent.INDEX_COMPLETE:
					navBar.searchBox.enable(true);
					break;

				case SearchEvent.SEARCH:
					searchPanel.search(SearchEvent(e).data);
					break;

				case SearchEvent.SEARCH_END:
					closePanels();
					break;

				case SearchEvent.SEARCH_COMPLETE:
					togglePanel(searchPanel as UIPanel, null);
					break;

				case MouseEvent.CLICK:
					var srcName:String = e.target.name;
					var prefix:String = srcName.split("_")[0];
					var index:int = parseInt(srcName.split("_")[1]);
					if (prefix == "btSearchResult")
						gotoPage(index);
					break;

				default:
			}
		}

		private function togglePanel(panel:UIPanel, toggleBtn:ToggleButton):void
		{
			Logger.log("UIController.togglePanel > panel: " + panel);

			if (currentPanel == null)
			{
				panel.open();
				if (toggleBtn)
					toggleBtn.toggle();

				currentPanel = panel;
				currentBtn = toggleBtn;

				contentTween.play();
			}
			else
			{
				if (panel != currentPanel)
				{
					//close last opened panel
					currentPanel.close();
					if (currentBtn && currentBtn.isToggled)
						currentBtn.toggle();

					// open the new panel	
					panel.open();
					if (toggleBtn)
						toggleBtn.toggle();

					currentPanel = panel;
					currentBtn = toggleBtn;

					contentTween.play();
				}
				else
				{
					if (panel != searchPanel)
						closePanels();
				}
			}
		}

		private function closePanels():void
		{
			Logger.log("UIController.closePanels > currentPanel : " + currentPanel);

			if (currentPanel && currentPanel.isOpen)
				currentPanel.close();

			if (currentBtn && currentBtn.isToggled)
				currentBtn.toggle();

			if (navBar.searchBox.isOpen)
				navBar.searchBox.close();

			currentPanel = null;
			currentBtn = null;

			if (contentTween)
				contentTween.reverse();
		}

		private function bookmarkPage():void
		{
			Logger.log("UIController.bookmarkPage");

			// -- SORT ARRAY
			var pageFound:int = ArrayUtils.binarySearch(Ebook.getInstance().getStatus().lessonStatus.bookmarks, currentPage.index);
			if (pageFound > -1)
			{
				dashboard.removeBookmark(currentPage);
				navBar.bookmarkPage(false);

				ArrayUtil.removeValueFromArray(Ebook.getInstance().getStatus().lessonStatus.bookmarks, currentPage.index);
			}
			else
			{
				dashboard.addBookmark(currentPage);
				navBar.bookmarkPage(true);

				Ebook.getInstance().getStatus().lessonStatus.bookmarks.push(currentPage.index);
				Ebook.getInstance().getStatus().lessonStatus.bookmarks.sort(Array.NUMERIC);
			}
		}

		private function checkBookmark():void
		{
			var pageUID:int = currentPage.index;
			var pageFound:int = ArrayUtils.binarySearch(Ebook.getInstance().getStatus().lessonStatus.bookmarks, pageUID);
			if (pageFound > -1)
				navBar.bookmarkPage(true);
			else
				navBar.bookmarkPage(false);
		}

		private function onGotoPage(e:NavEvent):void
		{
			var index:int = Ebook.getInstance().getNav().getPageByName(e.pageID).index;
			gotoPage(index);
		}

		private function gotoPage(index:uint):void
		{
			if (currentPage.index != index)
			{
				Ebook.getInstance().getNav().navigateToPageIndex(index);
			}
			else
			{
				closePanels();
			}
		}

		private function onBeforeGoto(e:GaiaEvent):void
		{
			currentPage = Ebook.getInstance().getNav().getCurrentPage();

			closePanels();

			progressMeter.enable(false);

			navBar.enableNextButton(false);
			navBar.block("11111");

			Gaia.api.beforeTransitionIn(onBeforeTransitionIn, false, true);
			Gaia.api.afterTransitionIn(onAfterTransitionIn, false, true);
		}

		private function onBeforeTransitionIn(e:GaiaEvent):void
		{
			checkBookmark();

			contentTween = TweenParser.getTweenFromXML(Gaia.api.getPage(Gaia.api.getCurrentBranch()).content, contentXML.tween.tween.(@id == "contentTween")[0]);

			progressMeter.setProgress(currentPage.index + 1);
			progressMeter.setSecondaryProgress(Ebook.getInstance().getNav().getUserLastPage().index);
		}

		private function onAfterTransitionIn(e:GaiaEvent):void
		{
			navBar.block("00000");

			progressMeter.enable(true);
			currentPage.showProgress ? progressMeter.show() : progressMeter.hide();

			if (currentPage.navbarStatus != null)
			{
				navBar.status(currentPage.navbarStatus);
			}
			else
			{
				navBar.status("11111");

				var lastUserPage:PageData = Ebook.getInstance().getNav().getUserLastPage();
				if (Ebook.getInstance().getDataController().isConsultMode || lastUserPage.index > currentPage.index)
					navBar.enableNextButton(true);
			}

			stage.focus = stage;
			isNavigationAvailable = true;

			Gaia.api.beforeGoto(onBeforeGoto, false, true);
		}

		// -- PUBLIC EXTERNAL FUNCTIONS
		// TODO REFACTOR THESE FUNTCIONS. MAYBE SHOULD BE PLACED SOMEWHERE
		public function enableNextButton(value:Boolean = true):void
		{
			navBar.enableNextButton(value);
		}

		public function setNavStatus(value:String):void
		{
			navBar.status(value);
		}
	}
}