pipeline {
    agent any

    tools {
        maven 'Maven 3.9.6'  // This must match the name set in Jenkins Global Tool Configuration
    }
    environment {
        MAVEN_OPTS = "--add-opens=java.base/java.lang=ALL-UNNAMED"
        BUILD_VERSION = "1.0.${BUILD_ID}"
        DOCKER_IMAGE = "nvjprasad/aks-demo:${BUILD_VERSION}"
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
    }

    stages {
        stage('Check Maven Version') {
            steps {
                script {
                    sh 'mvn --version'  // Ensure the correct version is used
                }
            }
        }
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/nvjprasad2020/aks-demo.git'
            }
        }
        stage('Build Maven Project and Docker Image') {
            steps {
                script {
                    sh 'mvn clean install -U'  // Force dependency updates
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
                        kubectl get pods -n your-namespace  # Debug AKS pods
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean workspace after build
        }
    }
}
