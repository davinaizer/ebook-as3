/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import com.unboxds.ebook.constants.ContentType;
	import com.unboxds.utils.LinkUtils;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;
	import com.unboxds.utils.StringUtils;
	import com.unboxds.utils.TextFieldUtils;

	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;

	public class TextFieldParser extends AbsParser
	{
		public function TextFieldParser()
		{
		}

		override public function parse():void
		{
			var containerName:String = "@target" in contentXML ? contentXML.@target + "." : "";
			var itemCount:int = contentXML.content.length();

			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@instanceName" in contentXML.content[i] ? contentXML.content[i].@instanceName : ContentType.TEXTFIELD + "_" + i;
				instanceName = containerName + instanceName;
				var txt:TextField = ObjectUtils.getChildByPath(target, instanceName) as TextField;

				if (txt != null)
				{
					TextFieldUtils.initTextField(txt, stylesheet);

					var cText:String = contentXML.content[i].title.toString() + contentXML.content[i].body.toString();
					if (cText.indexOf("{$") > -1)
						cText = StringUtils.parseTextVars(cText, target);

					txt.htmlText = StringUtils.removeTabsAndNewLines(cText);

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
					if ("vars" in contentXML.content[i])
					{
						var varsXML:Object = ObjectUtils.xmlVarsToObject(XML(XMLList(contentXML.content[i].vars).toXMLString()));
						ObjectUtils.applyVars(txt, varsXML);
					}
				}
				else
				{
					Logger.log("TextFieldParser Error @ " + getQualifiedClassName(target) + " >> TEXTFIELD '" + instanceName + "' not found!");
				}
			}
		}

		private function textHandler(e:TextEvent):void
		{
			var paramArr:Array = e.text.split(",");
			var eType:String = paramArr[0];
			var eValue:String = paramArr[1];

			if (eType == ContentType.TOOLTIP)
			{
			}
			else if (eType == ContentType.LINK)
			{
				LinkUtils.openLink(eValue);
			}


		}
	}
}