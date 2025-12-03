pipeline {
    agent any

    environment {
        // Your Docker Hub username
        DOCKER_HUB_USER = 'medazizhammami' 
        // The name for my image 
        IMAGE_NAME = 'my-test-app' 
        // The credentials ID 
        REGISTRY_CREDS = 'docker-hub-creds'
        // ----------------------------
    }

    stages {
        stage('Checkout') {
            steps {
                
                git branch: 'main', url: 'https://github.com/Mutedly007/timesheetproject.git'
            }
        }

        stage('Clean & Build App') {
            steps {
                echo 'Cleaning and Building application...'
                // If this is a Java/Maven project, you would run: 
                // sh 'mvn clean package'
                // If it is just a simple HTML/Python file, we just echo:
                sh 'echo "Application cleaned and prepared (simulated)"'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker Image...'
                    // This builds the image using the Dockerfile in your repo
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Logs into Docker Hub using the secure credentials
                    withCredentials([usernamePassword(credentialsId: REGISTRY_CREDS, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    }
                }
            }
        }

        stage('Push Image to Registry') {
            steps {
                script {
                    echo 'Pushing image to Docker Hub...'
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                echo 'Cleaning up local images to save space...'
                // Remove the image from the local VM so it doesn't clutter up
                sh "docker rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
            }
        }
    }
}
