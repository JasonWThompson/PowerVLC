function Convert-Media {
    <#
    .SYNOPSIS
    Converts media from one type to another using VLC.

    .PARAMETER Path
    The path on the file system of the item to convert.

    .PARAMETER Codec
    The codec that the media should be converted to.

    .PARAMETER Destination
    The destination file or directory of the converted media.

    .INPUTS
    An existing media file.

    .OUTPUTS
    The converted media file.

    .NOTES
    This was inspired by a blog post by Andrew Connell
    http://www.andrewconnell.com/blog/Converting-all-your-non-MP3-files-to-MP3s-with-VLC-PowerShell-and-TagLib
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter(Mandatory = $true)]
        [string]
        $Codec,

        [Parameter(Mandatory = $false)]
        $Destination = "."
    )

    # This is the default installation path.
    $vlcPath = 'C:\Program Files (x86)\VideoLAN\VLC\vlc.exe'
    if (Test-Path -Path $Destination -PathType Container) {
        $destinationFile = Join-Path -Path $Destination -ChildPath "$((Get-Item $Path).BaseName).$Codec"
    }
    else {
        $destinationFile = $Destination
    }
    
    &"$vlcPath" -I dummy "$Path" ":sout=#transcode{acodec=$codec,vcodec=dummy}:standard{access=file,mux=raw,dst=`'$destinationFile`'}" vlc://quit | Out-Null;
}