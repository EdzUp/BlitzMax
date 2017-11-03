'
'	EdzUpNetworkingServer.bmx - Copyright ©EdzUp
'	Programming by Ed 'EdzUp' Upton
'

'this handles all the Server side things for the networking system
Type NetworkServerType
	NetworkEntry:NetworkingType = New NetworkingType
	Field PlayerCount:Int						'this is the current player count for this server, each new connection add 1
	Field PlayerCountMaximum:Int				'this is the maximum number of connections this server will allow

	Method StartServer:Byte( Port:Int )
	End Method
	
	Method Update()
		'this will update the server allowing the system to work, transfering messages between clients
		'and authenticating users.
	End Method
	
	Method Shutdown()
		'this will shutdown the server
	End Method
End Type
