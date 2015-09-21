package com.unboxds.components
{
	import assets.buttons.btCloseTooltip;
	import com.hybrid.ui.ToolTip;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.utils.Logger;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Davi Naizer
	 */
	public class FixedTooltip extends ToolTip
	{
		private var closeBtn:SimpleButton;
		private var _isOpen:Boolean;
		
		public function FixedTooltip()
		{
			super();
			
			this.mouseChildren = true;
			_isOpen = false;
			
			closeBtn = new btCloseTooltip() as SimpleButton;
			closeBtn.addEventListener(MouseEvent.CLICK, mouseHandler, false, 0, true);
			
			addChild(closeBtn);
		}
		
		override public function show(p:DisplayObject, title:String, content:String = null):void
		{
			//-- remove to recalculate tooltip size
			this.removeChild(closeBtn);
			
			super.show(p, title, content);
			
			this._parentObject.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			this.follow(false);
			
			//-- add button after
			closeBtn.x = _defaultWidth - (closeBtn.width / 2);
			closeBtn.y = -closeBtn.width / 2;
			addChild(closeBtn);
			
			_tf.addEventListener(TextEvent.LINK, textHandler);
			_isOpen = true;
			
			// check for clicks outside the tooltip and close it
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			
			position();
		}
		
		private function textHandler(e:TextEvent):void
		{
			var urlStr:String = e.text;
			var linkType:String = urlStr.split("://")[0];
			
			switch (linkType)
			{
				case "http": 
					break;
				
				case "file": 
					urlStr = urlStr.split("file://")[1];
					break;
			
			}
			
			var url:URLRequest = new URLRequest(urlStr);
			try
			{
				navigateToURL(url);
			}
			catch (e:Error)
			{
				trace("textHandler Error occurred!");
			}
		}
		
		override public function hide():void
		{
			if (_isOpen)
			{
				stage.focus = stage;
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				
				_isOpen = false;
				this.animate(false);
			}
		}
		
		private function mouseHandler(e:MouseEvent):void
		{
			if (this.contains(e.target as DisplayObject) == false || e.target == closeBtn)
				this.hide();
		}
		
		override protected function position():void
		{
			var parentCoords:Point = new Point(_parentObject.mouseX, _parentObject.mouseY);
			var globalPoint:Point = _parentObject.localToGlobal(parentCoords);
			var xp:Number = globalPoint.x + this._offSet;
			var yp:Number = globalPoint.y - this.height - 10;
			
			var overhangRight:Number = this._defaultWidth + xp + 25;
			if (overhangRight >= stage.stageWidth)
			{
				xp = stage.stageWidth - this._defaultWidth - 25;
			}
			
			if (xp < 10)
			{
				xp = 10;
			}
			
			if (yp < 25)
			{
				yp = 25;
			}
			
			this.x = xp;
			this.y = yp;
		}
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
		}
	}

}