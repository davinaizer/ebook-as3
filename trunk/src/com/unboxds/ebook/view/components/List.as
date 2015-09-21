package com.unboxds.ebook.view.components
{
	import com.adobe.utils.DictionaryUtil;
	import com.greensock.easing.Quint;
	import com.greensock.plugins.ScrollRectPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.utils.ArrayUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.utils.Dictionary;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class List extends Sprite
	{
		private var listHolder:Sprite;
		private var listButtons:Dictionary;
		private var columnWidth:Number;
		private var rowHeight:Number;
		
		private var _listButtonsKeys:Array;
		private var _columns:uint;
		private var _rows:uint;
		private var _spacing:Number;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _totalPages:uint;
		private var _currentPage:uint;
		private var _totalItems:uint;
		private var _maxItensPerPage:uint;
		private var _buttonClass:Class;
		private var _buttonPrefix:String;
		private var _stylesheet:StyleSheet;
		private var _buildAnimStagger:Number;
		
		public var onChange:Signal;
		public var onClick:NativeSignal;
		
		public function List(builder:ListBuilder)
		{
			TweenPlugin.activate([ScrollRectPlugin]);
			
			listButtons = new Dictionary();
			listButtonsKeys = [];
			
			onChange = new Signal(List);
			onClick = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			
			this.name = builder.name;
			this.x = builder.x;
			this.y = builder.y;
			this._columns = builder.columns;
			this._rows = builder.rows;
			this._maxWidth = builder.width;
			this._maxHeight = builder.height;
			this._spacing = builder.spacing;
			this._buttonPrefix = builder.buttonPrefix;
			this._buildAnimStagger = builder.buildAnimStagger;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			init();
			initEvents();
		}
		
		private function init():void
		{
			_currentPage = 0;
			_totalPages = 0;
			_totalItems = 0;
			_maxItensPerPage = _columns * _rows;
			
			rowHeight = _maxHeight / _rows;
			columnWidth = _maxWidth / _columns;
			
			listHolder = new Sprite();
			listHolder.scrollRect = new Rectangle(0, 0, _maxWidth, _maxHeight);
			addChild(listHolder);
			
			onChange.dispatch(this);
		}
		
		private function initEvents():void
		{
		}
		
		public function nextPage():void
		{
			if (_currentPage < _totalPages - 1)
				_currentPage++;
			
			loadPage();
		}
		
		public function backPage():void
		{
			if (_currentPage > 0)
				_currentPage--;
			
			loadPage();
		}
		
		public function gotoPage(pageIndex:int):void
		{
			if (pageIndex >= _totalPages)
				pageIndex = _totalPages - 1;
			if (pageIndex < 0)
				pageIndex = 0;
			
			_currentPage = pageIndex;
			
			loadPage();
		}
		
		protected function loadPage():void
		{
			var nX:Number = 0;
			var nY:Number = 0;
			
			//var yBound:Number = rowHeight * Math.ceil((_totalItems - _maxItensPerPage) / _columns);
			nY = _maxHeight * _currentPage;
			//nY = nY > Math.abs(yBound) ? yBound : nY;
			
			TweenLite.to(listHolder, .5, {scrollRect: {x: nX, y: nY}, ease: Quint.easeOut});
			
			onChange.dispatch(this);
		}
		
		public function insert(value:int = -1, label:String = null):void
		{
			var contains:Boolean = listHolder.getChildByName(_buttonPrefix + "_" + value) != null;
			if (!contains && value != -1 && label != null)
			{
				var btn:SimpleButton = new _buttonClass() as SimpleButton;
				btn.name = _buttonPrefix + "_" + value;
				btn.stylesheet = _stylesheet;
				btn.label = label;
				btn.alpha = 0;
				
				listButtons[value] = btn;
				listHolder.addChild(btn);
				
				listButtonsKeys = DictionaryUtil.getKeys(listButtons);
				listButtonsKeys.sort(Array.NUMERIC);
				
				_totalItems = listButtonsKeys.length;
				_totalPages = Math.ceil(_totalItems / _maxItensPerPage);
				
				var index:int = ArrayUtils.binarySearch(listButtonsKeys, value);
				var colId:int = index % _columns;
				var rowId:int = index / _columns;
				var sp:Number = (_maxHeight - (_rows * btn.height)) / (2 * _rows);
				var nX:Number = colId * columnWidth;
				var nY:Number = rowId * rowHeight + sp;
				
				if (_columns == 1)
				{
					nX = 0;
					nY = index * rowHeight;
				}
				
				btn.index = index;
				btn.x = nX;
				btn.y = nY;
				
				onChange.dispatch(this);
			}
		}
		
		public function remove(value:int):void
		{
			var btn:SimpleButton = listButtons[value] as SimpleButton;
			if (listHolder.contains(btn))
			{
				listHolder.removeChild(btn);
				delete listButtons[value];
				
				onChange.dispatch(this);
			}
		}
		
		public function update(value:int = -1):void
		{
			var updateFrom:int = ArrayUtils.binarySearch(listButtonsKeys, value);
			updateFrom = updateFrom > -1 ? updateFrom : 0;
			
			listButtonsKeys = DictionaryUtil.getKeys(listButtons);
			listButtonsKeys.sort(Array.NUMERIC);
			
			_totalItems = listButtonsKeys.length;
			_totalPages = Math.ceil(_totalItems / _maxItensPerPage);
			
			if (_totalItems > 0)
			{
				for (var i:int = updateFrom; i < listButtonsKeys.length; i++)
				{
					var btn:SimpleButton = listButtons[listButtonsKeys[i]] as SimpleButton;
					var colId:int = i % _columns;
					var rowId:int = i / _columns;
					var sp:Number = (_maxHeight - (_rows * btn.height)) / (2 * _rows);
					var nX:Number = colId * columnWidth;
					var nY:Number = rowId * rowHeight + sp;
					
					btn.index = i;
					btn.x = -btn.width / 2;
					
					if (_columns == 1)
					{
						nX = 0;
						nY = i * rowHeight + sp;
					}
					
					TweenLite.to(btn, .25, {delay: (i - updateFrom) * _buildAnimStagger, alpha: 1, x: nX, y: nY, ease: Quint.easeOut});
				}
			}
			
			gotoPage(_currentPage);
		}
		
		public function destroy():void
		{
			var len:int = listButtonsKeys.length;
			for (var i:int = 0; i < len; ++i)
				remove(listButtonsKeys[i]);
			
			_totalItems = 0;
			_totalPages = 1;
			_currentPage = 0;
			listButtonsKeys = [];
			
			onChange.dispatch(this);
		}
		
		//GETTERS & SETTERS
		public function get buttonClass():Class
		{
			return _buttonClass;
		}
		
		public function set buttonClass(value:Class):void
		{
			_buttonClass = value;
		}
		
		public function get currentPage():uint
		{
			return _currentPage;
		}
		
		public function set currentPage(value:uint):void
		{
			_currentPage = value;
		}
		
		public function get totalPages():uint
		{
			return _totalPages;
		}
		
		public function get totalItems():uint
		{
			return _totalItems;
		}
		
		public function get listButtonsKeys():Array
		{
			return _listButtonsKeys;
		}
		
		public function set listButtonsKeys(value:Array):void
		{
			_listButtonsKeys = value;
		}
		
		public function get buttonPrefix():String
		{
			return _buttonPrefix;
		}
		
		public function set buttonPrefix(value:String):void
		{
			_buttonPrefix = value;
		}
		
		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
		}
		
		public function get maxHeight():Number
		{
			return _maxHeight;
		}
		
		public function set maxHeight(value:Number):void
		{
			_maxHeight = value;
		}
		
		public function get columns():uint
		{
			return _columns;
		}
		
		public function set columns(value:uint):void
		{
			_columns = value;
		}
		
		public function get rows():uint
		{
			return _rows;
		}
		
		public function set rows(value:uint):void
		{
			_rows = value;
		}
		
		public function get spacing():Number
		{
			return _spacing;
		}
		
		public function set spacing(value:Number):void
		{
			_spacing = value;
		}
		
		public function get stylesheet():StyleSheet
		{
			return _stylesheet;
		}
		
		public function set stylesheet(value:StyleSheet):void
		{
			_stylesheet = value;
		}
		
		public function get maxItensPerPage():uint
		{
			return _maxItensPerPage;
		}
		
		public function set maxItensPerPage(value:uint):void
		{
			_maxItensPerPage = value;
		}
		
		public function get buildAnimStagger():Number 
		{
			return _buildAnimStagger;
		}
		
		public function set buildAnimStagger(value:Number):void 
		{
			_buildAnimStagger = value;
		}
		
		public function getButtonByIndex(index:uint):SimpleButton
		{
			var btn:SimpleButton = listButtons[listButtonsKeys[index]] as SimpleButton;
			
			return btn;
		}
	
	}

}