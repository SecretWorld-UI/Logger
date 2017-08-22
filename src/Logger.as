import mx.utils.Delegate;

import com.GameInterface.Log;

/**
 * ...
 * @author Sinthe
 */
class Logger
{
	private static var ERROR:Number = 5;
	private static var WARN:Number  = 4;
	private static var INFO2:Number = 3;
	private static var INFO1:Number = 2;
	private static var INFO0:Number = 1;
	private static var PRINT:Number = 0;
	
	private var origLogError:Function;
	private var origLogWarning:Function;
	private var origLogInfo2:Function;
	private var origLogInfo1:Function;
	private var origLogInfo0:Function;
	private var origLogPrint:Function;
	private var origGetMsgCache:Function;

	private var MsgLog:Array;
	private var MsgCache:Array;

	/**
	 * This is the main entry point.
	 * @param	swfRoot
	 */
	public static function main(swfRoot:MovieClip):Void
	{
		var modInst = new Logger(swfRoot);
		// Here we initialize some events that TSW uses to communicated with your addon. Note the lower case used in onLoad.
		swfRoot.onLoad = function() { modInst.OnLoad(); };
		swfRoot.OnUnload = function() { modInst.OnUnload(); };
	}

	public function Logger(swfRoot: MovieClip)
	{
		// Initialize MsgLog and MsgCache as empty;
		MsgLog = new Array()
		MsgCache = new Array();
	}

	public function OnLoad()
	{
		ActivateHooks();
	}

	public function OnUnload()
	{
		DeactivateHooks();
	}
	
	private function ActivateHooks()
	{
		origLogError = Log.Error;
		Log.Error = Delegate.create(this, Error);
		origLogWarning = Log.Warning;
		Log.Warning = Delegate.create(this, Warn);
		origLogInfo2 = Log.Info2;
		Log.Info2 = Delegate.create(this, Info2);
		origLogInfo1 = Log.Info1;
		Log.Info1 = Delegate.create(this, Info1);
		origLogInfo0 = Log.Info0;
		Log.Info0 = Delegate.create(this, Info0);
		origLogPrint = Log.Print;
		Log.Print = Delegate.create(this, Print);
		origGetMsgCache = Log.GetMsgCache;
		Log.GetMsgCache = Delegate.create(this, GetMsgCache);
	}
	
	private function DeactivateHooks()
	{
		Log.Error = origLogError;
		Log.Warning = origLogWarning;
		Log.Info2 = origLogInfo2;
		Log.Info1 = origLogInfo1;
		Log.Info0 = origLogInfo0;
		Log.Print = origLogPrint;
		Log.GetMsgCache = origGetMsgCache;
	}

	public function Error(category:String, message:Object) : Void
	{
		LogMsg(ERROR, category, message);
		origLogError(category, message);
	}

	public function Warn(category:String, message:Object) : Void
	{
		LogMsg(WARN, category, message);
		origLogWarning(category, message);
	}

	public function Info2(category:String, message:Object) : Void
	{
		LogMsg(INFO2, category, message);
		origLogInfo2(category, message);
	}

	public function Info1(category:String, message:Object) : Void
	{
		LogMsg(INFO1, category, message);
		origLogInfo1(category, message);
	}
	
	public function Info0(category:String, message:Object) : Void
	{
		LogMsg(INFO0, category, message);
		origLogInfo0(category, message);
	}

	public function Print(level:Number, category:String, message:Object) : Void
	{
		LogMsg(PRINT, category, message);
		origLogPrint(level, category, message);
	}

	private function LogMsg(logSeverity:Number, category:String, message:Object) : Void
	{
		var Msg:Array = new Array();

		// Add elements to the Msg Array
		Msg.push(logSeverity, category, message);
		// Add Msg to existing Log
		MsgLog.push(Msg);
		MsgCache.push(Msg);
	}
	
	public function GetMsgCache():Array
	{
		var msgArray:Array = new Array();
		var msgStr:String;

		while (MsgCache.length > 0) {
			var tObj:Object = MsgCache.pop();

			var msgSeverity = tObj[0];
			if (msgSeverity == ERROR) {
				msgStr = " ERROR: " + tObj[1] + " " + tObj[2];
			} else if (msgSeverity == WARN) {
				msgStr = " WARNING: " + tObj[1] + " " + tObj[2];
			}
			msgArray.push(msgStr);
		}

		return msgArray;
	}
}