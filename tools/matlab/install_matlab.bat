start /wait C:\matlab_2018a_install\setup.exe -destinationFolder C:\matlab_2018a -fileInstallationKey 09806-07443-53955-64350-21751-41297 -agreeToLicense yes -outputFile C:\matlab_2018a_install\matlab_install.log -mode silent -activationPropertiesFile C:\matlab_2018a_install\license_standalone.lic -setFileAssoc false -desktopShortcut false -startMenuShortcut false /S
xcopy C:\matlab_2018a_install\netapi32.dll C:\matlab_2018a\bin\win64
xcopy C:\matlab_2018a_install\license_standalone.lic C:\matlab_2018a\licenses
echo matlab 2018a install finished!