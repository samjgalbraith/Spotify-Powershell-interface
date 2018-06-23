param(
    [switch] $Replace,
    [switch] $Remove
)

$lockTaskName = "Spotify pause when computer locks"

function GetScheduledTaskXmlString()
{
    $taskXml = [xml]$(Get-Content -Path "$PSScriptRoot\Scheduled-task-Spotify-pause-on-lock.xml")
    $taskXml.Task.Principals.Principal.UserId = [string]$(whoami)
    $taskXml.Task.Actions.Exec.Arguments = "$PSScriptRoot\Spotify.ps1 Pause -DontStartSpotify"
    $taskXml.Task.RegistrationInfo.URI = "\$lockTaskName"
    $taskXml.OuterXml
}

if($Replace -or $Remove)
{
    echo "Removing any existing scheduled task for Spotify pause when computer is locking."
    Unregister-ScheduledTask -TaskName $lockTaskName -ErrorAction Ignore
}

if($Remove)
{
    return
}
elseif(-not $(Get-ScheduledTaskInfo -TaskName $lockTaskName -ErrorAction Ignore))
{
    echo "Creating new scheduled task for Spotify pause when computer is locking"
    Register-ScheduledTask -TaskName $lockTaskName -Xml $(GetScheduledTaskXmlString)
}
else
{
    echo "Spotify pause when idle task already exists. Nothing to do."
}
