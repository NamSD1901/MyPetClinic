$ErrorActionPreference = "Stop"

$oldName = "MyNewApp"
$newName = "MyPetClinic"

Write-Host "1. Deleting bin and obj directories..."
Get-ChildItem -Path . -Include bin,obj -Recurse -Directory | Remove-Item -Recurse -Force

Write-Host "2. Replacing text contents..."
$files = Get-ChildItem -Path . -File -Recurse | Where-Object { $_.Extension -in ".cs", ".cshtml", ".csproj", ".slnx" }
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    if ($content.Contains($oldName)) {
        $content = $content.Replace($oldName, $newName)
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated $($file.FullName)"
    }
}

Write-Host "3. Renaming files..."
$filesToRename = Get-ChildItem -Path . -File -Recurse | Where-Object { $_.Name -match $oldName }
foreach ($file in $filesToRename) {
    $newFileName = $file.Name -creplace $oldName, $newName
    Rename-Item -Path $file.FullName -NewName $newFileName
    Write-Host "Renamed file $($file.Name) to $newFileName"
}

Write-Host "4. Renaming directories..."
$dirs = Get-ChildItem -Path . -Directory -Recurse | Where-Object { $_.Name -match $oldName } | Sort-Object -Property @{Expression={$_.FullName.Length}; Descending=$true}
foreach ($dir in $dirs) {
    $newDirName = $dir.Name -creplace $oldName, $newName
    Rename-Item -Path $dir.FullName -NewName $newDirName
    Write-Host "Renamed directory $($dir.Name) to $newDirName"
}

Write-Host "Done!"
