# Converte TIFFs em TIFFs piramidais para o Cantaloupe.
# Os arquivos de entrada nunca sao alterados.
# Uso:
#   powershell -ExecutionPolicy Bypass -File scripts\converter-piramidal.ps1 -Entrada C:\pasta\entrada -Saida C:\pasta\saida

param(
    [Parameter(Mandatory = $true)][string]$Entrada,
    [Parameter(Mandatory = $true)][string]$Saida
)

if (-not (Get-Command vips -ErrorAction SilentlyContinue)) {
    Write-Host "Erro: o comando 'vips' nao foi encontrado. Instale a libvips antes."
    exit 1
}
if ((Resolve-Path $Entrada).Path -eq [System.IO.Path]::GetFullPath($Saida)) {
    Write-Host "Erro: a pasta de saida precisa ser diferente da pasta de entrada."
    exit 1
}

New-Item -ItemType Directory -Force -Path $Saida | Out-Null
$arquivos = Get-ChildItem -Path $Entrada -File | Where-Object { $_.Extension -match '^\.tiff?$' } | Sort-Object Name
$total = $arquivos.Count
$i = 0
$erros = @()

foreach ($arquivo in $arquivos) {
    $i++
    $destino = Join-Path $Saida ($arquivo.BaseName + '.tif')
    if (Test-Path $destino) {
        Write-Host "[$i/$total] ja existe, pulando: $($arquivo.Name)"
        continue
    }
    Write-Host "[$i/$total] convertendo: $($arquivo.Name)"
    & vips tiffsave $arquivo.FullName $destino --tile --pyramid --tile-width 512 --tile-height 512 --compression deflate
    if ($LASTEXITCODE -ne 0) {
        $erros += $arquivo.Name
        if (Test-Path $destino) { Remove-Item $destino }
    }
}

Write-Host ""
Write-Host "Concluido: $($total - $erros.Count) de $total arquivos."
if ($erros.Count -gt 0) {
    Write-Host "Com erro:"
    $erros | ForEach-Object { Write-Host " - $_" }
}
