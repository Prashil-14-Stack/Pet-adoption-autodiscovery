<h1>Pet-adoption-autodiscovery project</h1>

The aim of this project is to build a java based highly scalable, highly available and self healing application using jenkins pipeline.
We write the ansible bash script to configure the newly provisioned instances build using auto scaling group, (as the asg is responsible only for instances and not for the application). We have established a SSL certificate to boost customers confidence.

Tech stack used:
1. Sonarqube - Code analysis
2. Bastion host - Works as a jump server
3. Nexus repo - Storing the image (Nexus - Docker repo)
4. Ansible - Continuous configuration management (as it helps discover newly provisioned instances and deploy application), 
             continous deployment
5. Jenkins - CI/CD tool
6. Newrelic - Monitoring of applications and instances
7. Github - Version control
8. RDS - Database

Different stages of jenkins pipeline:
1. Developers will push the code to github
2. Jenkins will notify sonarqube for code analysis
3. Invoke maven to build artifacts from POM.xml
4. Jenkins uses docker to build an image from artifact by using docker file
5. Jenkins push the image to docker repo
6. Jenkins ssh into the ansible server to trigger ansible playbook (a. Going to nexus repo , b. Pulling the image, c. Deploying into env.)

<img width="794" alt="image" src="https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/6232e7c8-59ff-490f-81c5-ac3707818154">

Steps:

1. Vault Initialization
2. Initialize Vault Server
3. Log into Vault Server 
4. Enable Key-Value (KV) Secrets Engine 
5. Set credentials

![image](https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/3989b85b-b56e-4439-8136-ae5d3c9471fd)

7. SSH into the jenkins server using bastion host to get the credentials for jenkins login
8. write a jenkins pipeline, make sure you have the latest ip address of ansible
   
<img width="794" alt="image" src="https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/9c533342-0f1d-4124-bfc5-1f61de641969">

10. Install necessary plugins ssh-agent,maven and sonarqube
11. Set up JDK installation on jenkins
12. Go to sonarqube, generate a token to use as credential for sonarqube
    
<img width="806" alt="image" src="https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/72b0618b-42a1-4f26-8932-bb3e3fe3ea7e">

12. Set up necessary credentials (nexus-username, nexus-repo, nexus-password,sonarqube,ansible-key)

<img width="808" alt="image" src="https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/b0f7e2ab-65cb-4af9-879b-55b211502a19">

13. Set up a webhook on sonarqube
14. Login into nexus repo
15. Create a docker hosted repository and add realms for security reasons
   
![image](https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/83e156d9-1ada-4381-a650-86c2737fe71b)

![image](https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/1ebcd3c4-fac3-452b-bf61-2f5abff2a83f)

16. Generate API token to collabrate with git by clicking on admin > configure > API Token > generate
17. Configure webhook on git
18. Attach git repo to fetch the latest version of code
19. Build the jenkins pipeline

![image](https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/65049ed2-8159-46c5-a7df-98b910d34de0)

![image](https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/64ce2e53-57d9-43f7-8564-5dccb044ebbf)

![image](https://github.com/Prashil-14-Stack/Pet-adoption-autodiscovery/assets/80506278/b41e1aad-8cae-4937-9f28-a12b7fc72f33)



