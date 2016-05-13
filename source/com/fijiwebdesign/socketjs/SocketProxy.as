/**
 * A Flex Socket Proxy for JavaScript
 * @author gabe@fijiwebdesign.com
 */

package com.fijiwebdesign.socketjs
{
	public class SocketProxy
	{
		
		import flash.events.*;
		import flash.net.Socket;
		import flash.external.ExternalInterface;
		
		public var scope:String = "";
		private var _socket:Socket;
		private var _domain:String;
		private var _port:Number;
		
		public var debug:Boolean = false;
		
		public function SocketProxy(jsScope:String = "", _debug:Boolean = false)
		{
			debug = _debug;
			log('creating new socket for '+jsScope);
			scope = jsScope ? jsScope+"." : jsScope;
			_socket = new Socket();
			initialize();
		}
		
		private function initialize() : void 
		{
			
			// conneced to socket
			_socket.addEventListener(Event.CONNECT, function(e : Event) : void { 
					log("Connected to server");
					ExternalInterface.call(scope + "connected");
				}
			);

			// disconnected
			_socket.addEventListener(Event.CLOSE, function(e : Event) : void {
					log("Disconnected from server");
					ExternalInterface.call(scope + "disconnected");				
				}
			);
				

			// IO ERROR
			_socket.addEventListener(IOErrorEvent.IO_ERROR, function(e : IOErrorEvent) : void {
					log("IOERROR : " +  e.text);
					ExternalInterface.call(scope + "ioError", e);
				}
			);

			// SECURITY ERROR
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e : SecurityErrorEvent) : void {
					log("SECURITY ERROR : " +  e.text);
					ExternalInterface.call(scope + "securityError", e);
				}
			);

			// receive data
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, function(e : ProgressEvent) : void {
						var msg : String = _socket.readUTFBytes(_socket.bytesAvailable);
						log("Received : " + msg );
						ExternalInterface.call(scope + "receive", escape(msg));
					}
				);
		
			
			// connect(host, port) 
			log('registering '+scope + "connect");
			ExternalInterface.addCallback(scope+"connect", connect);	    	
			
			// disconnect() 
			log('registering '+scope + "close");
			ExternalInterface.addCallback(scope+"close", close);	    				
			
			// write() 
			log('registering '+scope + "write");
			ExternalInterface.addCallback(scope+"write", write);
			
			/// we are ready
			log('calling '+scope + "ready()");
			ExternalInterface.call("setTimeout", scope + "ready()");	
			
		}
		
		/**
	     * Connect to new _socket server
	     * @param host The host the _socket server resides on
	     * @param port The _socket servers port
	     */
	    public function connect(host : String, port : String) : void {
	    	log("Connecting to socket server at " + host + ":" + port);
			_socket.connect(host, Number(port));
	    }
	    
	    /**
	     * Disconnect the _socket
	     */
	    public function close() : Boolean {
	    	if (_socket.connected) {
	    	   	log("Closing current connection");
				_socket.close();
				return true;
			} else {
				log("Not Connected!");
				return false;
			}
	    }
	
	    /**
	     * Write string to the _socket
	     */
	    public function write(msg:String) : Boolean {
	    	if (_socket.connected) {
		    	log("Writing '" + msg + "' to server");
				_socket.writeUTFBytes(msg)
				_socket.flush();
				return true;
			} else {
				log("Cannot write to server because there is no connection!");
				return false;		
			}
	    }
	    
	    public function log(msg : String): void {
	    	if (debug) {
	    		trace(msg);
	    	}
	    }   

	}
}

