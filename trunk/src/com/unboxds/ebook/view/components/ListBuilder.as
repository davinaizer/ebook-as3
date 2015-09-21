package com.unboxds.ebook.view.components
{
	
	/*
	 * ...
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class ListBuilder
	{
		private var _name:String;
		private var _x:Number;
		private var _y:Number;
		private var _columns:uint;
		private var _rows:uint;
		private var _spacing:Number;
		private var _width:Number;
		private var _height:Number;
		private var _buttonPrefix:String;
		private var _buildAnimStagger:Number;
		
		public function ListBuilder()
		{
			_columns = 1;
			_rows = 1;
			_spacing = 5;
			_width = 100;
			_height = 50;
			_buildAnimStagger = 0.05;
		}
		
		/*
		 * create ListBuilder from XML, eg:
		 * <object type="List" name="menuList" x="40" y="100" width="417.5" height="220" columns="1" rows="4" spacing="15" buildAnimStagger="0.5"></object>
		 * */
		public function fromXML(data:XML):ListBuilder
		{
			if (data != null)
			{
				_name = data.@name;
				_x = parseFloat(data.@x);
				_y = parseFloat(data.@y);
				_width = parseFloat(data.@width);
				_height = parseFloat(data.@height);
				_rows = parseInt(data.@rows);
				_columns = parseInt(data.@columns);
				_spacing = parseFloat(data.@spacing);
				_buildAnimStagger = parseFloat(data.@buildAnimStagger);
			}
			
			return this;
		}
		
		public function build():List
		{
			return new List(this);
		}
		
		//** GETTERS SETTERS
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
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
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get buttonPrefix():String
		{
			return _buttonPrefix;
		}
		
		public function set buttonPrefix(value:String):void
		{
			_buttonPrefix = value;
		}
		
		public function get buildAnimStagger():Number 
		{
			return _buildAnimStagger;
		}
		
		public function set buildAnimStagger(value:Number):void 
		{
			_buildAnimStagger = value;
		}
	
	}

}