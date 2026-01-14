pipeline {
    agent { label 'ilia-label' } 
    environment {
        DOCKER_CREDS = credentials('docker-hub-creds')
        IMAGE_NAME = 'temnitsa/lab7-bot' // ТВОЙ репозиторий, не 1vmc1
    }
    stages {
        stage('Checkout') {
            steps {
                // Качаем код бота
                git url: 'https://github.com/1vmc1/MT.git', branch: 'master'
                // Качаем инфраструктуру
                dir('infra') { git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main' }
            }
        }
        stage('Build Docker') {
            steps {
                script {
                    // Берем Dockerfile
                    sh 'cp infra/Dockerfile .'
                    // Логин
                    sh "echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin"
                    // Собираем
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh "kubectl apply -f infra/k8s.yaml"
                    sh "kubectl rollout restart deployment/mt-bot-deployment -n ilia-lab7"
                }
            }
        }
    }
}
