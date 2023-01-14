# Test it locally
dotnet publish -c Release -p:Version=1.0.1.0

docker build -f DockerfileDevOps -t public-web-api ./bin/Release/net7.0/publish