# 🧩 DevOps End-to-End CI/CD Pipeline Project

## Overview
This project demonstrates a complete DevOps CI/CD workflow using **Jenkins**, **SonarQube**, **Nexus**, and **Tomcat**, all deployed on **AWS EC2**. The goal is to automate the build, test, and deployment process for a Java web application.

## 🧠 Technologies Used
- Jenkins for CI/CD
- SonarQube for code quality analysis
- Nexus for artifact storage
- Tomcat for application deployment
- AWS EC2 (Ubuntu)
- Git & GitHub for version control

## ⚙️ Pipeline Workflow
1. Developer pushes code to GitHub
2. Jenkins triggers automatically
3. Jenkins performs build using Maven
4. SonarQube performs code quality analysis
5. Nexus stores the artifact (WAR file)
6. Jenkins deploys the artifact to Tomcat on EC2

## 🏗️ Architecture Diagram
![Architecture](Docs/ci-cd-pipeline-flow.png)


## ⚙️ Setting Up Jenkins on AWS EC2 (t3.medium)

Jenkins was installed on an **AWS EC2 Ubuntu t3.medium instance**, which provides a balanced mix of CPU and memory suitable for running CI/CD workloads.  
The setup followed the step-by-step guide from the [Jenkins Setup Site](https://www.jenkins.io/doc/book/installing/), including the installation of required dependencies such as **Java**, **Git**, and the **Jenkins service** configuration.

After installation, Jenkins was accessed through the default port **8080**, where the **initial setup page** appeared, prompting for the administrator password and plugin configuration.

📸 **Screenshot:**
![Initial Jenkins setup and unlock screen](Screenshots/jenkins-setup.png)
This server now serves as the **core automation engine** of the CI/CD pipeline, connecting seamlessly with **GitHub (via webhooks)**, **SonarQube**, **Nexus**, and **Tomcat** for continuous integration and deployment.

## 🧩 Setting Up SonarQube for Code Quality Analysis

SonarQube was installed on a dedicated **AWS EC2 Ubuntu instance (t3.medium)** and integrated with Jenkins to perform **automated code quality checks** after every build.  
The installation followed the guide in the [SonarQube Official Site for Setup](https://docs.sonarsource.com/sonarqube-server/server-installation/introduction), which includes steps for setting up **PostgreSQL**, configuring **SonarQube as a system service**, and opening the default **port 9000** for access.

Once the server was up and running, the **initial SonarQube dashboard** appeared, allowing configuration of projects, tokens, and **Quality Gates** to enforce clean code standards.

📸 **Screenshot:**  
![Initial SonarQube Dashboard](Screenshots/initial-dashboard.png)

A custom **Quality Gate** was defined to ensure that:
- Code coverage remains above a set threshold  
- No new critical issues or bugs are introduced  
- Maintainability, reliability, and security ratings remain within acceptable limits  

📸 **Screenshot:**  
![SonarQube Quality Gate Configuration](Screenshots/quality-gate.png)


### 🔐 Integrating SonarQube with Jenkins

To enable Jenkins to communicate securely with SonarQube, the **SonarQube Scanner** plugin was installed and configured in Jenkins.  
This setup allows Jenkins to trigger code analysis automatically during the pipeline execution.

Steps:
1. Navigate to **Manage Jenkins → System → SonarQube Servers**
2. Add a new server name (e.g., `sonarserver`)
3. Provide the **Server URL** (e.g., `http://<your-sonarqube-server>:9000`)
4. Add and select the **Authentication Token** generated from SonarQube under Jenkins credentials

📸 **Screenshot:**  
![SonarQube Credentials Configuration in Jenkins](Screenshots/jenkins-sonarqube.png)

Once configured, the Jenkins pipeline can reference the server using:
stage("code analysis"){
            environment {
                ScannerHome = tool "codescan"
            }
            steps {
                script{
                    withSonarQubeEnv("sonarserver"){
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=projectname"
                    }
                }
            }
        }

### 🧱 Custom Quality Gate Configuration

SonarQube was configured with a **custom Quality Gate** focused on essential metrics that define clean, maintainable, and secure code.  
The gate helps ensure that every build meets baseline standards before deployment.

**Quality Gate Metrics:**
| Metric | Description | Target |
|--------|--------------|--------|
| **Issues** | Overall code issues detected (bugs, code smells, vulnerabilities) |
| **Security Hotspots Reviewed** | Number of security hotspots manually reviewed | 100% reviewed |
| **Duplicated Lines (%)** | Percentage of duplicated code | Less than **3%** |
| **Coverage** | Test coverage of new and changed code | Greater than **80%** |

📸 **Screenshot:**
![SonarQube Quality Gate Dashboard](Screenshots/sonarqube_metrics.png)

This gate was assigned to the main project, ensuring that any build failing to meet these conditions will **not pass** the Jenkins CI pipeline.  
This setup promotes better **code security**, **maintainability**, and **team accountability** in the development lifecycle.

This setup ensures that Jenkins pipelines automatically trigger SonarQube analysis for every commit, providing developers with immediate feedback on code quality and technical debt.


## 🏗️ Nexus Repository Setup

**Nexus Repository Manager** was used as the artifact repository to store and version the `.war` files generated from Jenkins builds.  
This ensures consistent artifact management, traceability, and smooth deployment to the Tomcat server.

## 🏗️ Nexus Repository Setup

**Nexus Repository Manager** was used as the artifact repository to store and version the `.war` files generated from Jenkins builds.  
This ensures consistent artifact management, traceability, and smooth deployment to the Tomcat server.

### ⚙️ Configuration Overview

1. **Installation:**  
   Nexus was installed on an **AWS EC2 Ubuntu t3.medium instance** using the official [Sonatype Nexus 3.x distribution](https://help.sonatype.com/repomanager3/installation).  
   After installation, the service was configured to start automatically and exposed on port `8081`.

2. **Repository Setup:**  
   A new hosted **Maven (release)** repository was created and named: albertcloudz

This repository serves as the destination for the `.war` artifacts uploaded from Jenkins after successful builds.

3. **Jenkins Integration:**  
In Jenkins, the **Nexus Artifact Uploader Plugin** was configured with:
- **Repository URL:** `http://<nexus-server-ip>:8081/repository/albertcloudz/`  
- **Credentials:** A Nexus username and token securely stored in Jenkins credentials  
- **GroupId / ArtifactId / Version:** Automatically mapped from the project’s `pom.xml`  

Once the build is complete, Jenkins uploads the packaged `.war` file to Nexus.

### 📦 Artifact Storage Example

Below is an example of the deployed artifact visible in the Nexus dashboard:

📸 **Screenshot:**  
![Nexus Repository Artifact](Screenshots/nexus-artifact-deployed.png)

| Attribute | Example |
|------------|----------|
| **Group ID** | `com.mt` |
| **Artifact ID** | `maven-web-application` |
| **Version** | `3.0.6-RELEASE` |
| **File Type** | `.war` |
| **Repository** | `albertcloudz` |

This setup enables reliable artifact storage, supports rollback in case of failed deployments, and improves overall CI/CD workflow efficiency.

## 🚀 Apache Tomcat Deployment

**Apache Tomcat** serves as the final stage of this CI/CD pipeline — the environment where the packaged `.war` file is deployed and made accessible to users.  
After Jenkins builds the code, runs SonarQube analysis, and uploads the artifact to Nexus, it automatically deploys the web application to **Tomcat 9** hosted on an **AWS EC2 t3.medium (Ubuntu)** instance.

---

### ⚙️ Configuration Overview

1. **Installation:**  
   Tomcat 9 was installed on an Ubuntu-based EC2 instance.  
   For full installation instructions, follow the [official Apache Tomcat documentation](https://tomcat.apache.org/tomcat-9.0-doc/setup.html).

2. **User Configuration:**  
   A deployment user was created in the `tomcat-users.xml` file with the `manager-script` role to enable Jenkins to deploy automatically via the **Deploy to Container** plugin.

   <role rolename="manager-script"/>
   <user username="deployer" password="your_password" roles="manager-script"/>
### 🧩 Jenkins Integration

In Jenkins, the **Deploy to Container Plugin** was configured as follows:

| Configuration Item | Value |
|--------------------|--------|
| **Container Type** | Tomcat 9.x |
| **Manager URL** | `http://<ec2-public-ip>:8080/manager/text` |
| **Credentials** | `deployer` *(stored securely under Jenkins credentials)* |
| **WAR File Path** | `target/web-app.war` |


---

### 🔒 Security Group Configuration

Port **8080** was opened in the EC2 instance’s **security group** to allow external access to both the Tomcat Manager interface and the deployed web application.

---

### 🌐 Deployment Verification

Once Jenkins completes the pipeline successfully, the application is deployed automatically to **Apache Tomcat**.  
You can verify the deployment through the **Tomcat Web Application Manager**, which displays the deployed web applications, their paths, and running statuses.

📸 **Screenshot:**  
*Tomcat Web Application Manager showing the deployed application*  
![Tomcat Manager](Screenshots/tomcat.png)

---

You can also access the deployed web application directly via the EC2 public IP and Tomcat port: 8080

📸 **Screenshot:**  
*Deployed web application running successfully on Tomcat*  
![Deployed Web App](Screenshots/deployed-webapp.png)

---

## 🐳 Docker Build and Push Integration

After everything, I felt Docker had to be integrated into the CI/CD pipeline.  
This stage automates building Docker images from the project source and pushing them to **DockerHub** upon successful build completion.

---

### ⚙️ Jenkins Docker Credentials Setup

DockerHub credentials were securely stored in Jenkins under **Manage Jenkins → Credentials** to authenticate image uploads during the pipeline run.

📸 **Screenshot:**  
![Jenkins Docker Credentials Configuration](Screenshots/jenkins-docker-credentials.png)



### 📦 DockerHub Repository (Before Push)

Before the Jenkins build, the DockerHub repository was empty — showing that no image had been uploaded yet.

📸 **Screenshot:**  
![DockerHub Empty Repository](Screenshots/Initial-dockerhub-page.png)


### 🚧 Failed Docker Build and Push Attempt

The first pipeline run failed due to Docker not being available on the Jenkins build node.  
The error `docker: not found` confirmed that the Docker CLI was missing in the environment.

📸 **Screenshot:**  
![Jenkins Pipeline Failed Docker Build](Screenshots/jenkins-failed-docker.png)

---

### ✅ Successful Docker Build and Push

After installing Docker and reconfiguring Jenkins environment variables, the pipeline was re-run.  
This time, it successfully **built** and **pushed** the image to DockerHub.

📸 **Screenshot:**  
![Jenkins Pipeline Success Docker Build](Screenshots/jenkins-success-docker.png)

📸 **Screenshot:**  
![Docker Update with albertdevops Image](Screenshots/uploaded-albertdevops.png)

**Build Log Output:**
bash
+ docker build -t albertarko/albertdevops:1 .
+ docker push albertarko/albertdevops:1





### ✅ Summary

This configuration ensures a **fully automated CI/CD delivery process** where:

### ⚙️ Toolchain Overview

- 🧱 **Jenkins** builds and tests the source code  
- 🧩 **SonarQube** performs code quality checks  
- 🏗️ **Nexus** stores versioned build artifacts  
- 🐳 **Docker** builds container images and pushes them to DockerHub  
- 🚀 **Tomcat** automatically deploys the final `.war` file  
- 💬 **Slack** sends real-time build status notifications 

## 💬 Slack Integration & Final Pipeline Verification

To complete the CI/CD setup, Slack was integrated with Jenkins to provide **real-time notifications** on build and deployment status.  
This ensures visibility for the development team without needing to check the Jenkins dashboard manually.



### 🚦 Jenkins Pipeline Stage View

After triggering the pipeline, Jenkins automatically executed all configured stages — including build, test, SonarQube code analysis, artifact upload, and deployment.  
The **Stage View** clearly shows the sequence and success of each stage.

📸 **Screenshot:**  
*Jenkins Pipeline Stage View showing successful stages*  
![Jenkins Pipeline Stage View](Screenshots/final-jenkins-display.png)


### 🔔 Slack Build Notification

Once the pipeline completed successfully, Jenkins sent an automatic notification to the connected **Slack channel**.  
This message confirmed that all stages were executed without error, marking the build as a success.

📸 **Screenshot:**  
*Slack channel showing build success notification from Jenkins*  
![Slack Success Notification](Screenshots/final-slack-display.png)



### ✅ Summary

With this integration:
- Jenkins manages the entire CI/CD pipeline.
- Slack provides instant build status alerts.
- The pipeline flow (Build → Test → Code Analysis → Deploy) runs smoothly and visibly.
- This closes the loop of **continuous integration and delivery with automated team communication**.

