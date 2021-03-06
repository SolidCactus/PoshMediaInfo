<#
.SYNOPSIS
	Returns information about valid ffmpeg formats.
.DESCRIPTION
	Parses the output of ffmpeg.exe -formats and outputs objects representing
	valid ffmpeg formats.
#>
function Get-FfmpegFormat {
	[OutputType([ffmpeg.Format])]
	param(
		[string]$Name,
		[ffmpeg.FormatFlags]$Flags
	)
	$FoundSeparator = $false
	$AllFormats = &$ffmpeg -formats 2> $null | %{
		if($_.trim() -eq "--") {
			$FoundSeparator = $true
		} elseif($FoundSeparator) {
			$Split = $_.Split(" ", 3, [StringSplitOptions]::RemoveEmptyEntries)
			[ffmpeg.FormatFlags]$FormatFlags = [ffmpeg.FormatFlags]::None
			if($Split[0].Contains("D")) {
				$FormatFlags = $FormatFlags -bor [ffmpeg.FormatFlags]::Demuxing
			}
			if($Split[0].Contains("E")) {
				$FormatFlags = $FormatFlags -bor [ffmpeg.FormatFlags]::Muxing
			}
			#There can be multiple names on a single line, split them and create separate format object for them
			$Split[1].Split(",") | %{
				New-Object ffmpeg.Format -Property @{
					Name = $_
					Flags = $FormatFlags
					Description = $Split[2]
				}
			}
		}
	}
	$AllFormats | Where-Object {
		$NameMatch = if($Name) {
			$_.Name -eq $Name
		} else {
			$true
		}
		
		$FlagsMatch = if($Flags) {
			$_.Flags -band $Flags
		} else {
			$true
		}
		
		$NameMatch -and $FlagsMatch
	}
}
Export-ModuleMember -Function Get-FfmpegFormat