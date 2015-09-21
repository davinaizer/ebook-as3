// JavaScript Document
<!--
function stopError()
  {return true;};

window.onerror = stopError;

function imprimir() {
   if (navigator.appName.indexOf("Microsoft") > -1 &&
       navigator.appVersion.indexOf("5.") == -1) {
      // IE4
      OLECMDID_PRINT = 6;
      OLECMDEXECOPT_DONTPROMPTUSER = 2;
      OLECMDEXECOPT_PROMPTUSER = 1;
      WebBrowser =
       '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="' +
       'CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
      document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
      WebBrowser1.ExecWB(OLECMDID_PRINT,   OLECMDEXECOPT_PROMPTUSER);
      WebBrowser1.outerHTML = "";
     }
   else {
     // N4 IE5
     window.print();
     }
   }

//-->
