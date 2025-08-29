;
;	getReport.au3
;
; ------------------------------------------------------------------------------

#include <IE.au3>

; match any substring in the window title (mode '2')
AutoItSetOption("WinTitleMatchMode", 2)

;$application = "C:\Program Files\Mozilla Firefox\firefox.exe"
$url = "https://nl.infothek-sptk.com/isps/infothek?1043"

$oIE = _IECreate("about:blank", 1, 1, 1, 1)
_IENavigate($oIE, $url);
; _IELoadWait($oIE)

Sleep(8000)

; $oLinks = _IELinkGetCollection($oIE)
; Local $iNumLinks = @extended
; Local $sTxt
; MsgBox(0, "Link Info", $iNumLinks & " links found", 2)
; For $oLink In $oLinks
    ; If StringInStr($oLink.innerText, "heppenheim erleben") Then
        ; MsgBox(0, "Link Info", $oLink.href & " " & $oLink.innerText, 2)
        ; _IELinkClickByText($oIE, $oLink.innerText)
		; ExitLoop
	; EndIf
 	; $sTxt &= $oLink.innerText & @CRLF
; Next
; MsgBox(0, "Links", $sTxt)
; _IELinkClickByText($oIE, "heppenheim erleben")


; $Search = _IEGetObjByName($oIEFrame,"uname")
; $Search = _IEGetObjByName($oIEFrame,"upwd")
; _IEPropertySet($Search, 'innerText','blah')
; Local $oInputs = _IETagNameGetCollection($oIEFrame, "Input")
; For $oInput In $oInputs
    ; If $oInput.name = 'uname' Then $oInput.value = '05712164'
    ; If $oInput.name = 'upwd' Then $oInput.value = 'Password'
; Next

; *** Login
$oIEFrame = _IEFrameGetObjByName($oIE, "body_frame")

$oElements = _IETagNameAllGetCollection($oIEFrame)
For $oElement In $oElements
	if $oElement.id = '_ok' Then
        _IEAction($oElement, 'click')
		ExitLoop
	EndIf
Next

Sleep(1000)
While _IEPropertyGet($oIE, "busy") = True
    Sleep(50)
WEnd
Sleep(1000)

; *** click dienstrooster
$oIEFrame = _IEFrameGetObjByName($oIE, "bottom_frame")

$oElements = _IETagNameAllGetCollection($oIEFrame)
For $oElement In $oElements
	if $oElement.innerhtml = 'Dienstrooster' Then
        _IEAction($oElement, 'click')
		ExitLoop
	EndIf
Next

Sleep(1000)
While _IEPropertyGet($oIE, "busy") = True
    Sleep(50)
WEnd
Sleep(1000)

; *** send email
$oIEFrame = _IEFrameGetObjByName($oIE, "activity")

; ** set enddate
$oForm = _IEFormGetObjByName($oIEFrame, "print")
$oSelect = _IEFormElementGetObjByName($oForm, "enddate")
$i = 0
$oOptions = $oSelect.options
For $oOption In $oOptions
	$i = $i + 1
Next 
_IEFormElementOptionSelect($oSelect, $i-1, 1, "byIndex")

; ** check email address
$oCheckbox = _IEFormElementGetObjByName($oForm, "sendemail", 0)
$oCheckbox.checked = True

; ** click ok
; $oElements = _IETagNameAllGetCollection($oIEFrame)
; For $oElement In $oElements
	; if $oElement.innerhtml = 'OK' Then
        ; _IEAction($oElement, 'click')
		; ExitLoop
	; EndIf
; Next


If @error <> 0 Then
	msgBox(0, "Error", "shoot!")
EndIf


; _IEQuit($oIE)


