function Join-Streams {
	param(
		$Stream1,
		$Stream2,
		$OutStream
	)
	$InFileOptions = @((New-FfmpegInFileOptions -Path $Stream1), (New-FfmpegInFileOptions -Path $Stream2))
	$OutFileOptions = New-FfmpegOutFileOptions -path $OutStream -AudioCodecName copy -VideoCodecName copy
	Start-Ffmpeg -InFileOptions $InFileOptions -OutFileOptions $OutFileOptions
}
Export-ModuleMember -Function Join-Streams