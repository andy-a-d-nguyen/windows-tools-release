﻿$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

$MYSQL_PACKAGE=(Get-ChildItem "C:\\var\\vcap\\packages\\mysql\\mysql-*").FullName

$mtx = New-Object System.Threading.Mutex($false, "PathMutex")

if (!$mtx.WaitOne(300000)) {
  throw "Could not acquire PATH mutex"
}

$OldPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
$AddedFolder="$MYSQL_PACKAGE\\bin;"

if (-not $OldPath.Contains($AddedFolder)) {
  $NewPath=$OldPath+';'+$AddedFolder
  Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
}

$mtx.ReleaseMutex()

