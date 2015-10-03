/**
 * Created by davinaizer on 10/2/15.
 */
package com.unboxds.utils
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	public class ObjectUtil
	{
		public function ObjectUtil()
		{
		}

		static public function parse(obj:Object, targetObj:Object):void
		{
			var description:XML = describeType(targetObj);

			for each (var a:XML in description.accessor)
			{
				var param:String = a.@name;
				if (obj.hasOwnProperty(param))
				{
					var classType:String = getQualifiedClassName(obj[param]);
					if (classType == "Object")
					{
						parse(obj[param], targetObj[param])
					}
					else
					{
						targetObj[param] = obj[param];

						Logger.log("ObjectUtil.parse > " + param + " : " + ( (targetObj[param])));
					}
				}
			}
		}

		static public function toString(obj:Object):String
		{
			var ret:String = "";
			for (var param:String in obj)
			{
				var classType:String = getQualifiedClassName(obj[param]);
				if (classType == "Object")
				{
					ret += toString(obj[param]);
				}
				else
				{
					ret += "ObjectUtil.toString > " + obj + " :: " + param + " : " + ( (obj[param])) + "\n";
				}
			}

			return ret;
		}
	}
}
