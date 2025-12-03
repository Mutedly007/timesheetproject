pipeline {
    agent any

    // MAKE SURE THESE NAMES MATCH YOUR JENKINS TOOLS CONFIG
    tools { 
        jdk 'JAVA_HOME' 
        maven 'M2_HOME' 
    }

    environment {
        // --- YOUR VARIABLES ---
        DOCKER_HUB_USER = 'medazizhammami' 
        IMAGE_NAME = 'timesheet-app'
        REGISTRY_CREDS = 'docker-hub-creds'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Mutedly007/timesheetproject.git' 
            }
        }

        stage('Clean & Compile') {
            steps {
                echo 'Compiling with Maven...'
                // THIS COMMAND CREATES THE JAR FILE
                sh 'mvn clean package -Dmaven.test.skip=true'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker Image...'
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                    sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    echo 'Pushing to Docker Hub...'
                    withCredentials([usernamePassword(credentialsId: REGISTRY_CREDS, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }
    }
}
