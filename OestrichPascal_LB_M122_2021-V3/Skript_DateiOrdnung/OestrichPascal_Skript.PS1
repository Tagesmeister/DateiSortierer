    <#Scriptname: OestrichPascal_Skript.PS1
    Author: Pascal Oestrich
    Date: 26.06.2023
    Version: 1.0

    Dieses Script sortiert alle Moodle-Dateien im Computer richtig ein.
    Beim Erstenmal Nutzen, sollte man die Pfande Konfigurieren.
    #>


#----------------------------------------------------------------------------------------------------------------------------
function MyScript {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('Start', 'Configuration', ErrorMessage = "Ungültige Eingabe: Mögliche Eingaben (Start | Configuration)")]
        [string]$Action
    )
}
# Quelle Chat GPT 4 ----------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
function Update-Config {
    $sourceDir = Read-Host -Prompt 'Geben Sie den Quellverzeichnispfad ein'
    $destinationDir = Read-Host -Prompt 'Geben Sie den Zielverzeichnispfad ein'
    $config = @{
        "sourceDir" = $sourceDir
        "destinationDir" = $destinationDir
    } | ConvertTo-Json
    Set-Content -Path .\Config.json -Value $config
    Write-Host "Konfiguration aktualisiert."
}
# Quelle Chat GPT 4 -------------------------------------------------------------


# Lese die Konfigurationsdatei
$config = Get-Content -Path .\Config.json | ConvertFrom-Json
switch ($Action) {
    'Configuration' {
        Update-Config
    }
    'Start' {
        # Setze die Pfade aus der Konfigurationsdatei
        $sourceDir = $config.sourceDir
        $destinationDir = $config.destinationDir


        Get-ChildItem $sourceDir -File | ForEach-Object {
        #---------------------------------------------------------------
            # Extrahiere den Dateityp und Modulnummer aus dem Dateinamen
            if ($_.Name -match "(LA|PR|Ex|)_([0-9]+)") {

                $type = $Matches[1]
                $module = $Matches[2]
        # Quelle Chat GPT 4 --------------------------------------------

                $targetDir = Join-Path -Path $destinationDir -ChildPath $module
                $targetDir = Join-Path -Path $targetDir -ChildPath $type

                #Prüfen | Erstellen nicht existierende Ordner
                if (!(Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir | Out-Null
                }

                Move-Item -Path $_.FullName -Destination $targetDir

            }    
        }
    }

}

    #Start des Skripts
    Clear-Host
    $Action = Read-Host -Prompt "Action (Start/Configuration)"

    MyScript -Action $Action



