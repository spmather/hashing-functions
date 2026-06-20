#!/bin/pwsh


# SPMATHER
# 2026-06-20
# Version 1.0.0

# Converts a list of words in a text file.  Use this function for a pre-sorted unique text list as it is much faster
#     than Conver-TextFileToHash

# Example loop with plain text files:
# foreach ($file in ((get-childitem ~/Documents/WordList).FullName)) {$shortname = $file.split('/')[-1] ;  Convert-TextListToHashCSV -FilePath $file -OutFilePath ./$($shortname)_$(get-random)_hashes.csv -ExcludeNumeral}


function Convert-TextListToHashCSV {

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

    $UniqueContentWords = $ContentWords

    foreach ($String in $UniqueContentWords) {
        $String = $String.Trim()
        $String + ',' + (Find-Hash $String) | Out-File -FilePath $OutFilePath -Append  # import find-hash function first
    }

    Rename-Item -Path $OutFilePath -NewName "$OutFilePath.csv"

}

Write-Host "Function loaded.  Please use Get-Help Convert-TextListToHashCSV for help" -ForegroundColor Cyan


# fin
