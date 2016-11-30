$SPOTIFY_PLAYPAUSE =917504
$SPOTIFY_MUTE = 524288
$SPOTIFY_STOP = 851968
$SPOTIFY_PREVIOUS = 786432
$SPOTIFY_NEXT = 720896

function StartSpotifyIfNeeded()
{
    $programName = "Spotify"
    $spotifyPath = Join-Path -Path $env:USERPROFILE -ChildPath "AppData\Roaming\Spotify\Spotify.exe"
    $isRunning = (Get-Process | Where-Object { $_.Name -eq $programName }).Count -gt 0

    if (-not $isRunning){
        & $spotifyPath
        Start-Sleep 2
    }
}

function NextSong(){

    SendSpotifyCommand($SPOTIFY_NEXT);

}

function RestartSong(){

    SendSpotifyCommand($SPOTIFY_PREVIOUS);

}

function PreviousSong(){

    SendSpotifyCommand($SPOTIFY_PREVIOUS);
    SendSpotifyCommand($SPOTIFY_PREVIOUS);

}

function Stop(){

    SendSpotifyCommand($SPOTIFY_STOP);

}

function Mute(){

    SendSpotifyCommand($SPOTIFY_MUTE);

}

function PlayPause(){

    SendSpotifyCommand($SPOTIFY_PLAYPAUSE);

}

function SendSpotifyCommand($command){
$spotifyProcess = Get-Process | Where-Object {$_.MainWindowTitle -and $_.Name -eq "Spotify"} | Select-Object Id,Name,MainWindowHandle,MainWindowTitle
#Store the C# signature of the SendMessage function. 
$signature = @"
[DllImport("user32.dll")]
public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);
"@
#Add the SendMessage function as a static method of a class
$SendMessage = Add-Type -MemberDefinition $signature -Name "Win32SendMessage" -Namespace Win32Functions -PassThru
#Invoke the SendMessage Function
$SendMessage::SendMessage($spotifyProcess.MainWindowHandle, 0x0319, 0, $command)

}

function updateToast(){
# create toast template TO xml
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[xml]$toastXml =  ([Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText04)).GetXml()

$songTitle = Get-Process |where {$_.mainWindowTitle -and $_.name -eq "Spotify"} | select mainwindowtitle

        $artist = $songTitle.MainWindowTitle.Split("-")[0]
        $song = $songTitle.MainWindowTitle.Split("-")[1]

        Write-Host $songTitle.MainWindowTitle

        # message to show on toast
        $stringElements = $toastXml.GetElementsByTagName("text")
        $stringElements[0].AppendChild($toastXml.CreateTextNode("Spotify")) > $null
        $stringElements[1].AppendChild($toastXml.CreateTextNode($artist)) > $null
        $stringElements[2].AppendChild($toastXml.CreateTextNode($song)) > $null


        # no image
        $imageElements = $toastXml.GetElementsByTagName("image")
        $imageElements[0].src = "file:///you_can_personalize the toast icon if you want" + ""

        # convert from System.Xml.XmlDocument to Windows.Data.Xml.Dom.XmlDocument
        $windowsXml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $windowsXml.LoadXml($toastXml.OuterXml)

        $APP_ID = "hoge"
        $shortcutPath = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\Microsoft\Windows\Start Menu\Programs\hoge.lnk";

        # send toast notification
        $toast = New-Object Windows.UI.Notifications.ToastNotification ($windowsXml)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($APP_ID).Show($toast)
       
        
    }

$option=$args[0]

StartSpotifyIfNeeded

switch ($option) 
    { 
        "Play" {PlayPause} 
        "Pause" {PlayPause} 
        "Replay" {
            RestartSong
            Start-Sleep 1
            updateToast
        } 
        "Mute" {Mute} 
        "Next" {
            NextSong
            Start-Sleep 1
            updateToast
        }
        "Previous"{
            PreviousSong 
            Start-Sleep 1
            updateToast
        } 
        default {"Wrong command"}
    }

    
