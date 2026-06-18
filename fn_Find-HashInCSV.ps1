#!/bin/pwsh

# SPMATHER
# 2026-06-17
# Version 1.0.0

function Find-HashInCsv {

    # Help coming soon
    # Quick note:  import-csv -path [string[]] can point to all the csv's in a directory using (gci ./ *.csv).fullname

    param(
        [Parameter(
            Position          = 0,
            Mandatory         = $True,
            ValueFromPipeline = $True
        )]
        [string[]]$Path,

        [Parameter(
            Mandatory         = $True
        )]
        [string[]]$ValueList,

        [Parameter()]
        [switch]$CSVHeadersIncluded

    )

    begin {
        if ($CSVHeadersIncluded) {
            $CSV = Import-CSV -Path $Path
        }
        elseif (!($CSVHeadersIncluded)) {
            $CSV = Import-CSV -Path $Path -Header "Word","Hash" 
        }
    }
    process {
        foreach ($Value in $ValueList) {
            $Location = $CSV | Where-Object {$CSV.Hash -eq $Value}
        }
    }
    end {
        return $Location
    }
}

Write-Host "Function loaded.  Please use Get-Help Find-HashInCSV for help" -ForegroundColor Cyan


# fin
