pipeline {
    agent any

    environment {
        // Automatically use repository name for Docker image name and tag
        DOCKER_IMAGE = "nvjprasad/aks-demo:${BUILD_ID}"  // Replace 'nvjprasad' with your Docker Hub username or ACR name
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'  // Jenkins credentials ID for Docker Hub or ACR registry
        KUBECONFIG = '/root/.kube/config'  // Path to kubeconfig for AKS (update if different)
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from your GitHub repository
                git 'https://github.com/nvjprasad2020/aks-demo.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with Java 17 (make sure you have a Dockerfile in the repo)
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }
        stage('Push Docker Image to Registry') {
            steps {
                script {
                    // Log in to Docker Hub or Azure Container Registry (ACR)
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push $DOCKER_IMAGE
                        '''
                    }
                }
            }
        }
        stage('Deploy to AKS') {
            steps {
                script {
                    // Apply Kubernetes configuration files (ensure k8s/deployment.yaml exists in the repo)
                    sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean workspace after the build is complete
        }
    }
}
