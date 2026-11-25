# Confere se os TIFFs baixados sao identicos aos gerados pela pipeline,
# comparando o SHA-256 de cada arquivo com o relatorio recortes.csv.
# Nao altera nenhum arquivo.
# Uso:
#   powershell -ExecutionPolicy Bypass -File scripts\verificar-hashes.ps1 -Pasta C:\oPovo\tiffs_originais

param(
    [Parameter(Mandatory = $true)][string]$Pasta
)

$relatorio = Join-Path $Pasta 'relatorios\recortes.csv'
$tiffs = Join-Path $Pasta '01_tiffs'
$linhas = Import-Csv -Path $relatorio -Encoding UTF8

$total = $linhas.Count
$i = 0
$ok = 0
$problemas = @()

foreach ($linha in $linhas) {
    $i++
    $nome = Split-Path $linha.tiff -Leaf
    $arquivo = Join-Path $tiffs $nome
    Write-Progress -Activity 'Conferindo hashes' -Status "$i/$total $nome" -PercentComplete (100 * $i / $total)
    if (-not (Test-Path $arquivo)) {
        $problemas += "$nome : arquivo nao encontrado"
        continue
    }
    $hash = (Get-FileHash -Path $arquivo -Algorithm SHA256).Hash.ToLower()
    if ($hash -eq $linha.sha256_tiff.ToLower()) {
        $ok++
    } else {
        $problemas += "$nome : hash diferente"
    }
}

Write-Host ""
Write-Host "Identicos ao relatorio: $ok de $total."
if ($problemas.Count -gt 0) {
    Write-Host "Problemas:"
    $problemas | ForEach-Object { Write-Host " - $_" }
} else {
    Write-Host "Nenhum problema encontrado."
}
