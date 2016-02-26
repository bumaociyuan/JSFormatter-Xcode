# JSFormatter-Xcode
Xcode plug to format js html css files using [js-beautify](https://github.com/beautify-web/js-beautify)

##Requirement
* [Node.js](https://nodejs.org/)
* [js-beautify](https://github.com/beautify-web/js-beautify)
* Xcode 6.0+ on OS X 10.10+.

##Screenshot
![image](https://raw.githubusercontent.com/bumaociyuan/JSFormatter-Xcode/master/screenshot.gif)

##Support Extension
* js
* css
* html\htm
* json

##Installation

#### Build from source code 

* Build the Xcode project. The plug-in will automatically be installed in ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins.
* Relaunch Xcode.

To uninstall, just remove the plugin from ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins and restart Xcode.

#### Install Via [Alcatraz](http://alcatraz.io/)

* Install Alcatraz.
* Search `JSFormatter` click the icon on left to install.

##Get Xcode UUID
`defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`

##How does it work?
All the commands are in the menu `Edit` > `JSFormatter`.
Click `Format Active JS File` to format 

##Shortcut
You can create keyboard shortcuts for the menu items in the [Keyboard Preferences](http://support.apple.com/kb/ph3957) of OS X System Preferences.

##Thanks
Thanks to the [BBUncrustifyPlugin-Xcode](https://github.com/benoitsan/BBUncrustifyPlugin-Xcode) since I used some code from it.

##TODO

1. ~~Install via Alcatraz~~
2. Add `Format Selected JS Files`
3. Add `Format Selected JS Lines`
4. ~~Xcode 7 Support~~

##License
The MIT License (MIT)
