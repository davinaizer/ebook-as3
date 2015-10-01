package com.unboxds.ebook.model
{
	import com.unboxds.ebook.model.vo.PageData;
	import com.unboxds.utils.Logger;

	/**
	 * ...
	 * @author UNBOX
	 */
	public class NavModel // MODEL OK. Can Store more data
	{
		private var _pages:Vector.<Vector.<PageData>>;
		private var _pageQueue:Vector.<PageData>;

		public function NavModel()
		{
			Logger.log("NavModel.NavModel");

			_pages = new Vector.<Vector.<PageData>>();
			_pageQueue = new Vector.<PageData>();
		}

		public function parsePages(xml:XML):void
		{
			var modList:XMLList = xml.page.page.(@id == "nav").page.(@id.indexOf("module") >= 0);
			var modId:int = 0;
			var pageCount:int = 0;

			for each (var nodeList:XML in modList)
			{
				_pages[modId] = new Vector.<PageData>();

				var pageIndex:int = 0;
				var pageList:XMLList = nodeList.page;
				var modSize:int = pageList.length();
				var moduleName:String = nodeList.@title;

				for each (var node:XML in pageList)
				{
					var page:PageData = new PageData();
					page.index = pageCount++;
					page.moduleIndex = modId;
					page.localIndex = pageIndex++;
					page.counter = [pageIndex, modSize];
					page.branch = "index/nav/" + nodeList.@id + "/" + node.@id;
					page.src = node.@src;
					page.title = node.@title;
					page.modTitle = moduleName;
					page.contentURL = node.asset.(@id == "contentXML").@src;
					page.navbarStatus = node.@navbarStatus.toString().length == 0 ? null : node.@navbarStatus;
					page.showProgress = node.@showProgress.toString().length == 0 || node.@showProgress.toString() == "true" ? true : false;
					page.pageTransitionIn = node.@pageTransitionIn.toString().length == 0 ? null : node.@pageTransitionIn;
					page.pageTransitionOut = node.@pageTransitionOut.toString().length == 0 ? null : node.@pageTransitionOut;
					page.contentTransitionIn = node.@contentTransitionIn.toString().length == 0 ? null : node.@contentTransitionIn;
					page.contentTransitionOut = node.@contentTransitionOut.toString().length == 0 ? null : node.@contentTransitionOut;

					_pages[modId].push(page);
					_pageQueue.push(page);
				}

				modId++;
			}
		}

		public function get pages():Vector.<Vector.<PageData>>
		{
			return _pages;
		}

		public function get pageQueue():Vector.<PageData>
		{
			return _pageQueue;
		}

	}

}