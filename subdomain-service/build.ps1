$env:GOOS = "windows"
$env:GOARCH = "amd64"
go build -o subdomain-service-windows.exe

$env:GOOS = "linux"
$env:GOARCH = "amd64"
go build -o subdomain-service-linux