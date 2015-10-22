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
	import flash.display.Sprite;
	import flash.geom.Point;

	public class ImageParser extends AbsParser
	{
		private var imgLoader:LoaderMax;

		public function ImageParser()
		{
		}

		override public function parse():void
		{
			var containerName:String = "@target" in contentXML ? contentXML.@target : "";
			var itemCount:int = contentXML.content.length();

			// create a loader
			imgLoader = new LoaderMax({
				name: target.name + "_imageLoader",
				onComplete: onLoadImage,
				onError: errorHandler,
				itemCount: itemCount
			});

			// iterate images
			for (var i:int = 0; i < itemCount; i++)
			{
				var targetName:String = "@target" in contentXML.content[i] ? contentXML.content[i].@target : "";
				if (targetName.length == 0)
					targetName = containerName;
				else if (containerName.length > 0 && targetName.length > 0)
					targetName = containerName + "." + targetName;

				var imgURL:String = contentXML.content[i].@src;
				var targetObj:DisplayObjectContainer = (targetName == "") ? target : ObjectUtils.getChildByPath(target, targetName) as DisplayObjectContainer;
				var pos:Point = new Point(parseFloat(contentXML.content[i].@x), parseFloat(contentXML.content[i].@y));

				var imgContainer:Sprite = new Sprite();
				imgContainer.name = "imgClip_" + i;
				targetObj.addChild(imgContainer);

				if (targetObj != null)
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
						ObjectUtils.applyVars(imgContainer, varsXML);
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
