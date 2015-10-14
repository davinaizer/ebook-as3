package com.unboxds.ebook.model
{
	import com.unboxds.ebook.model.vo.NavVO;
	import com.unboxds.ebook.model.vo.PageVO;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtil;

	/**
	 * ...
	 * @author UNBOX
	 */
	public class NavModel
	{
		private var _pages:Vector.<Vector.<PageVO>>;
		private var _pageQueue:Vector.<PageVO>;

		//-- Persistent Vars
		private var _maxPage:int;
		private var _maxModule:int;
		private var _currentPage:int;
		private var _currentModule:int;

		//--
		private var _totalModules:uint;
		private var _totalPages:uint;
		private var _modPagesCount:Array;
		private var _navDirection:int;

		public function NavModel()
		{
			Logger.log("NavModel.NavModel");

			_pages = new Vector.<Vector.<PageVO>>();
			_pageQueue = new Vector.<PageVO>();
			_totalModules = 0;
			_totalPages = 0;
			_modPagesCount = [];
			_navDirection = 1;

			// PERSIST
			_maxPage = 0;
			_maxModule = 0;
			_currentPage = 0;
			_currentModule = 0;
		}

		public function parseData(xml:XML):void
		{
			Logger.log("NavModel.parseData");

			var modList:XMLList = xml.page.page.(@id == "nav").page.(@id.indexOf("module") >= 0);
			var modId:int = 0;
			var pageCount:int = 0;

			for each (var nodeList:XML in modList)
			{
				_pages[modId] = new Vector.<PageVO>();

				var pageIndex:int = 0;
				var pageList:XMLList = nodeList.page;
				var modSize:int = pageList.length();
				var moduleName:String = nodeList.@title;

				for each (var node:XML in pageList)
				{
					var page:PageVO = new PageVO();
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
					page.showProgress = node.@showProgress.toString().length == 0 || node.@showProgress.toString() == "true";
					page.pageTransitionIn = node.@pageTransitionIn.toString().length == 0 ? null : node.@pageTransitionIn;
					page.pageTransitionOut = node.@pageTransitionOut.toString().length == 0 ? null : node.@pageTransitionOut;
					page.contentTransitionIn = node.@contentTransitionIn.toString().length == 0 ? null : node.@contentTransitionIn;
					page.contentTransitionOut = node.@contentTransitionOut.toString().length == 0 ? null : node.@contentTransitionOut;

					_pages[modId].push(page);
					_pageQueue.push(page);
				}

				modId++;
			}

			_totalModules = pages.length;
			_totalPages = pageQueue.length;
			_navDirection = 1;
			_modPagesCount = [];

			for (var i:int = 0; i < pages.length; i++)
				_modPagesCount.push(pages[i].length);

			Logger.log(">>>> NavModel Statistics <<<<");
			Logger.log("	• Total Modules: " + _totalModules);
			Logger.log("	• Total Pages in each module: " + _modPagesCount.join(" | "));
			Logger.log("	• Total Pages: " + _totalPages);
			Logger.log("-------------------");
		}

		public function dump():NavVO
		{
			Logger.log("NavModel.dump");

			var navVO:NavVO = new NavVO();
			navVO.currentModule = _currentModule;
			navVO.currentPage = _currentPage;
			navVO.maxModule = _maxModule;
			navVO.maxPage = _maxPage;

			return navVO;
		}

		public function restore(value:NavVO):void
		{
			Logger.log("NavModel.restore > " + value);

			if (value != null)
				ObjectUtil.copyComplexProps(value, this);
		}

		public function get pages():Vector.<Vector.<PageVO>>
		{
			return _pages;
		}

		public function get pageQueue():Vector.<PageVO>
		{
			return _pageQueue;
		}

		public function get maxPage():int
		{
			return _maxPage;
		}

		public function set maxPage(value:int):void
		{
			_maxPage = value;
		}

		public function get maxModule():int
		{
			return _maxModule;
		}

		public function set maxModule(value:int):void
		{
			_maxModule = value;
		}

		public function get currentPage():int
		{
			return _currentPage;
		}

		public function set currentPage(value:int):void
		{
			_currentPage = value;
		}

		public function get currentModule():int
		{
			return _currentModule;
		}

		public function set currentModule(value:int):void
		{
			_currentModule = value;
		}

		public function get totalModules():uint
		{
			return _totalModules;
		}

		public function set totalModules(value:uint):void
		{
			_totalModules = value;
		}

		public function get totalPages():uint
		{
			return _totalPages;
		}

		public function set totalPages(value:uint):void
		{
			_totalPages = value;
		}

		public function get modPagesCount():Array
		{
			return _modPagesCount;
		}

		public function set modPagesCount(value:Array):void
		{
			_modPagesCount = value;
		}

		public function get navDirection():int
		{
			return _navDirection;
		}

		public function set navDirection(value:int):void
		{
			_navDirection = value;
		}

		/**
		 * Returns last page user has accessed
		 */
		public function getUserLastPage():PageVO
		{
			var userLastPage:PageVO = PageVO(pages[maxModule][maxPage]);
			return userLastPage;
		}

		public function getCurrentPage():PageVO
		{
			var page:PageVO = pages[currentModule][currentPage];
			return page;
		}

		public function getPages():Vector.<PageVO>
		{
			return pageQueue;
		}

		public function getPageByIndex(index:int):PageVO
		{
			var page:PageVO = pageQueue[index];
			return page;
		}

		public function getPageByName(name:String):PageVO
		{
			for (var i:int = 0; i < pageQueue.length; i++)
			{
				var page:PageVO = pageQueue[i] as PageVO;
				if (page.branch == name)
					return page;
			}
			return null;
		}
	}
}