/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import com.unboxds.ebook.constants.ContentType;
	import com.unboxds.utils.LinkUtils;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LinkParser extends AbsParser
	{
		public function LinkParser()
		{
		}

		override public function parse():void
		{
			var containerName:String = "@target" in contentXML ? contentXML.@target + "." : "";

			var itemCount:int = contentXML.content.length();
			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@instanceName" in contentXML.content[i] ? contentXML.content[i].@instanceName : ContentType.LINK + "_" + i;
				instanceName = containerName + instanceName;
				var link:Sprite = ObjectUtils.getChildByPath(target, instanceName) as Sprite;

				if (link != null)
				{
					link.tabIndex = i;
					link.buttonMode = true;
					link.mouseChildren = false;
					link.addEventListener(MouseEvent.CLICK, linkHandler);
				}
				else
				{
					Logger.log("LinkParser Error >> LINK '" + instanceName + "' not found!");
				}
			}
		}

		private function linkHandler(e:MouseEvent):void
		{
			var src:DisplayObject = e.target as DisplayObject;
			var srcName:String = src.name;
			var index:int = parseInt(srcName.split("_")[1]);
			var links:XMLList = contentXML.content.(@type == ContentType.LINK);

			LinkUtils.openLink(links.content[index].body.toString());
		}
	}
}
