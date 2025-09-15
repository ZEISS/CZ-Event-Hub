

$headers = @{ "Content-Type" = "application/json" }
$body = '{"message":"Hello from PS!"}'

$round = 500

for ($i = 0; $i -lt $round; $i++) {
    $req = Invoke-WebRequest -Uri 'https://custom-http-source.eventhub.cloud.zeiss.com' -Method Post -Body $body -Headers $headers
    $test = ""
}
