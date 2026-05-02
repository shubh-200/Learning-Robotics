<# 
    Daily Git Push Script for Robotics Learning Vault
    Usage: Right-click → Run with PowerShell, or run from terminal:
           powershell -ExecutionPolicy Bypass -File .\push-daily.ps1
#>

$vaultPath = $PSScriptRoot  # Script is in the vault root

Set-Location $vaultPath

# Get today's date for commit message
$date = Get-Date -Format "yyyy-MM-dd"
$time = Get-Date -Format "HH:mm"

# Stage all changes
git add -A

# Check if there are changes to commit
$status = git status --porcelain
if ($status) {
    # Count changed files
    $fileCount = ($status | Measure-Object -Line).Lines
    
    # Auto-generate commit message
    $commitMsg = "📝 Daily update: $date ($time) — $fileCount file(s) changed"
    
    git commit -m $commitMsg
    git push origin main
    
    Write-Host ""
    Write-Host "✅ Successfully pushed $fileCount file(s) to GitHub!" -ForegroundColor Green
    Write-Host "   Commit: $commitMsg" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "ℹ️  No changes to push today." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to close"
