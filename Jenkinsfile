pipeline {
    agent { label 'ilia-label' } 
    environment {
        // ОБЯЗАТЕЛЬНО НОВОЕ ИМЯ (чтобы не было конфликтов слоев)
        IMAGE_NAME = 'temnitsa/lab7-bot-alpine'
        DOCKER_CREDS = credentials('docker-hub-creds')
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/1vmc1/MT.git', branch: 'master'
                dir('infra') { git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main' }
            }
        }
        stage('Build Push') {
            steps {
                script {
                    sh 'cp infra/Dockerfile .'
                    sh "echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin"
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh "kubectl apply -f infra/k8s.yaml"
                    // Удаляем старые висящие поды
                    sh "kubectl delete pod -l app=mt-bot -n ilia-lab7 || true"
                }
            }
        }
    }
}

