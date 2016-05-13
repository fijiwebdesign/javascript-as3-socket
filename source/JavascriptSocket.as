package {
	
	import flash.external.ExternalInterface;
 	import com.fijiwebdesign.socketjs.SocketProxy;
 	import flash.system.Security;

	import flash.display.Sprite;

	public class JavascriptSocket extends Sprite
	{
		
		public static var sockets:Object = {};
		
		public function JavascriptSocket()
		{
			
			ExternalInterface.addCallback('createSocketProxy', createSocketProxy);
 			ExternalInterface.addCallback('loadPolicyFile', loadPolicyFile);
 			
 			ExternalInterface.call('setTimeout', 'SocketManager.loaded()');
			
		}
		
		public function createSocketProxy(jsScope:String, debug:Boolean = false) : Boolean
 		{
 			sockets[jsScope] = new SocketProxy(jsScope, debug);
 			return true;
 		}
 		
 		public function loadPolicyFile(policyFileURL:String) : void 
 		{
 			
 			trace('loadPolicyFile('+policyFileURL+');');
			// eg: xmlsocket://url:port
			Security.loadPolicyFile(policyFileURL);

			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			ExternalInterface.call('setTimeout', 'SocketManager.loadedPolicyFile()');
			
		}
		
	}
}
