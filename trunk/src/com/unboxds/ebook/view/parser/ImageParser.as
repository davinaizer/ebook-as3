/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;

	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class ImageParser extends AbsParser
	{
		private var imgLoader:LoaderMax;

		public function ImageParser()
		{
		}

		override public function parse():void
		{
			var container:DisplayObjectContainer = target.getChildByName(contentXML.@target) as DisplayObjectContainer;
			if (container == null)
				container = target;

			var itemCount:int = contentXML.content.length();
			imgLoader = new LoaderMax({
				name: target.name + "_imageLoader",
				onComplete: onLoadImage,
				onError: errorHandler,
				itemCount: itemCount
			});

			for (var i:int = 0; i < itemCount; i++)
			{
				var imgURL:String = contentXML.content[i].@src;
				var containerName:String = "@container" in contentXML.content[i] ? contentXML.content[i].@container : "";
				var imgContainer:DisplayObjectContainer = containerName == "" ? target : container.getChildByName(contentXML.content[i].@container) as DisplayObjectContainer;
				var pos:Point = new Point(parseFloat(contentXML.content[i].@x), parseFloat(contentXML.content[i].@y));

				if (container != null)
				{
					imgLoader.append(new ImageLoader(imgURL, {
						name: "image_" + i,
						container: imgContainer,
						x: pos.x,
						y: pos.y,
						alpha: 0
					}));

					//-- check for custom config
					if ("vars" in contentXML.content[i])
					{
						var varsXML:Object = ObjectUtils.xmlVarsToObject(XML(XMLList(contentXML.content[i].vars).toXMLString()));
						ObjectUtils.applyVars(container, varsXML);
					}
				}
				else
				{
					Logger.log("ImageParser Error >> IMAGE ('" + imgURL + "'): ImgContainer '" + contentXML.content[i].@container + "' not found!");
				}
			}

			imgLoader.load();
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
	}
}
