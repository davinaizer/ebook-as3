/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import com.unboxds.button.SimpleButton;
	import com.unboxds.ebook.constants.ContentType;
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;

	public class SimpleButtonParser extends AbsParser
	{
		public function SimpleButtonParser()
		{
		}

		override public function parse():void
		{
			var containerName:String = "@target" in contentXML ? contentXML.@target + "." : "";

			var itemCount:int = contentXML.content.length();
			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@instanceName" in contentXML.content[i] ? contentXML.content[i].@instanceName : ContentType.SIMPLEBUTTON + "_" + i;
				instanceName = containerName + instanceName;
				var btn:SimpleButton = ObjectUtils.getChildByPath(target, instanceName) as SimpleButton;

				if (btn != null)
				{
					btn.stylesheet = stylesheet;
					btn.label = contentXML.content[i].title.toString() + contentXML.content[i].body.toString();

					//-- check for custom config
					if ("vars" in contentXML.content[i])
					{
						var varsXML:Object = ObjectUtils.xmlVarsToObject(XML(XMLList(contentXML.content[i].vars).toXMLString()));
						ObjectUtils.applyVars(btn, varsXML);
					}
				}
				else
				{
					Logger.log("SimpleButtonParser Error >> SIMPLEBUTTON '" + instanceName + "' not found!");
				}
			}
		}
	}
}
