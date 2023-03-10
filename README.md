# Playing with Azure Container App
Actually, there is not much code in this repository. I experimented with the [Azure Container App](https://learn.microsoft.com/en-us/azure/container-apps/overview) and service invocation using the [Dapr](https://dapr.io/) client.

#### Resources

- [Developing microservices with Azure Container Apps](https://youtu.be/ILH1tJp0Vac) ๐ฝ๏ธ*1h - NDC-Conferences - Will Velida*
- [Build and push Docker Images to ARC using DevOps pipelines](https://thomasthornton.cloud/2021/12/16/build-and-push-docker-images-to-azure-container-registry-using-azure-devops-pipelines) ๐*Thomas Thornton (Azure solutions architect)*
---
- [Dapr for .NET Developers](https://learn.microsoft.com/en-us/dotnet/architecture/dapr-for-net-developers) ๐*eBook*
- [Dapr Service Invocation with Azure Container Apps](https://dev.to/willvelida/dapr-service-invocation-with-azure-container-apps-41p8) ๐*Will Velida*
- [Running your apps on Dapr](https://youtu.be/UoU7DmkXQNI) ๐ฝ๏ธ*55min - CodingNight*
- [Series of building gRPC microservice applications with Azure Container Apps and Dapr](https://bitoftech.net/2022/08/25/tutorial-building-microservice-applications-azure-container-apps-dapr) ๐*Taiseer Joudeh*
- *Geert Baeke*: [Container Apps and Dapr](https://youtu.be/s96io88CM6A) ๐ฝ๏ธ*30min* [Deploying and scaling Container Apps with Bicep and Keda](https://youtu.be/z_QnOKVpbkA) ๐ฝ๏ธ*21min*
- [Deploy to Azure Container App from ACR using Azure DevOps pipeline and Azure CLI](https://thomasthornton.cloud/2022/02/11/deploy-to-azure-container-app-from-azure-container-registry-using-a-ci-cd-azure-devops-pipeline-and-azure-cli) ๐*Thomas Thornton*
- Building microservices by using Dapr with minimum effort - *by Gรถkhan Gรถkalp*
  - ๐ [Part 1](https://www.gokhan-gokalp.com/en/building-microservices-by-using-dapr-and-net-with-minimum-effort-01) - Develop 2 simple services using a few building blocks of Dapr
  - ๐ [Part 2](https://www.gokhan-gokalp.com/en/building-microservices-by-using-dapr-and-net-with-minimum-effort-02-azure-container-apps) - Using Azure CLI to prepare Dapr components *(CosmosDB, ServiceBus)* and deploy Container App
- [Debugging Dapr applications with Visual Studio](https://laurentkempe.com/2023/02/27/debugging-dapr-applications-with-rider-or-visual-studio-a-better-way) ๐*Laurent Kempรฉ*
---
- [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) ๐*Microsoft-Learn*
- [Microsoft.App - ContainerApps](https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-bicep) ๐*Microsoft-Learn - Bicep template*
- [Bicep Playground with sample templates](https://bicepdemo.z22.web.core.windows.net)

###### The following services are defined in a bicep file

![Bicep-Visualize-main](images/Bicep-Visualize-main.JPG)

###### Deployed with Azure DevOps pipeline

![DevOps-Pipeline](images/DevOps-Pipeline.JPG)