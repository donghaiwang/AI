:: 在当前目录解压并安装matlab，安装的目录为C:\matlab_2018a
:: TODO:  执行xcopy之前需要等待matlab安装程序结束
7z x matlab_2018a_install.rar
start /wait matlab_2018a_install\setup.exe -destinationFolder C:\matlab_2018a -fileInstallationKey 09806-07443-53955-64350-21751-41297 -agreeToLicense yes -outputFile matlab_2018a_install\matlab_install.log -mode silent -activationPropertiesFile matlab_2018a_install\license_standalone.lic -setFileAssoc false -desktopShortcut false -startMenuShortcut false /S
xcopy matlab_2018a_install\netapi32.dll C:\matlab_2018a\bin\win64
xcopy matlab_2018a_install\license_standalone.lic C:\matlab_2018a\licenses
echo matlab 2018a install finished!