'
'	EdzUpNetworking.bmx - Copyright (C)EdzUp
'	Programmed by Ed 'EdzUp' Upton
'

SuperStrict
Import BRL.LinkedList
Import BRL.System
Import BRL.Socket
Import BRL.SocketStream
Import BRL.Retro
Import MaxGUI.MaxGUI
Import BRL.EventQueue
Import BRL.PNGLoader

'this is the type used for all things that relate to standard stuff that is handled in the network.
Type NetworkType
	'this will be there for the server side stuff, all client side things will be handled through monkeys
	Field PacketHeader:String = "<ENB>"			'this shows there is a beginning to the packet
	Field PacketFooter:String = "<ENE>"			'this is for the end of each packet
	Field Connected:Byte = False					'true if this machine is connected to the network
	Field LocalID:Long = 0						'this is the local ID for this server or client
	Field LocalPort:Int						'this is the local port
	Field LocalSocket:TSocket					'this is the actual socket that will be setup for the networking
	Field Hosting:Byte = False
	Field PlayerCount:Long
	Field PlayerCountMaximum:Long
	Field NetworkMath:NetworkMathType = New NetworkMathType			'this handles all the conversion
	Field GameTime:GameTimeType = New GameTimeType				'James L Boyd's game time system (real millisecs)
	
	'================================================================================
	Method StartServer:Byte( Port:Int )
		'this will start the server and set it up to listen on a certain port
		GameTime.ResetGameTime()
		PlayerCount =0
		PlayerCountMaximum = 64
		
		'this will bind a socket and begin listening
		LocalSocket = CreateUDPSocket()
		If Not BindSocket( LocalSocket, Port )
			Print "Could not bind socket"
			CloseSocket LocalSocket
			
			Return False
		EndIf
		
		Hosting = True
		LocalID = 0
		LocalPort = Port
		Connected = True
'		EdzUpNetwork_AccessLoginData()
	
		Return True		
	End Method

	'================================================================================
	Method Shutdown()
		If Connected = True
			'there is no point trying to close something that isnt connected
			CloseSocket( LocalSocket )
		EndIf
	End Method

	'================================================================================
	Method Update()
		If Hosting = True
			'server system
		Else
			'client system
		EndIf
	End Method
End Type

Type NetworkMathType
	Field CompressBank:TBank = CreateBank( 4 )		'used in conversion routines

	'------------------------------------------------------------------------------------------------------------------------
	Method IntToStr:String( Num:Int )
		Local Temp:String = ""
		Local BP:Int = 0	
	
		PokeInt CompressBank, 0, Num 
	
		For BP = 0 To 3
			Temp = Temp + Chr$( PeekByte( CompressBank, BP ) )
		Next
	
		Return Temp
	End Method

	'------------------------------------------------------------------------------------------------------------------------
	Method FloatToStr:String( num:Float )
		'-=-=-=Convert a floating point number To a 4 Byte String
		Local st:String = ""
		Local i:Int = 0
	
		PokeFloat CompressBank, 0, num
	
		For i = 0 To 3 
			st$ = st$ + Chr$( PeekByte( CompressBank, i ) )
		Next 
	
		Return st$
	End Method

	'------------------------------------------------------------------------------------------------------------------------
	Method StrToInt:Int( st:String )
		'-=-=-=Take a 4 Byte String And turn it back into a floating point #.
		Local i:Int =0 
	
		For i = 0 To 3
			PokeByte CompressBank, i, Asc( Mid$( st, i+1, 1 ) )
		Next
	
		Return PeekInt( CompressBank, 0 )
	End Method

	'------------------------------------------------------------------------------------------------------------------------
	Method StrToFloat:Float( st:String )
		Local I:Int =0
	
		For i=0 To 3
			PokeByte CompressBank, i, Asc( Mid$( st, i+1, 1 ) )
		Next

		Return PeekFloat( CompressBank, 0 )
	End Method
End Type

Type GameTimeType
	' -----------------------------------------------------------------------------
	' These globals MUST be included in your code!
	'James L Boyd code
	' -----------------------------------------------------------------------------
	Field GT_Start:Long		'Star of game time
	Field GT_Last:Int			' Last INTEGER value of MilliSecs ()
	Field GT_Current:Long		' LONG value updated by MilliSecs ()

	' -----------------------------------------------------------------------------
	' ResetGameTime MUST be called at the start of your game, or at least
	' before you first try to use the GameTime function...
	' -----------------------------------------------------------------------------

	' You can also call this to reset GameTime on reaching a new level, starting
	' a new game after the player dies, etc...
	Method ResetGameTime:Int ()
		GT_Current	= 0
		GT_Start		= Long (MilliSecs ())
		GT_Last		= GT_Start
	End Method

	' -----------------------------------------------------------------------------
	' Returns milliseconds from when ResetGameTime was called...
	' -----------------------------------------------------------------------------
	Method GameTime:Long ()
		Local msi:Int = MilliSecs ()

		GT_Current = GT_Current + (msi - GT_Last)
		GT_Last = msi
	
		Return GT_Current
	End Method
End Type