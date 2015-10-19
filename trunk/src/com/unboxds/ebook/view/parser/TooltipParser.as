/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import com.hybrid.ui.ToolTip;
	import com.unboxds.button.SimpleButton;
	import com.unboxds.components.FixedTooltip;
	import com.unboxds.ebook.constants.ContentType;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;
	import com.unboxds.utils.StringUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class TooltipParser extends AbsParser
	{
		private var _tooltip:ToolTip;

		public function TooltipParser()
		{
		}

		override public function parse():void
		{
			var containerName:String = "@target" in contentXML ? contentXML.@target + "." : "";

			if (!_tooltip)
			{
				_tooltip = (contentXML.@clickToOpen == "true") ? new FixedTooltip() as ToolTip : new ToolTip();
				_tooltip.stylesheet = stylesheet;
				_tooltip.titleEmbed = true;
				_tooltip.contentEmbed = true;
				_tooltip.autoSize = (contentXML.@autoSize == "true");
				_tooltip.align = (contentXML.@align.toString().length == 0) ? "left" : contentXML.@align;
				_tooltip.hook = (contentXML.@hook == "true");
				_tooltip.hookSize = contentXML.@hookSize.toString().length == 0 ? 25 : parseInt(contentXML.@hookSize);
				_tooltip.cornerRadius = contentXML.@cornerRadius.toString().length == 0 ? 10 : parseInt(contentXML.@cornerRadius);
				_tooltip.showDelay = contentXML.@showDelay.toString().length == 0 ? 0 : parseInt(contentXML.@showDelay);
				_tooltip.hideDelay = contentXML.@hideDelay.toString().length == 0 ? 0 : parseInt(contentXML.@hideDelay);
				_tooltip.bgAlpha = contentXML.@bgAlpha.toString().length == 0 ? 1 : parseFloat(contentXML.@bgAlpha);
				_tooltip.tipWidth = contentXML.@width.toString().length == 0 ? 300 : parseInt(contentXML.@width);
				_tooltip.colors = contentXML.@colors.toString().length == 0 ? [0xFCB910, 0xFCB910] : contentXML.@colors.toString().split(",");
				_tooltip.padding = contentXML.@padding.toString().length == 0 ? 0 : parseFloat(contentXML.@padding);
			}

			var itemCount:int = contentXML.content.length();
			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@instanceName" in contentXML.content[i] ? contentXML.content[i].@instanceName : ContentType.TOOLTIP + "_" + i;
				instanceName = containerName + instanceName;
				var tt:Sprite = ObjectUtils.getChildByPath(target, instanceName) as Sprite;

				if (tt != null)
				{
					tt.tabIndex = i;
					tt.buttonMode = true;
					tt.mouseChildren = false;

					if (contentXML.@clickToOpen == "true" || contentXML.content[i].@clickToOpen == "true")
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
					Logger.log("TooltipParser Error >> TOOLTIP '" + instanceName + "' not found!");
				}
			}
		}

		private function tooltipHandler(e:MouseEvent):void
		{
			var src:Sprite = e.target as Sprite;
			var index:int = src.tabIndex;
			var titleTxt:String = contentXML.content[index].title.toString();
			var bodyTxt:String = contentXML.content[index].body.toString();

			if (titleTxt.indexOf("{$") > -1)
				titleTxt = StringUtils.parseTextVars(titleTxt, src.parent);
			if (bodyTxt.indexOf("{$") > -1)
				bodyTxt = StringUtils.parseTextVars(bodyTxt, src.parent);

			if(e.target is SimpleButton)
				SimpleButton(e.target).setVisited(true);

			_tooltip.show(src, titleTxt, bodyTxt);
		}

	}
}
