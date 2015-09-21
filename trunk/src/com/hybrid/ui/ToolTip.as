/**

   The MIT License

   Copyright (c) 2008 Duncan Reid ( http://www.hy-brid.com )

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.

 **/

package com.hybrid.ui
{
	
	import com.greensock.events.TweenEvent;
	import com.greensock.TweenLite;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	//import fl.transitions.Tween;
	//import fl.transitions.easing.*;
	//import fl.transitions.TweenEvent;
	
	/**
	 * Public Setters:
	
	 *		tipWidth 				Number				Set the width of the tooltip
	 *		titleFormat				TextFormat			Format for the title of the tooltip
	 * 		stylesheet				StyleSheet			StyleSheet object
	 *		contentFormat			TextFormat			Format for the bodycopy of the tooltip
	 *		titleEmbed				Boolean				Allow font embed for the title
	 *		contentEmbed			Boolean				Allow font embed for the content
	 *		align					String				left, right, center
	 *		showDelay				Number				Time in milliseconds to delay the display of the tooltip
	 *		hideDelay				Number				Time in milliseconds to delay the hide of the tooltip
	 *		hook					Boolean				Displays a hook on the bottom of the tooltip
	 *		hookSize				Number				Size of the hook
	 *		cornerRadius			Number				Corner radius of the tooltip, same for all 4 sides
	 *		colors					Array				Array of 2 color values ( [0xXXXXXX, 0xXXXXXX] );
	 *		autoSize				Boolean				Will autosize the fields and size of the tip with no wrapping or multi-line capabilities,
	   helpful with 1 word items like "Play" or "Pause"
	 * 		border					Number				Color Value: 0xFFFFFF
	 *		borderSize				Number				Size Of Border
	 *		buffer					Number				text buffer
	 * 		bgAlpha					Number				0 - 1, transparency setting for the background of the ToolTip
	 * 		padding					Number				Sets the minimum distance from the edges of the stage / screen
	 *
	 * Example:
	
	   var tf:TextFormat = new TextFormat();
	   tf.bold = true;
	   tf.size = 12;
	   tf.color = 0xff0000;
	
	   var tt:ToolTip = new ToolTip();
	   tt.hook = true;
	   tt.hookSize = 20;
	   tt.cornerRadius = 20;
	   tt.align = "center";
	   tt.titleFormat = tf;
	   tt.show( DisplayObject, "Title Of This ToolTip", "Some Copy that would go below the ToolTip Title" );
	 *
	 *
	 * @author Duncan Reid, www.hy-brid.com
	 * @date October 17, 2008
	 * @version 1.2
	 */
	
	public class ToolTip extends Sprite
	{
		
		//objects
		protected var _stage:Stage;
		protected var _parentObject:DisplayObject;
		protected var _tf:TextField; // title field
		protected var _cf:TextField; //content field
		protected var _contentContainer:Sprite = new Sprite(); // container to hold both textfields
		protected var _tween:TweenLite;
		
		protected var hookSp:Sprite = new Sprite();
		protected var boxSp:Sprite = new Sprite();
		
		//formats
		protected var _titleFormat:TextFormat;
		protected var _contentFormat:TextFormat;
		
		//stylesheet
		protected var _stylesheet:StyleSheet;
		
		/* check for stylesheet override */
		protected var _styleOverride:Boolean = false;
		
		/* check for format override */
		protected var _titleOverride:Boolean = false;
		protected var _contentOverride:Boolean = false;
		
		// font embedding
		protected var _titleEmbed:Boolean = false;
		protected var _contentEmbed:Boolean = false;
		
		//defaults
		protected var _defaultWidth:Number = 200;
		protected var _defaultHeight:Number;
		protected var _buffer:Number = 10;
		protected var _align:String = "center";
		protected var _cornerRadius:Number = 12;
		protected var _bgColors:Array = [0xFFFFFF, 0x9C9C9C];
		protected var _autoSize:Boolean = false;
		protected var _hookEnabled:Boolean = false;
		protected var _showDelay:Number = 0; //millilseconds
		protected var _hideDelay:Number = 0; //millilseconds
		protected var _hookSize:Number = 20;
		protected var _border:Number;
		protected var _borderSize:Number = 1;
		protected var _bgAlpha:Number = 1; // transparency setting for the background of the tooltip
		protected var _followCursor:Boolean = true;
		protected var _padding:Number = 0; //Distance from the edges of the stage
		
		//offsets
		protected var _offSet:Number;
		protected var _hookOffSet:Number;
		
		//-- hook
		protected var defaultHookPos:Point = new Point();
		
		//showDelay
		protected var _showTimer:Timer;
		protected var _hideTimer:Timer;
		
		public function ToolTip():void
		{
			//do not disturb parent display object mouse events
			this.mouseEnabled = false;
			this.buttonMode = false;
			this.mouseChildren = false;
			
			//setup showDelay timer
			_showTimer = new Timer(_showDelay, 1);
			_hideTimer = new Timer(_hideDelay, 1);
			
			_showTimer.addEventListener(TimerEvent.TIMER, showTimerHandler);
			_hideTimer.addEventListener(TimerEvent.TIMER, hideTimerHandler);
		}
		
		public function setContent(title:String, content:String = null):void
		{
			boxSp.graphics.clear();
			this.addCopy(title, content);
			this.setOffset();
			this.drawBG();
		}
		
		public function show(p:DisplayObject, title:String, content:String = null):void
		{
			//get the stage from the parent
			this._stage = p.stage;
			this._parentObject = p;
			
			// added : DR : 04.29.2010
			var onStage:Boolean = this.addedToStage(this._contentContainer);
			if (!onStage)
			{
				this.addChild(this.boxSp);
				this.addChild(this.hookSp);
				this.addChild(this._contentContainer);
			}
			
			// end add
			this.addCopy(title, content);
			this.setOffset();
			this.drawBG();
			this.bgGlow();
			
			//initialize coordinates
			var parentCoords:Point = new Point(_parentObject.mouseX, _parentObject.mouseY);
			var globalPoint:Point = p.localToGlobal(parentCoords);
			this.x = globalPoint.x + this._offSet;
			this.y = globalPoint.y - this.height - _hookSize;
			
			this.alpha = 0;
			this._stage.addChild(this);
			this._parentObject.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			//removed mouse move handler in lieu of enterframe for smoother movement
			//this._parentObject.addEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMovement );
			
			this.follow(_followCursor);
			
			//-- clean any hide command
			TweenLite.killTweensOf(this);
			
			_hideTimer.reset();
			_showTimer.start();
		}
		
		public function hide():void
		{
			this._parentObject.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			
			_showTimer.reset();
			_hideTimer.start();
		}
		
		protected function showTimerHandler(event:TimerEvent):void
		{
			this.animate(true);
		}
		
		protected function hideTimerHandler(event:TimerEvent):void
		{
			this.animate(false);
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			_hideTimer.start();
		}
		
		protected function follow(value:Boolean):void
		{
			if (value)
			{
				addEventListener(Event.ENTER_FRAME, this.eof);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, this.eof);
			}
		}
		
		protected function eof(event:Event):void
		{
			this.position();
		}
		
		protected function position():void
		{
			var speed:Number = .5;
			var parentCoords:Point = new Point(_parentObject.mouseX, _parentObject.mouseY);
			var globalPoint:Point = _parentObject.localToGlobal(parentCoords);
			var xp:Number = globalPoint.x + this._offSet;
			var yp:Number = globalPoint.y - this.height - _buffer;
			
			/* Adjustments to add stage border padding - Tiago Ling Alexandre - 21/10/2013 (Timestamp pending) */
			var overhangRight:Number = xp + width;
			if (overhangRight > stage.stageWidth)
			{
				xp = stage.stageWidth - this.width - _padding;
			}
			
			if (xp < 0)
			{
				xp = _padding;
			}
			
			if (yp < 0)
			{
				yp = globalPoint.y + _hookSize + _buffer;
			}
			/* End of adjustments */
			
			/* modified - Davi Naizer - 08/07/2012 */
			if (_hookEnabled)
			{
				//-- check hook Position
				var mouseLocalX:Number = this.mouseX - (_hookSize / 2);
				var hookX:Number = _hookOffSet - (_hookSize / 2);
				var hookY:Number = 1;
				var hookXMin:Number = _buffer;
				var hookXMax:Number = _defaultWidth - _hookSize - _buffer;
				
				if (overhangRight > stage.stageWidth)
					hookX = (mouseLocalX < hookXMax) ? mouseLocalX : hookXMax;
				
				if (globalPoint.x + this._offSet < 0)
					hookX = (mouseLocalX < hookXMin) ? hookXMin : mouseLocalX;
				
				if (globalPoint.y - this.height - _buffer < 0)
				{
					hookY = 1;
					hookSp.scaleY = -1;
				}
				else
				{
					hookY = defaultHookPos.y;
					hookSp.scaleY = 1;
				}
				
				hookSp.y = hookY;
				hookSp.x = hookX;
			}
			/* end modify */
			
			this.x += (xp - this.x) * speed;
			this.y += (yp - this.y) * speed;
		}
		
		protected function addCopy(title:String, content:String = null):void
		{
			if (this._tf == null)
			{
				this._tf = this.createField(this._titleEmbed);
			}
			
			// if using a stylesheet for title field
			if (this._styleOverride)
			{
				this._tf.styleSheet = this._stylesheet;
			}
			this._tf.htmlText = title;
			
			// if not using a stylesheet
			if (!this._styleOverride)
			{
				// if format has not been set, set default
				if (!this._titleOverride)
				{
					this.initTitleFormat();
				}
				this._tf.setTextFormat(this._titleFormat);
			}
			
			if (this._autoSize)
			{
				this._defaultWidth = this._tf.textWidth + 4 + (_buffer * 2);
			}
			else
			{
				_tf.multiline = true;
				_tf.wordWrap = true;
				
				this._tf.width = this._defaultWidth - (_buffer * 2);
			}
			
			this._tf.x = this._tf.y = this._buffer;
			//this.textGlow( this._tf );
			this._contentContainer.addChild(this._tf);
			
			//if using content
			if (content != null)
			{
				if (this._cf == null)
				{
					this._cf = this.createField(this._contentEmbed);
				}
				
				// if using a stylesheet for title field
				if (this._styleOverride)
				{
					this._cf.styleSheet = this._stylesheet;
				}
				
				this._cf.htmlText = content;
				
				// if not using a stylesheet
				if (!this._styleOverride)
				{
					// if format has not been set, set default
					if (!this._contentOverride)
					{
						this.initContentFormat();
					}
					this._cf.setTextFormat(this._contentFormat);
				}
				var bounds:Rectangle = this.getBounds(this);
				this._cf.x = this._buffer;
				this._cf.y = this._tf.y + this._tf.textHeight;
				//this.textGlow( this._cf );
				
				if (this._autoSize)
				{
					var cfWidth:Number = this._cf.textWidth + 4 + (_buffer * 2);
					this._defaultWidth = cfWidth > this._defaultWidth ? cfWidth : this._defaultWidth;
				}
				else
				{
					_cf.multiline = true;
					_cf.wordWrap = true;
					
					this._cf.width = this._defaultWidth - (_buffer * 2);
				}
				
				this._contentContainer.addChild(this._cf);
			}
		}
		
		//create field
		protected function createField(embed:Boolean):TextField
		{
			var tf:TextField = new TextField();
			tf.embedFonts = embed;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.PIXEL;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			
			if (!this._autoSize)
			{
				tf.multiline = true;
				tf.wordWrap = true;
			}
			return tf;
		}
		
		//draw background, use drawing api if we need a hook
		protected function drawBG():void
		{
			/* re-add : 04.29.2010 : clear graphics in the event this is a re-usable tip */
			boxSp.graphics.clear();
			/* end add */
			
			hookSp.graphics.clear();
			
			var bounds:Rectangle = this.getBounds(this);
			var h:Number = isNaN(this._defaultHeight) ? bounds.height + (this._buffer * 2) : this._defaultHeight;
			var fillType:String = GradientType.LINEAR;
			//var colors:Array = [0xFFFFFF, 0x9C9C9C];
			var alphas:Array = [this._bgAlpha, this._bgAlpha];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			var radians:Number = 90 * Math.PI / 180;
			matr.createGradientBox(this._defaultWidth, h, radians, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			
			if (!isNaN(this._border))
			{
				boxSp.graphics.lineStyle(_borderSize, _border, 1);
			}
			
			/* modified - Davi Naizer - 08/07/2012 */
			boxSp.graphics.beginGradientFill(fillType, this._bgColors, alphas, ratios, matr, spreadMethod);
			boxSp.graphics.drawRoundRect(0, 0, this._defaultWidth, h, this._cornerRadius);
			
			if (this._hookEnabled)
			{
				var xp:Number = 0;
				var yp:Number = 0;
				
				hookSp.x = _hookOffSet - (_hookSize / 2);
				hookSp.y = h - 1;
				
				defaultHookPos = new Point(hookSp.x, hookSp.y);
				
				hookSp.graphics.beginFill(_bgColors[1], alphas[1]);
				hookSp.graphics.moveTo(0, 0);
				hookSp.graphics.lineTo(_hookSize, 0);
				hookSp.graphics.lineTo(_hookSize / 2, _hookSize / 2);
				hookSp.graphics.lineTo(0, 0);
				hookSp.graphics.endFill();
			}
			/* end mofify */
		}
		
		/* Fade In / Out */
		protected function animate(show:Boolean):void
		{
			if (show)
			{
				TweenLite.to(this, .5, {alpha: 1});
			}
			else
			{
				_showTimer.reset();
				TweenLite.to(this, .2, {alpha: 0, onComplete: onComplete});
			}
		}
		
		protected function onComplete():void
		{
			//event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.cleanUp();
		}
		
		/* End Fade */
		
		/** Getters / Setters */
		
		public function set buffer(value:Number):void
		{
			this._buffer = value;
		}
		
		public function get buffer():Number
		{
			return this._buffer;
		}
		
		public function set bgAlpha(value:Number):void
		{
			this._bgAlpha = value;
		}
		
		public function get bgAlpha():Number
		{
			return this._bgAlpha;
		}
		
		public function set tipWidth(value:Number):void
		{
			this._defaultWidth = value;
		}
		
		public function set titleFormat(tf:TextFormat):void
		{
			this._titleFormat = tf;
			if (this._titleFormat.font == null)
			{
				this._titleFormat.font = "_sans";
			}
			this._titleOverride = true;
		}
		
		public function set contentFormat(tf:TextFormat):void
		{
			this._contentFormat = tf;
			if (this._contentFormat.font == null)
			{
				this._contentFormat.font = "_sans";
			}
			this._contentOverride = true;
		}
		
		public function set stylesheet(ts:StyleSheet):void
		{
			this._stylesheet = ts;
			this._styleOverride = true;
		}
		
		public function set align(value:String):void
		{
			var a:String = value.toLowerCase();
			var values:String = "right left center";
			if (values.indexOf(value) == -1)
			{
				throw new Error(this + " : Invalid Align Property, options are: 'right', 'left' & 'center'");
			}
			else
			{
				this._align = a;
			}
		}
		
		public function set showDelay(value:Number):void
		{
			this._showDelay = value;
			this._showTimer.delay = value;
		}
		
		public function set hideDelay(value:Number):void
		{
			this._hideDelay = value;
			this._hideTimer.delay = value;
		}
		
		public function set hook(value:Boolean):void
		{
			this._hookEnabled = value;
		}
		
		public function set hookSize(value:Number):void
		{
			this._hookSize = value;
		}
		
		public function set cornerRadius(value:Number):void
		{
			this._cornerRadius = value;
		}
		
		public function set colors(colArray:Array):void
		{
			this._bgColors = colArray;
		}
		
		public function set autoSize(value:Boolean):void
		{
			this._autoSize = value;
		}
		
		public function set border(value:Number):void
		{
			this._border = value;
		}
		
		public function set borderSize(value:Number):void
		{
			this._borderSize = value;
		}
		
		public function set tipHeight(value:Number):void
		{
			this._defaultHeight = value;
		}
		
		public function set titleEmbed(value:Boolean):void
		{
			this._titleEmbed = value;
		}
		
		public function set contentEmbed(value:Boolean):void
		{
			this._contentEmbed = value;
		}
		
		public function get followCursor():Boolean
		{
			return _followCursor;
		}
		
		public function set followCursor(value:Boolean):void
		{
			_followCursor = value;
		}
		
		public function get padding():Number 
		{
			return _padding;
		}
		
		public function set padding(value:Number):void 
		{
			_padding = value;
		}
		
		/* End Getters / Setters */
		
		/* Cosmetic */
		
		protected function textGlow(field:TextField):void
		{
			var color:Number = 0x000000;
			var alpha:Number = 0.35;
			var blurX:Number = 2;
			var blurY:Number = 2;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			var filter:GlowFilter = new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			var myFilters:Array = [];
			myFilters.push(filter);
			field.filters = myFilters;
		}
		
		protected function bgGlow():void
		{
			var color:Number = 0x000000;
			var alpha:Number = 0.60;
			var blurX:Number = 5;
			var blurY:Number = 5;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			
			var filter:GlowFilter = new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			var myFilters:Array = [];
			myFilters.push(filter);
			filters = myFilters;
		}
		
		protected function initTitleFormat():void
		{
			_titleFormat = new TextFormat();
			_titleFormat.font = "_sans";
			_titleFormat.bold = true;
			_titleFormat.size = 20;
			_titleFormat.color = 0x333333;
		}
		
		protected function initContentFormat():void
		{
			_contentFormat = new TextFormat();
			_contentFormat.font = "_sans";
			_contentFormat.bold = false;
			_contentFormat.size = 14;
			_contentFormat.color = 0x333333;
		}
		
		/* End Cosmetic */
		
		/* Helpers */
		
		protected function addedToStage(displayObject:DisplayObject):Boolean
		{
			var hasStage:Stage = displayObject.stage;
			return hasStage == null ? false : true;
		}
		
		/*
		   //Check if font is a device font
		   protected function isDeviceFont( format:TextFormat ):Boolean {
		   var font:String = format.font;
		   var device:String = "_sans _serif _typewriter";
		   return device.indexOf( font ) > -1;
		   //_sans
		   //_serif
		   //_typewriter
		   }
		
		   protected function isDeviceStyleSheet( sheet:StyleSheet ):Boolean {
		   var styleNames:Array = sheet.styleNames;
		   var len:int = styleNames.length;
		   var isDevice:Boolean = false;
		   for( var i:int = 0; i < len; i++ ){
		   //var style:String = styleNames[i];
		   var style:Object = sheet.getStyle(styleNames[i]);
		   var fmt:TextFormat = new TextFormat();
		   fmt = sheet.transform( style );
		   var isDeviceFont:Boolean = this.isDeviceFont( fmt );
		   //trace("IS DEVICE FONT : " + isDeviceFont );
		   }
		   return false;
		   }
		 */
		
		protected function setOffset():void
		{
			switch (this._align)
			{
				case "left": 
					this._offSet = -_defaultWidth + _buffer + this._hookSize;
					this._hookOffSet = this._defaultWidth - _buffer - this._hookSize;
					break;
				
				case "right": 
					this._offSet = _buffer - this._hookSize;
					this._hookOffSet = _buffer + this._hookSize;
					break;
				
				case "center": 
					this._offSet = -(_defaultWidth / 2);
					this._hookOffSet = (_defaultWidth / 2);
					break;
				
				default: 
					this._offSet = -(_defaultWidth / 2);
					this._hookOffSet = (_defaultWidth / 2);
					break;
			}
		}
		
		/* End Helpers */
		
		/* Clean */
		
		protected function cleanUp():void
		{
			this._parentObject.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
			//this._parentObject.removeEventListener( MouseEvent.MOUSE_MOVE, this.onMouseMovement );
			this.follow(false);
			this._tf.filters = [];
			this.filters = [];
			this._contentContainer.removeChild(this._tf);
			this._tf = null;
			
			if (this._cf)
			{
				this._cf.filters = [];
				this._contentContainer.removeChild(this._cf);
			}
			boxSp.graphics.clear();
			removeChild(this._contentContainer);
			parent.removeChild(this);
			
			if (_hookEnabled && hookSp)
			{
				hookSp.graphics.clear();
				removeChild(this.hookSp);
			}
		}
	
	/* End Clean */
	
	/*
	   protected function onMouseMovement( event:MouseEvent ):void {
	   var parentCoords:Point = new Point( _parentObject.mouseX, _parentObject.mouseY );
	   var globalPoint:Point = _parentObject.localToGlobal(parentCoords);
	   this.x = globalPoint.x - this.width;
	   this.y = globalPoint.y - this.height - 10;
	   event.updateAfterEvent();
	   }
	 */
	
	}
}
