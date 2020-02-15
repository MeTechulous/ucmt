

# $PSTRepo = Read-Host -Prompt "What directory is data being saved?"
$PSTRepo = "C:\PSTRepo"
mkdir $PSTRepo

New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS -ErrorAction SilentlyContinue

Write-Host = "Checking HKU accounts for unique PST locations..."

$HKUserList = get-childitem -Path HKU: | Select-Object -ExpandProperty Name
ForEach ($HKUser in $HKUserList) {
    $PSTFind = Get-ChildItem -Path HKU:\$HKUser\Software\Microsoft\Office\16.0\Outlook\Search -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property | Where-Object -FilterScript {$_ -like "*.pst"}
    ForEach ($PST in $PSTFind) {
        Write-Host "Copying PST found at '$PST'..."
        Copy-Item "$PST" -Destination "$PSTRepo" -ErrorAction SilentlyContinue
    }
}

Write-Host "PST Files have been gathered." -ForegroundColor Yellow
Write-Host "Moving repository to external media..." -ForegroundColor Yellow

Exit

