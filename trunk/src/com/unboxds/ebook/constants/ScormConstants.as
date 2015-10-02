/**
 * Created by davinaizer on 10/1/15.
 */
package com.unboxds.ebook.constants
{
	public class ScormConstants
	{
		//ENTRY CONSTANTS
		public static const ENTRY_ABINITIO:String = "ab-initio";
		public static const ENTRY_RESUME:String = "resume";

		//-- STATUS CONSTANTS
		public static const STATUS_PASSED:String = "passed";
		public static const STATUS_COMPLETED:String = "completed";
		public static const STATUS_FAILED:String = "failed";
		public static const STATUS_INCOMPLETE:String = "incomplete";
		public static const STATUS_BROWSED:String = "browsed";
		public static const STATUS_NOT_ATTEMPTED:String = "not attempted";

		//-- LESSON MODES
		public static const MODE_BROWSE:String = "browse";
		public static const MODE_NORMAL:String = "normal";
		public static const MODE_REVIEW:String = "review";

		//-- EXIT CONSTANTS
		public static const EXIT_TIMEOUT:String = "time-out";
		public static const EXIT_SUSPEND:String = "suspend";
		public static const EXIT_LOGOUT:String = "logout";

		// SCORM 1.2 PARAMS
		public static const PARAM_COMMENTS:String = "cmi.comments";
		public static const PARAM_CREDIT:String = "cmi.core.credit";
		public static const PARAM_ENTRY:String = "cmi.core.entry";
		public static const PARAM_EXIT:String = "cmi.core.exit";
		public static const PARAM_LAUNCH_DATA:String = "cmi.launch_data";
		public static const PARAM_LESSON_LOCATION:String = "cmi.core.lesson_location";
		public static const PARAM_LESSON_MODE:String = "cmi.core.lesson_mode";
		public static const PARAM_LESSON_STATUS:String = "cmi.core.lesson_status";
		public static const PARAM_SCORE_MAX:String = "cmi.core.score.max";
		public static const PARAM_SCORE_MIN:String = "cmi.core.score.min";
		public static const PARAM_SCORE_RAW:String = "cmi.core.score.raw";
		public static const PARAM_SESSION_TIME:String = "cmi.core.session_time";
		public static const PARAM_STUDENT_ID:String = "cmi.core.student_id";
		public static const PARAM_STUDENT_NAME:String = "cmi.core.student_name";
		public static const PARAM_SUSPEND_DATA:String = "cmi.suspend_data";
		public static const PARAM_TOTAL_TIME:String = "cmi.core.total_time";

		public function ScormConstants()
		{
		}
	}
}
