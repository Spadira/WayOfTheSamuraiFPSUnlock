# Way of the Samurai 3 - framerate patcher
# Patches the game. :).
$ErrorActionPreference = 'Stop'
$dir  = Split-Path -Parent $MyInvocation.MyCommand.Definition
$exe  = Join-Path $dir 'WayOfTheSamurai3.exe'
$orig = "$exe.orig"

$STOCK_SHA = 'ED1552D19EF3FAA7959510EEB22D3A69B9B4A180A5C00923238FDA7EF3E00301'
$STOCK_LEN = 5697536

$PATCHES = @{
  '60' = @(@{o=13521;e='d9e8def1d91d5cc89400c3cccccccc';n='d8c0d9e8def1d91d5cc89400c39090'},@{o=13584;e='83ec08568bf1';n='e9ebbe430090'},@{o=189209;e='dc0d38168400';n='e9e211410090'},@{o=200492;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=203077;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1475676;e='bb010000';n='e91f702d'},@{o=4453376;e='0000000000';n='50a1dcda94'},@{o=4453382;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7055cc894'},@{o=4453403;e='0000000000000000000000';n='8988083deb0ac7055cc894'},@{o=4453415;e='00000000000000000000000000000000';n='8988883c5883ec08568bf1e9df40bcff'},@{o=4453504;e='0000000000';n='50a1dcda94'},@{o=4453510;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c902'},@{o=4453531;e='000000';n='58bb01'},@{o=4453537;e='0000000000';n='e9bb8fd2ff'},@{o=4453632;e='0000000000';n='d80d5cc894'},@{o=4453638;e='0000000000';n='da0d30d390'},@{o=4453644;e='0000000000';n='dc0d381684'},@{o=4453650;e='0000000000';n='e908eebeff'})
  '90' = @(@{o=13521;e='d9e8def1d91d5cc89400c3cccccccc';n='d8c0d9e8def1d91d5cc89400c39090'},@{o=13584;e='83ec08568bf1';n='e9ebbe430090'},@{o=189209;e='dc0d38168400';n='e9e211410090'},@{o=200492;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=203077;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1475676;e='bb010000';n='e91f702d'},@{o=4453376;e='0000000000';n='50a1dcda94'},@{o=4453382;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7055cc894'},@{o=4453403;e='0000000000000000000000';n='8988083deb0ac7055cc894'},@{o=4453415;e='00000000000000000000000000000000';n='610b363c5883ec08568bf1e9df40bcff'},@{o=4453504;e='0000000000';n='50a1dcda94'},@{o=4453510;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c903'},@{o=4453531;e='000000';n='58bb01'},@{o=4453537;e='0000000000';n='e9bb8fd2ff'},@{o=4453632;e='0000000000';n='d80d5cc894'},@{o=4453638;e='0000000000';n='da0d30d390'},@{o=4453644;e='0000000000';n='dc0d381684'},@{o=4453650;e='0000000000';n='e908eebeff'})
  '120' = @(@{o=13521;e='d9e8def1d91d5cc89400c3cccccccc';n='d8c0d9e8def1d91d5cc89400c39090'},@{o=13584;e='83ec08568bf1';n='e9ebbe430090'},@{o=189209;e='dc0d38168400';n='e9e211410090'},@{o=200492;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=203077;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1475676;e='bb010000';n='e91f702d'},@{o=4453376;e='0000000000';n='50a1dcda94'},@{o=4453382;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7055cc894'},@{o=4453403;e='0000000000000000000000';n='8988083deb0ac7055cc894'},@{o=4453415;e='00000000000000000000000000000000';n='8988083c5883ec08568bf1e9df40bcff'},@{o=4453504;e='0000000000';n='50a1dcda94'},@{o=4453510;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c904'},@{o=4453531;e='000000';n='58bb01'},@{o=4453537;e='0000000000';n='e9bb8fd2ff'},@{o=4453632;e='0000000000';n='d80d5cc894'},@{o=4453638;e='0000000000';n='da0d30d390'},@{o=4453644;e='0000000000';n='dc0d381684'},@{o=4453650;e='0000000000';n='e908eebeff'})
}

function Fail($m) {
    Write-Host ''
    Write-Host "  $m" -ForegroundColor Red
    Write-Host ''
    Read-Host '  Press Enter to close'
    exit 1
}

function HexBytes($s) {
    $b = New-Object byte[] ($s.Length / 2)
    for ($i = 0; $i -lt $b.Length; $i++) {
        $b[$i] = [Convert]::ToByte($s.Substring($i * 2, 2), 16)
    }
    return $b
}

Write-Host ''
Write-Host '  Way of the Samurai 3 - framerate patch' -ForegroundColor Cyan
Write-Host '  ======================================'
Write-Host ''

if (-not (Test-Path $exe)) {
    Fail 'WayOfTheSamurai3.exe not found. Put these files IN the game folder.'
}

# --- Backup Original ----------------------------------------
if (-not (Test-Path $orig)) {
    $cur = [IO.File]::ReadAllBytes($exe)
    if ($cur.Length -ne $STOCK_LEN) {
        Fail ("Unexpected exe size ({0} bytes, expected {1}). This patch targets the DRM-free GOG build; nothing was changed." -f $cur.Length, $STOCK_LEN)
    }
    $h = (Get-FileHash $exe -Algorithm SHA256).Hash
    if ($h -ne $STOCK_SHA) {
        Write-Host '  NOTE: your exe does not match the known GOG build.' -ForegroundColor Yellow
        Write-Host "    yours: $h"
        Write-Host "    known: $STOCK_SHA"
        Write-Host '  Every patch site is still verified byte-for-byte below, so a'
        Write-Host '  different build is refused rather than corrupted.'
        Write-Host ''
    }
    Copy-Item $exe $orig
    Write-Host '  Created backup: WayOfTheSamurai3.exe.orig' -ForegroundColor Green
}

$base = [IO.File]::ReadAllBytes($orig)
if ($base.Length -ne $STOCK_LEN) {
    Fail 'The .orig backup is the wrong size. Delete it, restore a stock exe, and re-run.'
}

# --- verify every patch site against the backup ---------------------------
foreach ($fps in $PATCHES.Keys) {
    foreach ($p in $PATCHES[$fps]) {
        $exp = HexBytes $p.e
        for ($i = 0; $i -lt $exp.Length; $i++) {
            if ($base[$p.o + $i] -ne $exp[$i]) {
                Fail ("Patch site 0x{0:X} does not match the expected original bytes - your game build is different. Nothing was changed." -f $p.o)
            }
        }
    }
}
Write-Host '  Verified all patch sites against your original exe.' -ForegroundColor Green

# --- build each framerate variant -----------------------------------------
foreach ($fps in ($PATCHES.Keys | Sort-Object { [int]$_ })) {
    $buf = New-Object byte[] $base.Length
    [Array]::Copy($base, $buf, $base.Length)
    foreach ($p in $PATCHES[$fps]) {
        $new = HexBytes $p.n
        [Array]::Copy($new, 0, $buf, $p.o, $new.Length)
    }
    [IO.File]::WriteAllBytes("$exe.${fps}fps_v9", $buf)
    Write-Host ("  Built {0,3} fps build" -f $fps) -ForegroundColor Green
}

# --- install 60 fps by default --------------------------------------------
Copy-Item "$exe.60fps_v9" $exe -Force
Write-Host ''
Write-Host '  Installed the 60 fps build.' -ForegroundColor Cyan
Write-Host '  Run "Switch Framerate.bat" to change between 30 / 60 / 90 / 120.'
Write-Host ''
Read-Host '  Press Enter to close'
