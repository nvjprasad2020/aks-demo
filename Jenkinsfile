pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nvjprasad/aks-demo:${BUILD_ID}"  // Docker image name
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'  // Docker Hub credentials ID
        KUBECONFIG = '/root/.kube/config'  // Path to kubeconfig for AKS
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/nvjprasad2020/aks-demo.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID,
                                                      usernameVariable: 'DOCKER_USERNAME',
                                                      passwordVariable: 'DOCKER_PASSWORD')]) {
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
                    withCredentials([file(credentialsId: 'aks-kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                        sh '''
                        export KUBECONFIG=$KUBECONFIG_FILE
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                        '''
                    }
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
