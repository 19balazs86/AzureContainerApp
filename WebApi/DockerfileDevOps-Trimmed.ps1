# Test it locally
dotnet publish --runtime linux-x64 -c Release --self-contained -p:PublishTrimmed=true -p:PublishSingleFile=true -p:InvariantGlobalization=true -p:Version=1.0.1.0

docker build -f DockerfileDevOps-Trimmed -t public-web-api-trimmed ./bin/Release/net7.0/linux-x64/publish