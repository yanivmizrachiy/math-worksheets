# ============================================================================
# CommonFunctions.psm1 - Shared functions module
# All common functions for PowerShell scripts
# ============================================================================

# Get project root directory
function Get-ProjectRoot {
    $scriptPath = $PSScriptRoot
    if (-not $scriptPath) {
        $scriptPath = Split-Path -Parent (Get-Location).Path
    }
    
    # Try to find project root by looking for .git directory
    $current = $scriptPath
    while ($current -and $current -ne (Split-Path $current)) {
        if (Test-Path (Join-Path $current ".git")) {
            return $current
        }
        $current = Split-Path $current
    }
    
    # Fallback to hardcoded path if needed
    if (Test-Path "C:\Users\yaniv\math-worksheets") {
        return "C:\Users\yaniv\math-worksheets"
    }
    
    return $scriptPath
}

# Write colored status message
function Write-Step {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("INFO", "SUCCESS", "ERROR", "WARNING")]
        [string]$Status = "INFO"
    )
    
    $color = switch($Status) {
        "SUCCESS" { "Green" }
        "ERROR" { "Red" }
        "WARNING" { "Yellow" }
        default { "Cyan" }
    }
    
    Write-Host "[$Status] $Message" -ForegroundColor $color
}

# Read JSON file with error handling
function Read-JsonFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        return $null
    }
    
    try {
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        $content = [System.IO.File]::ReadAllText($FilePath, $utf8NoBom)
        return $content | ConvertFrom-Json
    } catch {
        Write-Step "Error reading JSON file: $FilePath - $_" "WARNING"
        return $null
    }
}

# Write JSON file with error handling
function Write-JsonFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,
        
        [Parameter(Mandatory=$true)]
        [object]$Data
    )
    
    try {
        $json = $Data | ConvertTo-Json -Depth 10 -Compress:$false
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        $dir = Split-Path $FilePath -Parent
        if ($dir -and -not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        [System.IO.File]::WriteAllText($FilePath, $json, $utf8NoBom)
        return $true
    } catch {
        Write-Step "Error writing JSON file: $FilePath - $_" "ERROR"
        return $false
    }
}

# Check if Git is available
function Test-GitAvailable {
    return (Get-Command git -ErrorAction SilentlyContinue) -ne $null
}

# Check if Git repository exists
function Test-GitRepository {
    param(
        [string]$Path = (Get-Location).Path
    )
    
    return Test-Path (Join-Path $Path ".git")
}

# Get Git status (changed files)
function Get-GitChangedFiles {
    if (-not (Test-GitAvailable)) {
        return @()
    }
    
    $gitStatus = git status --porcelain 2>&1
    $changedFiles = @()
    
    if ($gitStatus) {
        $gitStatus | ForEach-Object {
            if ($_ -match '^\s*([AMDU])\s+(.+)$') {
                $status = $matches[1]
                $file = $matches[2].Trim()
                $statusText = switch($status) {
                    "A" { "Added" }
                    "M" { "Modified" }
                    "D" { "Deleted" }
                    "U" { "Unmerged" }
                    default { $status }
                }
                $changedFiles += [PSCustomObject]@{
                    File = $file
                    Status = $statusText
                    GitStatus = $status
                }
            }
        }
    }
    
    return $changedFiles
}

# Export module members
Export-ModuleMember -Function Get-ProjectRoot, Write-Step, Read-JsonFile, Write-JsonFile, Test-GitAvailable, Test-GitRepository, Get-GitChangedFiles

