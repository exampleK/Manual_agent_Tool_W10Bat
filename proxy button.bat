@echo off
setlocal

ver | find "10." > nul
if errorlevel 1 (
   echo 仅支持Windows 10及以上版本的操作系统。
   goto :eof
)

set proxy_server=127.0.0.1:8080

for /f "usebackq delims=" %%i in (`powershell -Command "$RegKey='HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings';$ProxyEnabled=(Get-ItemProperty -Path $RegKey).ProxyEnable;write-output $ProxyEnabled"`) do (
    set "result=%%i"
)
if %result% equ 1 (
    echo 当前代理的状态为:Open
) else (
    echo 当前代理的状态为:Close
)
echo 请输出你的操作：（回车键则会切换状态，任意字符则会放弃执行）
set /p input=
if not defined input (
    if %result% equ 1 (
        echo 关闭代理...
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f > nul
        reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f > nul
        ) else (
            echo 开启代理...
            reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f > nul
            reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d %proxy_server% /f > nul
        )
) else (
    echo 天亮了，昨晚是个平安夜。
)


echo 操作完成，请按下回车键继续...
pause > nul
goto :eof