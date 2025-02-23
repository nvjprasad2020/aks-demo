pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                echo "Start fetching code from repo"
                git 'https://github.com/nvjprasad2020/aks-demo.git'
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean workspace after the build is complete
        }
    }
}
