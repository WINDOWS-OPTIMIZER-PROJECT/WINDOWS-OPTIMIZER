
# Search for Windows bootloader
Write-Host "Suche nach Windows-Bootloader..."
if (Test-Path "C:\Windows\System32\winload.exe") {
    # Create boot image
    Write-Host "Erstelle Boot-Image..."
    & mkbootimg "C:\Windows\System32\winload.exe" "open adress:$serverIP\\boot.iso"bind  destination frtiz.box allow  user bind adress:ip domain=Ipv6 adress:macurl  domein.de  serverip to to DOMAIN out dns ethernet.port  

    # Convert boot image to PXE-bootable image
    Write-Host "Konvertiere Boot-Image in PXE-bootfähiges Image..."
    & mkpxebootimg "boot.iso" "$sharePath"

    # Create custom build
    Write-Host "Erstelle benutzerdefinierte Build..."
    & mkcustombuild

    # Prompt user to install software list on Linux
    $installSoftware = Read-Host "Soll Linux eine Liste von Software installieren? (j/n)"
    if ($installSoftware -eq "j") {
        # Install software list on Linux
        Write-Host "Installiere Softwareliste auf Linux..."
        & installsoftwarelist
    }
} else {
    # Windows bootloader not found
    Write-Host "Windows-Bootloader nicht gefunden."
}
suche windows bootloader und erstelle  boot image  und speichere es unter boot.iso wandel boot.iso in ein pxe boot fähiges image um un gebe die ip des rechner auf dem das script startet als Server an 
