# Playing with Azure Container App
To be honest, there is not much in this repository. I experimented with the [Azure Container App](https://learn.microsoft.com/en-us/azure/container-apps/overview) and service invocation using the [Dapr](https://dapr.io/) client.

#### Resources

- [Developing microservices with Azure Container Apps](https://youtu.be/ILH1tJp0Vac) 📽️*1h - NDC-Conferences - Will Velida*
- [Dapr Service Invocation with Azure Container Apps](https://dev.to/willvelida/dapr-service-invocation-with-azure-container-apps-41p8) 📓*Will Velida*
- [Running your apps on Dapr](https://youtu.be/UoU7DmkXQNI) 📽️*55min - CodingNight*
- [Series of building gRPC microservice applications with Azure Container Apps and Dapr](https://bitoftech.net/2022/08/25/tutorial-building-microservice-applications-azure-container-apps-dapr) 📓*Taiseer Joudeh*
- *Geert Baeke*: [Container Apps and Dapr](https://youtu.be/s96io88CM6A) 📽️*30min* [Deploying and scaling Container Apps with Bicep and Keda](https://youtu.be/z_QnOKVpbkA) 📽️*21min*
- [Build and push Docker Images to ARC using DevOps pipelines](https://thomasthornton.cloud/2021/12/16/build-and-push-docker-images-to-azure-container-registry-using-azure-devops-pipelines) 📓*Thomas Thornton (Azure solutions architect)*
---
- [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) 📚*Microsoft-Learn*
- [Microsoft.App - ContainerApps](https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-bicep) 📚*Microsoft-Learn - Bicep template*
- [Bicep Playground with sample templates](https://bicepdemo.z22.web.core.windows.net)

###### The following services are defined in a bicep file

![Bicep-Visualize-main](images/Bicep-Visualize-main.JPG)

###### Deployed with Azure DevOps pipeline

![DevOps-Pipeline](images/DevOps-Pipeline.JPG)