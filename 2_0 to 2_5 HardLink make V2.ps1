# ================================
# Fill out your game path.
# Only the same drive is possible.
$COM3D2="e:\COM3D2"
$COM3D25="e:\COM3D2_5"
# ================================
# Change it to true if you really want to make it.
$HardLinkMake=$true
#$HardLinkMake=$false
# ================================

$Directorys = @(
"GameData",
"GameData_20"
)
$excludes = @(
"*.ini"
)
$Includes = @(
"*.arc",
"*.ine"
)

foreach ($Directory in $Directorys) {     
    Get-ChildItem -Path "$COM3D2\$Directory" -exclude $excludes -Include $Includes -Recurse -File |
        ForEach-Object { "Begin $Directory" } { 
            #$_  | Select-Object -Property *
            # COM3D2
            #$_.FullName
            # COM3D25
            #$fn=$_.FullName.replace($COM3D2,$COM3D25)
            $fn=$_ -ireplace [regex]::Escape($COM3D2), $COM3D25
            "COM3D2 to COM3D25 replace"
            $_.FullName
			"$fn"
            if( Test-Path $fn ){
                "Test-Path OK"
                if((Get-ItemProperty $_).LinkType)
                {
                    "symboliclink"
                }
                else
                {
                    "normal file"
                    $f=Get-Item $fn
                    $_h=$($_ | Get-FileHash).Hash
                    $fh=$($f | Get-FileHash).Hash
                    #$_.Length
                    #$f.Length
                    #$_h | Select-Object -Property *
                    #$fh | Select-Object -Property *
                    #( $_.Length -eq $f.Length )
                    #( "$_h" -eq "$fh" )
                    if( ( $_.Length -eq $f.Length ) -and ( "$_h" -eq "$fh" ) ){
                        "Same $($_.Name)"
                        "$($_.Length) , $_h , $($_.FullName)"
                        "$($f.Length) , $fh , $($f.FullName)"
                        #$_ | Select-Object -Property *
                        #$_ | Select-Object -Property LinkType
                        if(( $_.FullName -eq $f.FullName )){
							"ERR path same"
						}
						else
						{
							if( $HardLinkMake ){
								"$_.FullName"
								New-Item -ItemType HardLink -Path $f.DirectoryName -Name $f.Name -Target $_.FullName -Force
								"Make $($_.Name)"
							}
						}
                    }else{
                        "not same"
                    }
                }
            }
        } { "End $Directory" }
}


Read-Host "End"
