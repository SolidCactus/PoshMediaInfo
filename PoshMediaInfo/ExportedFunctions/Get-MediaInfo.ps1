<#
.SYNOPSIS
	Analyze media files.

.DESCRIPTION
	Uses MediaInfo.dll to return information about audio and video streams contained within a file.
#>
function Get-MediaInfo {
	param(
		[Parameter(ValueFromPipeline=$true)]
		$Path
	)
	process {
		$ResolvedPath = (Resolve-Path $Path).Path
		New-Object MediaInfoNET.MediaFile($ResolvedPath)
	}
}
Export-ModuleMember -Function Get-MediaInfo