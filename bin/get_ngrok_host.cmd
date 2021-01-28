@if (@CodeSection == @Batch) @then
@echo off & setlocal

set "URL=http://localhost:4040/api/tunnels/command_line"

for /f "delims=" %%I in ('cscript /nologo /e:JScript "%~f0" "%URL%"') do set "NGROKHOST=%%I"

echo %NGROKHOST%

goto :EOF
@end // end Batch / begin JScript hybrid code

var htmlfile = WSH.CreateObject('htmlfile'),
    x = WSH.CreateObject("Microsoft.XMLHTTP");

x.open("GET",WSH.Arguments(0),true);
x.setRequestHeader('User-Agent','XMLHTTP/1.0');
x.send('');
while (x.readyState != 4) WSH.Sleep(50);

htmlfile.write('<meta http-equiv="x-ua-compatible" content="IE=9" />');
var obj = htmlfile.parentWindow.JSON.parse(x.responseText);
htmlfile.close();

WSH.Echo(obj.public_url);