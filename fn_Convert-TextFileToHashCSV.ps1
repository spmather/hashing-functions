#!/bin/pwsh


# SPMATHER
# 2026-06-15
# Version 1.0.2  2026-06-20

# Converts text files into a CSV containing hashes for every unique word

# Example loop with plain text files:
# foreach ($file in ((get-childitem ~/Documents/BiblePlainText).FullName)) {$shortname = $file.split('/')[-1] ;  Convert-TextToHashCSV -FilePath $file -OutFilePath ./$($shortname)_$(get-random)_hashes.csv -ExcludeNumeral}
# Sort and Select Unique take a long time.  Do not use for pre-sorted word lists.



function Convert-TextFileToHashCSV {

    # Help coming soon

    param (
        [Parameter(
            Position          = 0,    
            Mandatory         = $True,
            ValueFromPipeLine = $True
        )]
        [string]$FilePath,

        [Parameter(
            Position          = 0,
            Mandatory         = $False
        )]
        [string]$OutFilePath,

        [Parameter(
            Mandatory         = $False
        )]
        [switch]$ExcludeNumeral
    )
    
    $Content      = (Get-Content $FilePath)
    $ContentSplit = $Content.Split(' ','.',',',';',':',"'",'(',')','?','!','[',']',"`’","`‘")

    if ($OutFilePath -eq $Null) {
        $OutFilePath = "$PSScriptRoot/Hashes.txt"
    }

    if ($PSVersionTable.Platform -eq "UNIX") {
        bash -c "touch $OutFilePath"
        bash -c "chmod 777 $OutFilePath"
    }

    if ($ExcludeNumeral) {
        (0..9) | ForEach-Object {
            $ContentWords = $ContentSplit.Replace($_,"")
        }
    }
    elseif (!($ExcludeNumeral)) {
        $ContentWords = $ContentSplit
    }

    $UniqueContentWords = $ContentWords | Sort-Object | Select-Object -Unique

    foreach ($String in $UniqueContentWords) {
        $String = $String.Trim()
        $String + ',' + (Find-Hash $String) | Out-File -FilePath $OutFilePath -Append  # import find-hash function first
    }

    Rename-Item -Path $OutFilePath -NewName "$OutFilePath.csv"

}

Write-Host "Function loaded.  Please use Get-Help Convert-TextFileToHashCSV for help" -ForegroundColor Cyan


# fin
