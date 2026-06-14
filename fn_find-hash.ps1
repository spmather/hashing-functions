#!/bin/pwsh

# SPMATHER
# 2026-06-14
# Version 1.0.0

# tl;dr  function gets the hash of a string instead of a file
# use ``` find-hash "bruh" ```

function Find-Hash {
    param (
        [Parameter(
            Position          = 0,    
            Mandatory         = $True,
            ValueFromPipeLine = $True
        )]
        [string]$FunctionInput,

        [Parameter(
            Position          = 1,
            Mandatory         = $False
        )]
        [string]$Algorithm = "SHA256",

        [Parameter(
            Mandatory         = $False
        )]
        [string]$TempFilePath = $PSScriptRoot
    )

    begin {
        if ( ([string]::IsNullOrEmpty($FunctionInput)) ) {
            $DoLoopErrorCount = 0

            do {
                $FunctionInput = Read-Host "Enter an input"
                if ($DoLoopErrorCount -gt 3) {
                    Write-Error "Did not fill input be with a value"
                    break
                }
                $DoLoopErrorCount++
            }
            Until (
                -not ([string]::IsNullOrEmpty($Variable))
            )
        }
    }

    process {

        try {
            $Salt     = Get-Random -Minimum 10000 -Maximum 99999
            $FileName = "tmp.$($MyInvocation.MyCommand.Name).$($Salt)"
            $FullPath = "$TempFilePath/$FileName"

            if ($PSVersionTable.Platform -eq "UNIX") {
                bash -c "touch $($FullPath)"
            }
            else {
                # There doesn't seem to be a way to suppress the success of this cmdlet
                New-Item -Path "$TempFilePath" -Name $FileName -ItemType File
            }

            Set-Content -Path $FullPath -Value "$FunctionInput"
        }
        catch {
            Write-Error "Could not create temp file, check folder permissions for $($TempFilePath)"
        }

        $FunctionOutput = (Get-FileHash -Path $FullPath -Algorithm $Algorithm).Hash

        if ($PSVersionTable.Platform -eq "UNIX") {
            bash -c "chmod +x $($FullPath)"
        }

        try {
            Remove-Item -Path $FullPath
        }
        catch {
            Write-Error "Could not remove temp files, you must remove later:  $($FullPath)"
        }
    }

    end {
        return $FunctionOutput
    }
}

Write-Host "Function loaded.  Please use Get-Help Find-Hash for help" -ForegroundColor Cyan

# fin
