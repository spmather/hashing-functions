#!/bin/pwsh


# SPMATHER
# 2026-06-20
# Version 1.0.1

# Converts a list of words in a text file.  Use this function for a pre-sorted unique text list as it is much faster
#     than Conver-TextFileToHash

# Example loop with plain text files:
# foreach ($file in ((get-childitem ~/Documents/directory-of-wordlists -file *.txt -recurse).FullName)) `
#     {$shortname = $file.split('/')[-1] ;  Convert-TextListToHashCSV -FilePath $file -OutFilePath `
#     ./wordlists2/$($shortname)_$(get-random)_hashes.csv}

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
            Mandatory         = $True
        )]
        [string]$OutFilePath
    )
    
    $Content = (Get-Content $FilePath)
    
    if ($Null -eq $OutFilePath) {
        $OutFilePath = "$PSScriptRoot/Hashes.txt"
    }

    if ($PSVersionTable.Platform -eq "UNIX") {
        bash -c "touch $OutFilePath"
        bash -c "chmod 777 $OutFilePath"
    }

    foreach ($String in $Content) {
        $String = $String.Trim()
        $String + ',' + (Find-Hash $String) | Out-File -FilePath $OutFilePath -Append  # import find-hash function first
    }

    Rename-Item -Path $OutFilePath -NewName "$OutFilePath.csv"

}

Write-Host "Function loaded.  Please use Get-Help Convert-TextListToHashCSV for help" -ForegroundColor Cyan


# fin
