# Way of the Samurai 3 - framerate patcher (60 / 90 / 120 fps)
# Works with the GOG build and with the Steam build.
# Patches YOUR OWN copy of the game. This package contains no game files.
$ErrorActionPreference = 'Stop'
$dir  = Split-Path -Parent $MyInvocation.MyCommand.Definition
$exe  = Join-Path $dir 'WayOfTheSamurai3.exe'
$orig = "$exe.orig"

$GOG_SHA   = 'ED1552D19EF3FAA7959510EEB22D3A69B9B4A180A5C00923238FDA7EF3E00301'
$GOG_LEN   = 5697536
$STEAM_SHA = 'F16D96E61E53BAD5DF5EC38E18AE415C80A0B054A0041C8B17A8C1FDFB23B28E'
$STEAM_LEN = 5806592

$PATCHES = @{
  'GOG_60' = @(@{o=13521;e='d9e8def1d91d5cc89400c3cccccccc';n='d8c0d9e8def1d91d5cc89400c39090'},@{o=13584;e='83ec08568bf1';n='e9ebbe430090'},@{o=189209;e='dc0d38168400';n='e9e211410090'},@{o=200492;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=203077;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1475676;e='bb010000';n='e91f702d'},@{o=4453376;e='0000000000';n='50a1dcda94'},@{o=4453382;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7055cc894'},@{o=4453403;e='0000000000000000000000';n='8988083deb0ac7055cc894'},@{o=4453415;e='00000000000000000000000000000000';n='8988883c5883ec08568bf1e9df40bcff'},@{o=4453504;e='0000000000';n='50a1dcda94'},@{o=4453510;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c902'},@{o=4453531;e='000000';n='58bb01'},@{o=4453537;e='0000000000';n='e9bb8fd2ff'},@{o=4453632;e='0000000000';n='d80d5cc894'},@{o=4453638;e='0000000000';n='da0d30d390'},@{o=4453644;e='0000000000';n='dc0d381684'},@{o=4453650;e='0000000000';n='e908eebeff'})
  'GOG_90' = @(@{o=13521;e='d9e8def1d91d5cc89400c3cccccccc';n='d8c0d9e8def1d91d5cc89400c39090'},@{o=13584;e='83ec08568bf1';n='e9ebbe430090'},@{o=189209;e='dc0d38168400';n='e9e211410090'},@{o=200492;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=203077;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1475676;e='bb010000';n='e91f702d'},@{o=4453376;e='0000000000';n='50a1dcda94'},@{o=4453382;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7055cc894'},@{o=4453403;e='0000000000000000000000';n='8988083deb0ac7055cc894'},@{o=4453415;e='00000000000000000000000000000000';n='610b363c5883ec08568bf1e9df40bcff'},@{o=4453504;e='0000000000';n='50a1dcda94'},@{o=4453510;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c903'},@{o=4453531;e='000000';n='58bb01'},@{o=4453537;e='0000000000';n='e9bb8fd2ff'},@{o=4453632;e='0000000000';n='d80d5cc894'},@{o=4453638;e='0000000000';n='da0d30d390'},@{o=4453644;e='0000000000';n='dc0d381684'},@{o=4453650;e='0000000000';n='e908eebeff'})
  'GOG_120' = @(@{o=13521;e='d9e8def1d91d5cc89400c3cccccccc';n='d8c0d9e8def1d91d5cc89400c39090'},@{o=13584;e='83ec08568bf1';n='e9ebbe430090'},@{o=189209;e='dc0d38168400';n='e9e211410090'},@{o=200492;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=203077;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1475676;e='bb010000';n='e91f702d'},@{o=4453376;e='0000000000';n='50a1dcda94'},@{o=4453382;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7055cc894'},@{o=4453403;e='0000000000000000000000';n='8988083deb0ac7055cc894'},@{o=4453415;e='00000000000000000000000000000000';n='8988083c5883ec08568bf1e9df40bcff'},@{o=4453504;e='0000000000';n='50a1dcda94'},@{o=4453510;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c904'},@{o=4453531;e='000000';n='58bb01'},@{o=4453537;e='0000000000';n='e9bb8fd2ff'},@{o=4453632;e='0000000000';n='d80d5cc894'},@{o=4453638;e='0000000000';n='da0d30d390'},@{o=4453644;e='0000000000';n='dc0d381684'},@{o=4453650;e='0000000000';n='e908eebeff'})
  'STEAM_60' = @(@{o=9553;e='d9e8def1d91d0c9a9600c3cccccccc';n='d8c0d9e8def1d91d0c9a9600c39090'},@{o=9616;e='83ec08568bf1';n='e9fb62450090'},@{o=191353;e='dc0d70b68500';n='e9b29d420090'},@{o=202876;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=205445;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1477580;e='bb010000';n='e90ffd2e'},@{o=4556944;e='0000000000';n='50a1acac96'},@{o=4556950;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7050c9a96'},@{o=4556971;e='0000000000000000000000';n='8988083deb0ac7050c9a96'},@{o=4556983;e='00000000000000000000000000000000';n='8988883c5883ec08568bf1e9cf9cbaff'},@{o=4557024;e='0000000000';n='50a1acac96'},@{o=4557030;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c902'},@{o=4557051;e='000000';n='58bb01'},@{o=4557057;e='0000000000';n='e9cb02d1ff'},@{o=4557104;e='0000000000';n='d80d0c9a96'},@{o=4557110;e='0000000000';n='da0dd0a292'},@{o=4557116;e='0000000000';n='dc0d70b685'},@{o=4557122;e='0000000000';n='e93862bdff'})
  'STEAM_90' = @(@{o=9553;e='d9e8def1d91d0c9a9600c3cccccccc';n='d8c0d9e8def1d91d0c9a9600c39090'},@{o=9616;e='83ec08568bf1';n='e9fb62450090'},@{o=191353;e='dc0d70b68500';n='e9b29d420090'},@{o=202876;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=205445;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1477580;e='bb010000';n='e90ffd2e'},@{o=4556944;e='0000000000';n='50a1acac96'},@{o=4556950;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7050c9a96'},@{o=4556971;e='0000000000000000000000';n='8988083deb0ac7050c9a96'},@{o=4556983;e='00000000000000000000000000000000';n='610b363c5883ec08568bf1e9cf9cbaff'},@{o=4557024;e='0000000000';n='50a1acac96'},@{o=4557030;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c903'},@{o=4557051;e='000000';n='58bb01'},@{o=4557057;e='0000000000';n='e9cb02d1ff'},@{o=4557104;e='0000000000';n='d80d0c9a96'},@{o=4557110;e='0000000000';n='da0dd0a292'},@{o=4557116;e='0000000000';n='dc0d70b685'},@{o=4557122;e='0000000000';n='e93862bdff'})
  'STEAM_120' = @(@{o=9553;e='d9e8def1d91d0c9a9600c3cccccccc';n='d8c0d9e8def1d91d0c9a9600c39090'},@{o=9616;e='83ec08568bf1';n='e9fb62450090'},@{o=191353;e='dc0d70b68500';n='e9b29d420090'},@{o=202876;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=205445;e='0fbf510689542448db442448d8c9d95c2448';n='df4106d8c0d8c9d95c244890909090909090'},@{o=1477580;e='bb010000';n='e90ffd2e'},@{o=4556944;e='0000000000';n='50a1acac96'},@{o=4556950;e='0000000000000000000000000000000000000000';n='85c074178b407083e80283f801770cc7050c9a96'},@{o=4556971;e='0000000000000000000000';n='8988083deb0ac7050c9a96'},@{o=4556983;e='00000000000000000000000000000000';n='8988083c5883ec08568bf1e9cf9cbaff'},@{o=4557024;e='0000000000';n='50a1acac96'},@{o=4557030;e='000000000000000000000000000000000000';n='85c0740b8b407083e80283f801760669c904'},@{o=4557051;e='000000';n='58bb01'},@{o=4557057;e='0000000000';n='e9cb02d1ff'},@{o=4557104;e='0000000000';n='d80d0c9a96'},@{o=4557110;e='0000000000';n='da0dd0a292'},@{o=4557116;e='0000000000';n='dc0d70b685'},@{o=4557122;e='0000000000';n='e93862bdff'})
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

# --- establish a trustworthy .orig ----------------------------------------
if (-not (Test-Path $orig)) {
    $h = (Get-FileHash $exe -Algorithm SHA256).Hash
    if (($h -ne $GOG_SHA) -and ($h -ne $STEAM_SHA)) {
        Write-Host '  NOTE: your exe matches neither known build.' -ForegroundColor Yellow
        Write-Host "    yours: $h"
        Write-Host "    GOG:   $GOG_SHA"
        Write-Host "    Steam: $STEAM_SHA"
        Write-Host '  Every patch site is still verified byte-for-byte below, so a'
        Write-Host '  different build is refused rather than corrupted.'
        Write-Host ''
    }
    Copy-Item $exe $orig
    Write-Host '  Created backup: WayOfTheSamurai3.exe.orig' -ForegroundColor Green
}

$base = [IO.File]::ReadAllBytes($orig)
$bh = (Get-FileHash $orig -Algorithm SHA256).Hash

if     ($bh -eq $GOG_SHA)   { $ed = 'GOG'   }
elseif ($bh -eq $STEAM_SHA) { $ed = 'STEAM' }
elseif ($base.Length -eq $GOG_LEN)   { $ed = 'GOG'   }
elseif ($base.Length -eq $STEAM_LEN) { $ed = 'STEAM' }
else {
    Fail ("Cannot tell which build this is (size {0}).`n" +
          "  Expected {1} bytes (GOG) or {2} bytes (Steam).`n" +
          "  Nothing was changed." -f $base.Length, $GOG_LEN, $STEAM_LEN)
}

$label = if ($ed -eq 'GOG') { 'GOG' } else { 'Steam' }
Write-Host "  Detected edition: $label" -ForegroundColor Cyan

# --- verify every patch site against the backup ---------------------------
foreach ($fps in 60, 90, 120) {
    foreach ($p in $PATCHES["${ed}_$fps"]) {
        $exp = HexBytes $p.e
        for ($i = 0; $i -lt $exp.Length; $i++) {
            if ($base[$p.o + $i] -ne $exp[$i]) {
                Fail ("Patch site 0x{0:X} does not match the expected original bytes -`n" +
                      "  your game build is different. Nothing was changed." -f $p.o)
            }
        }
    }
}
Write-Host '  Verified all patch sites against your original exe.' -ForegroundColor Green

# --- build each framerate variant -----------------------------------------
foreach ($fps in 60, 90, 120) {
    $buf = New-Object byte[] $base.Length
    [Array]::Copy($base, $buf, $base.Length)
    foreach ($p in $PATCHES["${ed}_$fps"]) {
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
