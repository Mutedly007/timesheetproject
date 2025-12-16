pipeline {
    agent any

    tools { 
        jdk 'JAVA_HOME' 
        maven 'M2_HOME' 
    }

    environment {
        DOCKER_HUB_USER = 'medazizhammami'
        IMAGE_NAME = 'timesheet-app'
        REGISTRY_CREDS = 'docker-hub-creds'
        KUBE_NAMESPACE = 'devops'
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

        stage('Deploy to Kubernetes') {
        steps {
            script {
                echo 'Deploying to Kubernetes...'
                sh '''
                kubectl apply -f k8s/mysql-deployment.yaml -n $KUBE_NAMESPACE
                kubectl apply -f k8s/spring-deployment.yaml -n $KUBE_NAMESPACE
                
                # FORCE RESTART to pick up the new 'latest' image
                kubectl rollout restart deployment/spring-app -n $KUBE_NAMESPACE
                
                # Wait for the rollout to finish
                kubectl rollout status deployment/spring-app -n $KUBE_NAMESPACE
                '''
            }
        }
    }

     stage('Test Application') {
        steps {
            script {
                echo 'Testing the Spring Boot app...'
    
                sh 'sleep 60'
                

                sh '''
                kubectl run test-curl -i --rm --restart=Never --image=curlimages/curl -n $KUBE_NAMESPACE -- \
                  curl -s -v -X POST http://spring-service:8080/timesheet-devops/user/add-user \
                  -H "Content-Type: application/json" \
                  -d '{"firstName": "zizou", "lastName": "ham", "role": "ADMINISTRATEUR", "dateNaissance": "2025-02-12"}'
                '''
            }
        }
    }

    }
}
