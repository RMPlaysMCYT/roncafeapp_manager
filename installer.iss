[Setup]
; Basic app info
AppName=Ron Cafe App Manager
AppVersion=1.0.0
AppPublisher=Ronnel Mitra
; Default installation folder (usually C:\Program Files\RonCafeAppManager)
DefaultDirName={autopf}\RonCafeAppManager
; Where the installer.exe will be saved after compiling
OutputDir=Output
; The name of the final installer file
OutputBaseFilename=RonCafeAppManager_Installer
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; This grabs EVERYTHING from your Flutter release folder and packs it inside the installer
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Creates shortcuts in the Start Menu and on the Desktop
; NOTE: Ensure 'roncafeapp_manager.exe' matches the actual name of your compiled Flutter exe!
Name: "{autoprograms}\Ron Cafe App Manager"; Filename: "{app}\roncafeapp_manager.exe"
Name: "{autodesktop}\Ron Cafe App Manager"; Filename: "{app}\roncafeapp_manager.exe"; Tasks: desktopicon

[Run]
; Gives the user the option to launch the app immediately after installation
Filename: "{app}\roncafeapp_manager.exe"; Description: "{cm:LaunchProgram,Ron Cafe App Manager}"; Flags: nowait postinstall skipifsilent