Const MAP_WIDTH = 5
Const MAP_HEIGHT = 6
Const MAP_SIZE = MAP_WIDTH * MAP_HEIGHT
Const MAX_COINS = 20
Const MAX_DECOS = 20
Const SHOW_COINS = 0
Const HIDE_COINS = 1
Const LIST_WORDS_SIZE = 32

Dim Shared lP (LIST_WORDS_SIZE) As String

Function scrOffset (nPant As Integer) As Integer
'if ((n_pant < 5) || ((n_pant % 5) == 0 && n_pant != 5) || ((n_pant % 5) == 4 && n_pant != 29)) return 0; else 	return 32;
	If nPant < 5 Or ((nPant Mod 5) = 0 And nPant <> 5) Or ((nPant Mod 5) = 4 And nPant <> 29) Then scrOffset = 0 Else scrOffset = 32
End Function 

Sub stringToArray (in As String)
	Dim As Integer m, index, i1, i2, found
	Dim As String character, curWord
	
	For m = 0 To LIST_WORDS_SIZE: lP (m) = "": Next m
	in = Trim (in): If in = "" Then Exit Sub
		
	index = 0: curWord = "": in = in + " "
	
	For m = 1 To Len (in)
		character = Ucase (Mid (in, m, 1))
		If Instr (" " & Chr (9) & ",<=>;()", character) Then
			If curWord <> "" Then
				'? "[" & curWord & "] ";
				lP (index) = curWord
				index = index + 1
				If index >= LIST_WORDS_SIZE Then Exit For
				curWord = ""
			End If
			If Instr (" " & Chr (9), character) = 0 Then
				lP (index) = character
				index = index + 1
				If index >= LIST_WORDS_SIZE Then Exit For
			End If
		Else
			curWord = curWord & character
		End If
	Next m
	'for m = 0 to index:Print lP (m); " ";:next m: Print
	'?
End Sub

Type TypeDecoration
	x As uByte
	y As uByte
	t As uByte
End Type

Dim As Integer xp, yp, xt, yt, x, y, i, j, fi, fo, fd, fr, n_pant, capture
Dim As uByte bi, bo
Dim As uByte decosOn (MAP_SIZE - 1)
Dim As TypeDecoration decorations (MAP_SIZE - 1, 1, MAX_COINS - 1)
Dim As uByte origDecosOn (MAP_SIZE - 1)
Dim As TypeDecoration origDecorations (MAP_SIZE - 1, MAX_DECOS - 1)
Dim As String linea

? "Don't use this, you don't need this. I just needed to convert some stuff in"
? "the original Ramiro 2 map. I'm in the process of porting it from MK1 4.7 to MK2"
?
? "Reading mapa.map, orig.spt, writing mapa_f.map, cruces.spt"

Kill "mapa_f.map"
Kill "cruces.spt"

' Good practice, unneeded.
For i = 0 TO MAP_SIZE - 1
	decosOn (i) = 0
	origDecosOn (i) = 0
Next i

' Open files
fi = FreeFile
Open "mapa.map" For Binary As #fi
fo = FreeFile
Open "mapa_f.map" For Binary As #fo
fd = FreeFile
Open "cruces.spt" For Output As #fd
fr = FreeFile
Open "orig.spt" For Input As #fr

