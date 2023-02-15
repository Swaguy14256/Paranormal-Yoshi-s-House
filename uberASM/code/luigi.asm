!FreeSpace = $3D8000 

org !FreeSpace

db "ST","AR"			
dw End-Start-$01		
dw End-Start-$01^$FFFF	

Start:
incbin Luigi.bin ;replace this for your GFX name
End:
