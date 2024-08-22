# Playing with Azure Container App
Actually, there is not much code in this repository. I experimented with the [Azure Container App](https://learn.microsoft.com/en-us/azure/container-apps/overview) and service invocation using the [Dapr](https://dapr.io/) client

In my other repository, you can find additional [resources about Dapr](https://github.com/19balazs86/PlayingWithDapr) 👤*PlayingWithDapr*

#### Resources

- [Documentation](https://learn.microsoft.com/en-us/azure/container-apps/overview) 📚*MS-Learn* | [Pricing](https://azure.microsoft.com/en-us/pricing/details/container-apps)
  - [Aspire Dashboard](https://learn.microsoft.com/en-us/azure/container-apps/aspire-dashboard?pivots=portal) | *It uses SSO to login. Assign the role: 'Container Apps ManagedEnvironments Contributor' to the user you use in Azure Portal (the one with your email address)*
  - [Authentication and authorization](https://learn.microsoft.com/en-us/azure/container-apps/authentication) 📚*Microsoft Learn*
    - [Access user claims in application code](https://johnnyreilly.com/azure-container-apps-easy-auth-and-dotnet-authentication) 📓*Johnny Reilly*
  - Event driven processing: [App](https://learn.microsoft.com/en-us/azure/container-apps/background-processing) and [Job](https://learn.microsoft.com/en-us/azure/container-apps/tutorial-event-driven-jobs) | [Key concept of Jobs](https://learn.microsoft.com/en-us/azure/container-apps/jobs)
- [.NET Containers advancements in .NET 8](https://youtu.be/scIAwLrruMY) 📽️*25 min - DotNet*
- [Developing microservices with Azure Container Apps](https://youtu.be/npVfxDiEyeg) 📽️*1h - Jakob Ehn - NDC Oslo 2023*
- [Build and push Docker Images to ARC using DevOps pipelines](https://thomasthornton.cloud/2021/12/16/build-and-push-docker-images-to-azure-container-registry-using-azure-devops-pipelines) 📓*Thomas Thornton (Azure solutions architect)*
- [Bicep template for ContainerApps](https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-bicep) 📚*MS-Learn*

###### The following services are defined in a bicep file

![Bicep-Visualize-main](images/Bicep-Visualize-main.JPG)

###### Deployed with Azure DevOps pipeline

![DevOps-Pipeline](images/DevOps-Pipeline.JPG)