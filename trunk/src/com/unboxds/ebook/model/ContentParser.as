package com.unboxds.ebook.model
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenLite;
	import com.hybrid.ui.ToolTip;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.components.FixedTooltip;
	import com.unboxds.ebook.Ebook;
	import com.unboxds.ebook.model.vo.ContentType;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;
	import com.unboxds.utils.StringUtils;
	import com.unboxds.utils.TextFieldUtils;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Helper class to build the content read from a XML
	 * <p>To be parsed the content must use "content" tag and the attribute "type" must be set accordingly.</p>
	 * <p>The Content Parser accepts some predefined content types to help you creating the page content.</p>
	 * <p>Accepted types are: text, link, tooltip, simplebutton and image.</p>
	 * <p>For convenience, please use ContentType class to access these constants when used manually inside a class.</p>
	 * <p>Every content type accepts different parameters. To know these differences, see the examples below.</p>
	 * <p>Examples of usage:</p>
	 *
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved. © 2009-2015
	 *
	 */
	public class ContentParser
	{
		private var _target:DisplayObjectContainer;
		private var _contentXML:XML;
		private var _stylesheet:StyleSheet;
		private var _tooltip:ToolTip;
		
		private var navActions:Object;
		private var imgLoader:LoaderMax;
		
		public function ContentParser(target:DisplayObjectContainer, contentXML:XML, stylesheet:StyleSheet = null)
		{
			_target = target;
			_contentXML = contentXML;
			_stylesheet = stylesheet;
		}
		
		public function parse():void
		{
			var i:int = 0;
			var typeCount:int = _contentXML.content.length();
			for (i = 0; i < typeCount; i++)
			{
				var type:String = _contentXML.content[i].@type;
				var cXML:XML = _contentXML.content[i];
				
				switch (type)
				{
					case ContentType.TEXTFIELD: 
						parseTextfield(cXML);
						break;
					
					case ContentType.LINK: 
						parseLinks(cXML);
						break;
					
					case ContentType.TOOLTIP: 
						parseTooltip(cXML);
						break;
					
					case ContentType.SIMPLEBUTTON: 
						parseSimpleButton(cXML);
						break;
					
					case ContentType.IMAGE: 
						parseImage(cXML);
						break;
					
					case ContentType.NAVIGATION: 
						parseNav(cXML);
						break;
					
					case ContentType.VARIABLES: 
						parseVars(cXML);
						break;
					
					default: 
						break;
				}
			}
		}
		
		private function parseTextfield(xmlNode:XML):void
		{
			var containerName:String = "@target" in xmlNode ? xmlNode.@target + "." : "";
			
			var itemCount:int = xmlNode.content.length();
			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@instanceName" in xmlNode.content[i] ? xmlNode.content[i].@instanceName : ContentType.TEXTFIELD + "_" + i;
				instanceName = containerName + instanceName;
				var txt:TextField = ObjectUtils.getChildByPath(_target, instanceName) as TextField;
				
				if (txt != null)
				{
					TextFieldUtils.initTextField(txt, _stylesheet);
					
					var cText:String = xmlNode.content[i].title.toString() + xmlNode.content[i].body.toString();
					if (cText.indexOf("{$") > -1)
						cText = StringUtils.parseTextVars(cText, _target);
					
					txt.htmlText = cText;
					
					if (cText.indexOf("<a href=") > -1)
					{
						txt.mouseEnabled = true;
						txt.addEventListener(TextEvent.LINK, textHandler);
					}
					else
					{
						txt.mouseEnabled = false;
					}
					
					//-- check for custom config
					if ("vars" in xmlNode.content[i])
					{
						var varsXML:Object = ObjectUtils.xmlVarsToObject(XML(XMLList(xmlNode.content[i].vars).toXMLString()));
						ObjectUtils.applyVars(txt, varsXML);
					}
				}
				else
				{
					Logger.log("ContentParser Error @ " + getQualifiedClassName(_target) + " >> TEXTFIELD '" + instanceName + "' not found!");
				}
			}
		}
		
		/*		//MOVE TO ObjectUtils AFTER TESTING
		   public static function applyAccessibility(target:Object, vars:Object):void
		   {
		   var accessProps:AccessibilityProperties = new AccessibilityProperties();
		   for (var i:String in vars)
		   {
		   if (i in accessProps)
		   {
		   accessProps[i] = vars[i];
		   Logger.log("Setting var '" + i + "' @ " + target);
		   } else {
		   Logger.log("ObjectUtils.applyAccessibility >> property " + i + " does not exist in AccessibilityProperties class.");
		   }
		   }
		
		   if ("accessibilityProperties" in target)
		   {
		   target["accessibilityProperties"] = accessProps;
		   Logger.log("Accessibility properties successfully enabled for object : " + target);
		   }
		   else
		   {
		   Logger.log("ObjectUtils.applyAccessibility >> property 'accessibilityProperties' not found @ " + target);
		   }
		   }
		 //MOVE TO ObjectUtils AFTER TESTING*/
		
		private function parseLinks(xmlNode:XML):void
		{
			var container:DisplayObjectContainer = _target.getChildByName(xmlNode.@target) as DisplayObjectContainer;
			if (container == null)
				container = _target;
			
			var itemCount:int = xmlNode.content.length();
			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@instanceName" in xmlNode.content[i] ? xmlNode.content[i].@instanceName : ContentType.LINK + "_" + i;
				var link:Sprite = container.getChildByName(instanceName) as Sprite;
				
				if (link != null)
				{
					link.tabIndex = i;
					link.buttonMode = true;
					link.mouseChildren = false;
					link.addEventListener(MouseEvent.CLICK, linkHandler);
				}
				else
				{
					Logger.log("ContentParser Error >> LINK '" + instanceName + "' not found!");
				}
			}
		}
		
		private function parseTooltip(xmlNode:XML):void
		{
			var container:DisplayObjectContainer = _target.getChildByName(xmlNode.@target) as DisplayObjectContainer;
			if (container == null)
				container = _target;
			
			if (!_tooltip)
			{
				_tooltip = (xmlNode.@clickToOpen == "true") ? new FixedTooltip() as ToolTip : new ToolTip();
				_tooltip.stylesheet = _stylesheet;
				_tooltip.titleEmbed = true;
				_tooltip.contentEmbed = true;
				_tooltip.autoSize = (xmlNode.@autoSize == "true") ? true : false;
				_tooltip.align = (xmlNode.@align.toString().length == 0) ? "left" : xmlNode.@align;
				_tooltip.hook = (xmlNode.@hook == "false") ? false : true;
				_tooltip.hookSize = xmlNode.@hookSize.toString().length == 0 ? 25 : parseInt(xmlNode.@hookSize);
				_tooltip.cornerRadius = xmlNode.@cornerRadius.toString().length == 0 ? 10 : parseInt(xmlNode.@cornerRadius);
				_tooltip.showDelay = xmlNode.@showDelay.toString().length == 0 ? 0 : parseInt(xmlNode.@showDelay);
				_tooltip.hideDelay = xmlNode.@hideDelay.toString().length == 0 ? 0 : parseInt(xmlNode.@hideDelay);
				_tooltip.bgAlpha = xmlNode.@bgAlpha.toString().length == 0 ? 1 : parseFloat(xmlNode.@bgAlpha);
				_tooltip.tipWidth = xmlNode.@width.toString().length == 0 ? 300 : parseInt(xmlNode.@width);
				_tooltip.colors = xmlNode.@colors.toString().length == 0 ? [0xFCB910, 0xFCB910] : xmlNode.@colors.toString().split(",");
				_tooltip.padding = xmlNode.@padding.toString().length == 0 ? 0 : parseFloat(xmlNode.@padding);
			}
			
			var itemCount:int = xmlNode.content.length();
			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@instanceName" in xmlNode.content[i] ? xmlNode.content[i].@instanceName : ContentType.TOOLTIP + "_" + i;
				var tt:Sprite = container.getChildByName(instanceName) as Sprite;
				
				if (tt != null)
				{
					tt.tabIndex = i;
					tt.buttonMode = true;
					tt.mouseChildren = false;
					
					if (xmlNode.@clickToOpen == "true")
					{
						tt.addEventListener(MouseEvent.CLICK, tooltipHandler);
					}
					else
					{
						tt.addEventListener(MouseEvent.ROLL_OVER, tooltipHandler);
					}
				}
				else
				{
					Logger.log("ContentParser Error >> TOOLTIP '" + instanceName + "' not found!");
				}
			}
		}
		
		private function parseSimpleButton(xmlNode:XML):void
		{
			var container:DisplayObjectContainer = _target.getChildByName(xmlNode.@target) as DisplayObjectContainer;
			if (container == null)
				container = _target;
			
			var itemCount:int = xmlNode.content.length();
			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@instanceName" in xmlNode.content[i] ? xmlNode.content[i].@instanceName : ContentType.SIMPLEBUTTON + "_" + i;
				var btn:SimpleButton = container.getChildByName(instanceName) as SimpleButton;
				btn.stylesheet = _stylesheet;
				
				if (btn != null)
				{
					btn.label = xmlNode.content[i].title.toString() + xmlNode.content[i].body.toString();
					
					//-- check for custom config
					if ("vars" in xmlNode.content[i])
					{
						var varsXML:Object = ObjectUtils.xmlVarsToObject(XML(XMLList(xmlNode.content[i].vars).toXMLString()));
						ObjectUtils.applyVars(btn, varsXML);
					}
				}
				else
				{
					Logger.log("ContentParser Error >> SIMPLEBUTTON '" + instanceName + "' not found!");
				}
			}
		}
		
		private function parseImage(xmlNode:XML):void
		{
			var container:DisplayObjectContainer = _target.getChildByName(xmlNode.@target) as DisplayObjectContainer;
			if (container == null)
				container = _target;
			
			var itemCount:int = xmlNode.content.length();
			imgLoader = new LoaderMax({name: _target.name + "_imageLoader", onComplete: onLoadImage, onError: errorHandler, itemCount: itemCount});
			
			for (var i:int = 0; i < itemCount; i++)
			{
				var imgURL:String = xmlNode.content[i].@src;
				var containerName:String = "@container" in xmlNode.content[i] ? xmlNode.content[i].@container : "";
				var imgContainer:DisplayObjectContainer = containerName == "" ? _target : container.getChildByName(xmlNode.content[i].@container) as DisplayObjectContainer;
				var pos:Point = new Point(parseFloat(xmlNode.content[i].@x), parseFloat(xmlNode.content[i].@y));
				
				if (container != null)
				{
					imgLoader.append(new ImageLoader(imgURL, {name: "image_" + i, container: imgContainer, x: pos.x, y: pos.y, alpha: 0}));
					
					//-- check for custom config
					if ("vars" in xmlNode.content[i])
					{
						var varsXML:Object = ObjectUtils.xmlVarsToObject(XML(XMLList(xmlNode.content[i].vars).toXMLString()));
						ObjectUtils.applyVars(container, varsXML);
					}
				}
				else
				{
					Logger.log("ContentParser Error >> IMAGE ('" + imgURL + "'): ImgContainer '" + xmlNode.content[i].@container + "' not found!");
				}
			}
			
			imgLoader.load();
		}
		
		private function parseNav(xmlNode:XML):void
		{
			navActions = {};
			
			var actionCount:int = xmlNode.action.length();
			for (var i:int = 0; i < actionCount; i++)
			{
				var type:String = xmlNode.action[i].@type;
				var value:String = xmlNode.action[i].value;
				
				navActions[type] = value;
				
				switch (type)
				{
					case "onBeforeNextPage": 
						Ebook.getInstance().getNav().onBeforeNextPage = this.onBeforeNextPage;
						break;
					
					case "onBeforeBackPage": 
						Ebook.getInstance().getNav().onBeforeBackPage = this.onBeforeBackPage;
						break;
				}
			}
		}
		
		private function parseVars(xmlNode:XML):void
		{
			var container:DisplayObjectContainer = _target as DisplayObjectContainer;
			var itemCount:int = xmlNode.vars.length();
			
			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@target" in xmlNode.vars[i] ? xmlNode.vars[i].@target : null;
				var object:DisplayObject = ObjectUtils.getChildByPath(container, instanceName);
				
				if (object != null)
				{
					var vars:Object = ObjectUtils.xmlVarsToObject(XML(XMLList(xmlNode.vars[i]).toXMLString()));
					ObjectUtils.applyVars(object, vars);
				}
				else
				{
					Logger.log("ContentParser Error >> Target '" + instanceName + "' not found!");
				}
			}
		}
		
		//-- NAVIGATION FUNCTIONS
		private function onBeforeNextPage():void
		{
			Ebook.getInstance().getNav().navigateTo(navActions["onBeforeNextPage"]);
		}
		
		private function onBeforeBackPage():void
		{
			Ebook.getInstance().getNav().navigateTo(navActions["onBeforeBackPage"]);
		}
		
		private function onLoadImage(e:LoaderEvent):void
		{
			var itemCount:int = LoaderMax(e.target).vars.itemCount;
			for (var i:int = 0; i < itemCount; i++)
			{
				var img:ContentDisplay = imgLoader.getContent("image_" + i);
				if (img != null)
					TweenLite.to(img, .2, {alpha: 1});
			}
		}
		
		private function errorHandler(event:LoaderEvent):void
		{
			Logger.log(">> Error occured with " + event.target + ": " + event.text);
		}
		
		//-- HANDLERS
		private function linkHandler(e:MouseEvent):void
		{
			var src:DisplayObject = e.target as DisplayObject;
			var srcName:String = src.name;
			var index:int = parseInt(srcName.split("_")[1]);
			var links:XMLList = contentXML.content.(@type == ContentType.LINK);
			
			openLink(links.content[index].body.toString());
		}
		
		private function textHandler(e:TextEvent):void
		{
			var paramArr:Array = e.text.split(",");
			var type:String = paramArr[0];
			var value:String = paramArr[1];
			
			if (type == ContentType.TOOLTIP)
			{
			}
			else if (type == ContentType.LINK)
			{
				openLink(value);
			}
		}
		
		private function tooltipHandler(e:MouseEvent):void
		{
			var tooltips:XMLList = contentXML.content.(@type == ContentType.TOOLTIP);
			var src:Sprite = e.target as Sprite;
			var index:int = src.tabIndex;
			var text:String = tooltips.content[index].title.toString() + tooltips.content[index].body.toString();
			
			_tooltip.show(src, text);
		}
		
		//-- UTILS
		private function openLink(urlStr:String, params:String = "_blank"):void
		{
			var linkType:String = urlStr.split("://")[0];
			switch (linkType)
			{
				case "http": 
				case "https": 
				case "ftp": 
					break;
				
				case "file": 
					urlStr = urlStr.split("file://")[1];
					break;
				
				case "tooltip": 
					break;
				default: 
					break;
			}
			
			var url:URLRequest = new URLRequest(urlStr);
			try
			{
				navigateToURL(url, params);
			}
			catch (e:Error)
			{
				Logger.log("OPENLINK Error >> URL: " + url + " >> PARAMS:" + params);
			}
		}
		
		//-- GETTERS and SETTERS
		public function get contentXML():XML
		{
			return _contentXML;
		}
		
		public function set contentXML(value:XML):void
		{
			_contentXML = value;
		}
		
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		
		public function set target(value:DisplayObjectContainer):void
		{
			_target = value;
		}
		
		public function get stylesheet():StyleSheet
		{
			return _stylesheet;
		}
		
		public function set stylesheet(value:StyleSheet):void
		{
			_stylesheet = value;
		}
		
		public function get tooltip():ToolTip
		{
			return _tooltip;
		}
		
		public function set tooltip(value:ToolTip):void
		{
			_tooltip = value;
		}
	
	}

}