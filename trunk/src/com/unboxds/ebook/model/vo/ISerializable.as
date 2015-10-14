/**
 * Created by Naizer on 14/10/2015.
 */
package com.unboxds.ebook.model.vo
{
	public interface ISerializable
	{
		function toJSON():String;

		function parse(obj:Object):void;
	}
}
