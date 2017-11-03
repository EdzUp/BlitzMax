'
'	NetworkTest.bmx - Copyright (C)EdzUp
'	Programmed by Ed 'EdzUp' Upton
'

Import "EdzUpNetworking.bmx"

Global Network:NetworkType = New NetworkType

If ( Network.StartServer( 8088 ) = False )
	Print "FAILED:couldnt start server"
	End
Else
	Print "SUCCESS:server started perfectly"
EndIf

Network.Shutdown()
Delay( 100 )
End