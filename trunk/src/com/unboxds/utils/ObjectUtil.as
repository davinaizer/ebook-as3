/**
 * Created by davinaizer on 10/2/15.
 */
package com.unboxds.utils
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ObjectUtil
	{
		public function ObjectUtil()
		{
		}

		/**
		 * Copy properties from Custom Class Objects to target Object using describeType() to check for accessors.
		 * @param obj    The Custom Class object to copy properties from
		 * @param targetObj The Object
		 */
		static public function copyComplexProps(obj:Object, targetObj:Object):void
		{
			var description:XML = describeType(targetObj);
			for each (var a:XML in description.accessor)
			{
				var param:String = a.@name;
				if (obj.hasOwnProperty(param))
				{
					var classType:String = getQualifiedClassName(obj[param]);
					if (classType == "Object")
						copyComplexProps(obj[param], targetObj[param]);
					else
						targetObj[param] = obj[param];
				}
			}
		}

		/**
		 * Copy properties from Simple Object to another Object
		 * @param obj    Source Object to copy properties from
		 * @param targetObj Target object
		 */
		static public function copyProps(obj:Object, targetObj:Object):void
		{
			for (var param:String in obj)
			{
				if (typeof (obj[param]) == "object")
				{
					copyProps(obj[param], targetObj[param]);
				} else
				{
					targetObj[param] = obj[param];
				}
			}
		}

		/**
		 * Return and instance of the object specified by name:String
		 * @param obj The class name
		 * @return An instance of the Class
		 */

		static public function getClassObj(className:String):*
		{
			var objClass:Class = Class(getDefinitionByName(className));
			return new objClass();
		}

		static public function toString(obj:Object):String
		{
			var ret:String = "";
			var description:XML = describeType(obj);
			var objName:String = description.@name.split("::")[1];

			for each (var a:XML in description.accessor)
			{
				var param:String = a.@name;
				var classType:String = a.@type;
				if (classType.indexOf("::") > -1)
					ret += toString(obj[param]);
				else
					ret += " > " + objName + "." + param + " = " + ( (obj[param])) + "\n";
			}
			return ret;
		}
	}
}
