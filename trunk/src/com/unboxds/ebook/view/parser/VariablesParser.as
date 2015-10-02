/**
 * Created by davinaizer on 9/23/15.
 */
package com.unboxds.ebook.view.parser
{
	import com.unboxds.utils.Logger;
	import com.unboxds.utils.ObjectUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class VariablesParser extends AbsParser
	{
		public function VariablesParser()
		{
		}

		override public function parse():void
		{
			var container:DisplayObjectContainer = target as DisplayObjectContainer;
			var itemCount:int = contentXML.vars.length();

			for (var i:int = 0; i < itemCount; i++)
			{
				var instanceName:String = "@target" in contentXML.vars[i] ? contentXML.vars[i].@target : null;
				var object:DisplayObject = ObjectUtils.getChildByPath(container, instanceName);

				if (object != null)
				{
					var vars:Object = ObjectUtils.xmlVarsToObject(XML(XMLList(contentXML.vars[i]).toXMLString()));
					ObjectUtils.applyVars(object, vars);
				}
				else
				{
					Logger.log("VariablesParser Error >> Target '" + instanceName + "' not found!");
				}
			}
		}
	}
}
