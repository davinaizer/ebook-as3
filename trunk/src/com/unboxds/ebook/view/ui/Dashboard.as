package com.unboxds.ebook.view.ui
{
	import assets.DashboardSymbol;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.events.TweenEvent;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.ebook.model.vo.PageData;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.TweenParser;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;

	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class Dashboard extends UIPanel
	{
		private var view:DashboardSymbol;
		
		//-- STAGE OBJS
		public var indexBtn:SimpleButton;
		public var bookmarksBtn:SimpleButton;
		public var aboutBtn:SimpleButton;
		
		private var selectedPanelIndex:int;
		
		private var closedPos:Point;
		private var openedPos:Point;
		
		//-- vars
		private var uiObjects:Vector.<DisplayObject>;
		private var panels:Vector.<ContentObject>;
		private var simpleButtons:Vector.<SimpleButton>;

		private var indexPanel:IndexPanel;
		private var bookmarkPanel:BookmarkPanel;
		private var aboutPanel:AboutPanel;
		private var openTween:TweenMax;
		
		public function Dashboard(contentXML:XML = null, stylesheet:StyleSheet = null)
		{
			Logger.log("Dashboard.Dashboard");
			
			super(contentXML, stylesheet);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			Logger.log("Dashboard.onAdded");
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			init();
			initEvents();
		}
		
		private function init():void
		{
			Logger.log("Dashboard.init");
			
			alpha = 1;
			visible = true;
			
			closedPos = new Point(parseFloat(contentXML.@x), parseFloat(contentXML.@y));
			openedPos = new Point(parseFloat(contentXML.@openX), parseFloat(contentXML.@openY));
			
			view = new DashboardSymbol();
			view.cacheAsBitmap = true;
			view.x = closedPos.x;
			view.y = closedPos.y;
			addChild(view);
			target = view;
			
			// Get View Refs
			indexBtn = view.indexBtn;
			bookmarksBtn = view.bookmarksBtn;
			aboutBtn = view.aboutBtn;
			
			//-- create panels and ui objetcs
			aboutPanel = new AboutPanel();
			aboutPanel.contentXML = XML(XMLList(contentXML.component.(@type == "aboutPanel")).toXMLString());
			aboutPanel.stylesheet = stylesheet;
			
			bookmarkPanel = new BookmarkPanel();
			bookmarkPanel.contentXML = XML(XMLList(contentXML.component.(@type == "bookmarkPanel")).toXMLString());
			bookmarkPanel.stylesheet = stylesheet;
			
			indexPanel = new IndexPanel();
			indexPanel.contentXML = XML(XMLList(contentXML.component.(@type == "indexPanel")).toXMLString());
			indexPanel.stylesheet = stylesheet;
			
			addChild(indexPanel);
			addChild(bookmarkPanel);
			addChild(aboutPanel);
			
			//-- UIOBJECTS Holder for easier access
			uiObjects = new Vector.<DisplayObject>();
			uiObjects.push(indexBtn);
			uiObjects.push(bookmarksBtn);
			uiObjects.push(aboutBtn);
			
			panels = new Vector.<ContentObject>();
			panels.push(indexPanel);
			panels.push(bookmarkPanel);
			panels.push(aboutPanel);
			
			simpleButtons = new Vector.<SimpleButton>();
			simpleButtons.push(indexBtn);
			simpleButtons.push(bookmarksBtn);
			simpleButtons.push(aboutBtn);
			
			selectedPanelIndex = 0;
			
			var openTweenData:XMLList = contentXML.tween.tween.(@id == "openTween");
			openTween = TweenParser.getTweenFromXML(view, openTweenData[0]);
			
			parseContent();
			showUI(false);
		}
		
		private function initEvents():void
		{
			addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			openTween.addEventListener(TweenEvent.COMPLETE, onCompleteOpen);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if (e.target is SimpleButton)
			{
				var src:DisplayObject = e.target as DisplayObject;
				var srcName:String = src.name;
				
				switch (srcName)
				{
					case "indexBtn":
						showPanel(0);
						break;
					
					case "bookmarksBtn":
						showPanel(1);
						break;
					
					case "aboutBtn":
						showPanel(2);
						break;
					
					default:
						break;
				}
			}
		}
		
		override public function open():void
		{
			Logger.log("Dashboard.open");
			
			if (!isOpen)
			{
				isOpen = true;
				openTween.play();
			}
		}
		
		override public function close():void
		{
			Logger.log("Dashboard.close");
			
			if (isOpen)
			{
				isOpen = false;
				showUI(false);
				
				panels[selectedPanelIndex].hide();
				simpleButtons[selectedPanelIndex].setSelected(false);
				
				openTween.reverse();
			}
		}
		
		private function onCompleteOpen(e:Event):void
		{
			showUI(true);
			showPanel(selectedPanelIndex);
		}
		
		private function showUI(value:Boolean):void
		{
			for (var i:int = 0; i < uiObjects.length; i++)
			{
				var obj:DisplayObject = uiObjects[i] as DisplayObject;
				
				if (value && obj)
				{
					obj.alpha = 0;
					TweenLite.to(obj, .5, {autoAlpha: 1, delay: i * .05});
				}
				else if (obj)
				{
					TweenLite.to(obj, 0, {autoAlpha: 0});
				}
			}
		}
		
		public function showPanel(index:int):void
		{
			panels[index].show();
			simpleButtons[index].setSelected(true);
			
			if (index != selectedPanelIndex)
			{
				panels[selectedPanelIndex].hide();
				simpleButtons[selectedPanelIndex].setSelected(false);
				selectedPanelIndex = index;
			}
		}
		
		public function addBookmark(page:PageData):void
		{
			bookmarkPanel.insert(page);
		}
		
		public function removeBookmark(page:PageData):void
		{
			bookmarkPanel.remove(page);
		}

	}

}