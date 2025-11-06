pipeline {
    agent any
    
    tools{
        maven "maven"
    }
    
    stages {
        stage("git checkout"){
            steps{
                git branch: 'main', url: 'https://github.com/AAPaintsil24/web-app.git'
            }
        }
        stage("clean and package"){
            steps{
                sh "mvn clean package"
            }
        }
        
        stage("code analysis"){
            environment {
                ScannerHome = tool "codescan"
            }
            steps {
                script{
                    withSonarQubeEnv("sonarserver"){
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=albertcloudz2"
                    }
                }
            }
        }
        
        stage('Quality gate'){
            steps{
                timeout(time: 1, unit: 'HOURS'){
                    waitForQualityGate abortPipeline: false
                }
            }
        }
        
        stage("nexus uploads"){
            steps{
                nexusArtifactUploader artifacts: [[artifactId: 'maven-web-application', classifier: '', file: '/var/lib/jenkins/workspace/albert-pipeline/target/web-app.war', type: 'war']], credentialsId: 'nexus-credentials', groupId: 'com.mt', nexusUrl: '16.16.98.219:8081/repository/albertcloudz2/', nexusVersion: 'nexus3', protocol: 'http', repository: 'albertcloudz2', version: '3.0.6-RELEASE'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build "albertarko/albertdevops:1"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-credentials') {
                        docker.image("albertarko/albertdevops:1").push()
                    }
                }
            }
        }
        
        
        stage("deployment to production"){
            steps{
                deploy adapters: [tomcat9(alternativeDeploymentContext: '', credentialsId: 'tomcat_credentials', path: '', url: 'http://16.16.200.185:8080/')], contextPath: null, war: 'target/web-app.war'
            }
        }
    }
    
    post{
         success { slackSend(color: 'good', message: "build success: ${env.JOB_NAME} #${env.BUILD_NUMBER}") } 
         failure { slackSend(color: 'danger', message: "build failure: ${env.JOB_NAME} #${env.BUILD_NUMBER}") } 
         aborted { slackSend(color: 'warning', message: "build aborted: ${env.JOB_NAME} #${env.BUILD_NUMBER}") }
    }
    
}