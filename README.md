# javascript-as3-socket

Pure JavaScript sockets client in the browser using flash.net.Socket

The JavaScript client will include the Flash SWF that proxies the socket for JavaScript. No ActionScript experience is required. 
JavaScript-as3-sockets requires Flash with as3 support. 

Usage of Flash is lower than it used to be, however, you can still make use of pure sockets and fallback to websockets or ajax for specific applications. 

About
-----

WebSockets allows a socket connection in the browser but not a pure TCP socket. 
JavaScript-AS3-Socket allows a connection to any pure TCP socket or even UDP socket connection. 
You can connect directly to a mail server, bitTorrent, even SSH, directly from the browser.

Documentation
-------------

* Include the `release/javascript-as3-socket` directory and it's contents in your JavaScript project.
* Eg: You can create a directory structure such as `js/javascript-as3-socket/*` in your project. 
* Include the JS files in your HTML. `javascript-as3-socket/js/Socket.js` and `javascript-as3-socket/js/swfobject.js` 
* Make sure you also have `javascript-as3-socket/JavascriptSocket.swf` and `javascript-as3-socket/expressInstall.swf`. 
* Use the global `Socket` constructor to create a new socket connection:

```
var socket = new Socket({
  'ready', function() {
    // called when socket is ready to receive and send data
    socket.send('some text data')
    socket.send(JSON.stringify({ 'username' : 'me', 'password' : 'xxx' })) // send json
  },
  'receive', function(data) {
    // called when socket received data
    console.log('Received data from socket', data)
  },
  'connected', function() { /* called when socket is connected to remote server */ },
  'disconnected', function() { /* called when socket is disconnected */ },
  'securityError', function() { /* called if there was a security error (cross domain) */ },
  'ioError', function() { /* called when there was an error receiving or sending data */ }
})

socket.connect('api.example.com', '8080') // connect to server and port 

window.addEventListener('unload', function() {
  socket.disconnect() 
})
```






