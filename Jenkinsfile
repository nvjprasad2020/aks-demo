pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/nvjprasad2020/aks-demo.git'
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean workspace after the build is complete
        }
    }
}
