pipeline {
    agent any
    
    environment {
        DOCKER_HUB_REPO = 'matusalemme/react-app'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        CREDENTIALS_ID  = 'dockerhub_credentials'
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Build & Tag Image') {
            steps {
                script {
                    appImage = docker.build("${DOCKER_HUB_REPO}:${IMAGE_TAG}")
                    appImageLatest = docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }
        
        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${CREDENTIALS_ID}") {
                        appImage.push()
                        appImageLatest.push()
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
                sh "kubectl set image deployment/react-app-deployment react-app=${DOCKER_HUB_REPO}:${IMAGE_TAG}"
                sh 'kubectl rollout status deployment/react-app-deployment'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}