' Parse original decorations
n_pant = 0
capture = 0
While Not Eof (fr)
	Line Input #fr, linea
	linea = Trim (linea, Any chr (32) + chr (9))
	stringToArray (linea)
	Select Case Ucase (lP (0))
		Case "ENTERING"
			' 0        1      2
			' ENTERING SCREEN XX
			If lP (1) <> "ANY" And lP (1) <> "GAME" Then
				n_pant = Val (lP (2))
				'? "DEBUG, screen set to " & n_pant
				capture = 1
			End If
		Case "IF"
			'? "IF->" & linea
		
			If lP (1) = "TRUE" Then
				If capture = 1 Then
					'? "DEBUG, IF TRUE in ENTERING SCREEN"
					capture = 2
				Else 
					'? "DEBUG, IF TRUE WHEN capture = " & capture
				End If
			End If				
		Case "SET"
			' 0   1    234 56 7 8
			' SET TILE (x, y) = t
			If lP (1) = "TILE" Then
				If capture = 2 Then
					origDecorations (n_pant, origDecosOn (n_pant)).x = Val (lP (3))
					origDecorations (n_pant, origDecosOn (n_pant)).y = Val (lP (5))
					origDecorations (n_pant, origDecosOn (n_pant)).t = Val (lP (8))
					'? "DEBUG, " & linea & ", (" & origDecorations (n_pant, origDecosOn (n_pant)).x & ", " & origDecorations (n_pant, origDecosOn (n_pant)).y & ") = " & origDecorations (n_pant, origDecosOn (n_pant)).t
					origDecosOn (n_pant) = origDecosOn (n_pant) + 1
				Else
					'? "DEBUG, SET TILE WHEN capture = " & capture
				End If					
			End If
	End Select
Wend	
Close #fr

' Write script header
Print #fd, "# Decorations special: Crosses."
Print #fd, "# To be added manually."
Print #fd, " "

' Read & fix
For y = 0 To MAP_HEIGHT * 10 - 1
	For x = 0 To MAP_WIDTH * 15 - 1
		' Screen #
		xp = x \ 15
		yp = y \ 10
		n_pant = xp + yp * MAP_WIDTH
		xt = x Mod 15
		yt = y Mod 10
		
		' Read 
		Get #fi, , bi
		
		' Fixed rules, change.
		If bi = 13 Then
			bi = 0
			decorations (n_pant, SHOW_COINS, decosOn (n_pant)).x = xt
			decorations (n_pant, SHOW_COINS, decosOn (n_pant)).y = yt
			decorations (n_pant, SHOW_COINS, decosOn (n_pant)).t = 13
			decorations (n_pant, HIDE_COINS, decosOn (n_pant)).x = xt
			decorations (n_pant, HIDE_COINS, decosOn (n_pant)).y = yt
			decorations (n_pant, HIDE_COINS, decosOn (n_pant)).t = 0
			decosOn (n_pant) = decosOn (n_pant) + 1
		End If
		
		'If n_pant >= 15 Then bo = bi + 32 Else bo = bi
		bo = bi + scrOffset (n_pant)
		
		
		' Add decorations
		' A bit slow, but... Meh, there's four cores in this box.
		If origDecosOn (n_pant) > 0 Then
			For j = 0 To origDecosOn (n_pant) - 1
				If origDecorations (n_pant, j).x = xt And origDecorations (n_pant, j).y = yt Then
					bo = origDecorations (n_pant, j).t
					'? "DECO @ [" & n_pant & "]-(" & xt & ", " & yt & ") => " & bo
				End If
			Next j
		End If
		
		' Write
		Put #fo, , bo
	Next x
Next y

Close #fi, #fo

For n_pant = 0 To MAP_HEIGHT * MAP_WIDTH - 1	
	If decosOn (n_pant) > 0 Then
		Print #fd, "# ---------"
		Print #fd, "# SCREEN " & Trim (Str (n_pant))
		Print #fd, "# ---------"
		Print #fd, " "
		Print #fd, "# SHOW_COINS"
		Print #fd, "		DECORATIONS"
		For i = 0 To decosOn (n_pant) - 1
			Print #fd, "			" & Trim (Str (decorations (n_pant, SHOW_COINS, i).x)) & ", " & Trim (Str (decorations (n_pant, SHOW_COINS, i).y)) & ", " & Trim (Str (decorations (n_pant, SHOW_COINS, i).t))
		Next i
		Print #fd, "		END"
		Print #fd, " "
		Print #fd, "# HIDE_COINS"
		Print #fd, "		DECORATIONS"
		For i = 0 To decosOn (n_pant) - 1
			Print #fd, "			" & Trim (Str (decorations (n_pant, HIDE_COINS, i).x)) & ", " & Trim (Str (decorations (n_pant, HIDE_COINS, i).y)) & ", " & Trim (Str (decorations (n_pant, HIDE_COINS, i).t))
		Next i
		Print #fd, "		END"
		Print #fd, " "
	End If
Next n_pant

Close #fd
