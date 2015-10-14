package com.unboxds.ebook
{
	import com.unboxds.ebook.controller.EbookController;
	import com.unboxds.ebook.controller.NavController;
	import com.unboxds.ebook.model.EbookModel;
	import com.unboxds.ebook.model.NavModel;
	import com.unboxds.utils.DebugPanel;

	/**
	 * Ebook Framework API class.
	 *
	 * <p>In simple terms, the EbookApi FrameWork is a tool to speed up eLearning and paged content creation.<br>
	 * It has a set of tools to help paging content, transitions effects, user's data tracking, navigation.</p>
	 *
	 * <p>It was mainly developed to be used as eLearning creation framework but it can be used to create other non-learning content, as websites, hotsites, catalogs, etc.</p>
	 *
	 * <p>The EbookApi Framework was built over Gaia Framework.
	 * The Gaia framework has a very powerful asset and page manager.
	 * More info about how it works and documentation, can be found here (http://gaiaflashframework.tenderapp.com/).</p>
	 *
	 * <p>To start building an application using UNBOXDS EbookApi Framework, we higly recommend reading the Gaia´s documentation first.</p>
	 * <p>To create an ebook app, you have two main files to edit, xml/ebook_nav.xml and xml/ebook_ui.xml.</p>
	 * <p>The file ebook_nav is used to config all the navigation and pages sequence of the material. You can config other properties of the ebook, such as:
	 * <ul><li>consultMode:    if true, the ebook is set to Consult Mode only, thus not saving any data to the dataService.</li>
	 * <li>enableAlerts:    if true, all comunication and startup erros dialogs are show.</li>
	 * <li>dataServiceType:    Here you can specify the dataservice type to be used in the ebook. Allowed only: SCORM and SharedObject. If SCORM is set, the SCORM API is used and will require a SORM compatible LMS. For SharedObject dataservice all the users and ebook´s data will be written locally using ShareObject Class.</li>
	 * <li>customData:    Sometimes its necessary to use persistent user´s data or store user´s progress and achievements. To help in this task CustomVO Class was created and to setup the data format, you can define using the tags below.</li>
	 * <ul><li>maxPoints:    An array specifying a test or interactions max points.</li>
	 * <li>customData:    An array specifying a test or interactions status. Its best used using the CustomVO status constants. See CustomVO class.</li>
	 * </ul></ul>
	 * </p>
	 *
	 * <p>To help common tasks, the EbookApi FrameWork has a integrated ContentParser that reads the page content XML and renders the data. To understand how this class works see ContentParser Class.</p>
	 *
	 * <p>All rights reserved - UNBOX® - http://www.unbox.com.br</p>
	 *
	 * @author UNBOX® - http://www.unbox.com.br - All rights reserved.
	 */
	public class EbookApi
	{
		private static var model:EbookModel;
		private static var controller:EbookController;
		private static var navModel:NavModel;
		private static var navController:NavController;
		private static var debugPanel:DebugPanel;

		public function EbookApi()
		{
			throw new Error("EbookApi cant be instantiated.");
		}

		static public function getNavController():NavController
		{
			if (EbookApi.navController == null)
				EbookApi.navController = new NavController();
			return EbookApi.navController;
		}

		static public function getNavModel():NavModel
		{
			if (EbookApi.navModel == null)
				EbookApi.navModel = new NavModel();
			return EbookApi.navModel;
		}

		static public function getEbookController():EbookController
		{
			if (EbookApi.controller == null)
				EbookApi.controller = new EbookController();
			return EbookApi.controller;
		}

		static public function getEbookModel():EbookModel
		{
			if (EbookApi.model == null)
				EbookApi.model = new EbookModel();
			return EbookApi.model;
		}

		static public function getDebugPanel():DebugPanel
		{
			return EbookApi.debugPanel;
		}

		static public function setDebugPanel(debugPanel:DebugPanel):void
		{
			EbookApi.debugPanel = debugPanel;
		}
	}
}