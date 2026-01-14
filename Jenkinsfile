pipeline {
    agent { label 'ilia-label' } 

    environment {
        // Вернулись на Docker Hub
        IMAGE_NAME = 'temnitsa/lab7-bot'
        // Берем пароль от Docker Hub из Jenkins Credentials
        DOCKER_CREDS = credentials('docker-hub-creds')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/1vmc1/MT.git', branch: 'master'
                dir('infra') {
                    git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main'
                }
            }
        }

        stage('Build & Push to DockerHub') {
            steps {
                script {
                    sh 'cp infra/Dockerfile .'
                    
                    // Логинимся в Docker Hub
                    sh "echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin"
                    
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }

        stage('Deploy to Yandex K8s') {
            steps {
                script {
                    sh "kubectl apply -f infra/k8s.yaml"
                    // Удаляем под
                    sh "kubectl delete pod -l app=mt-bot -n ilia-lab7 || true"
                }
            }
        }
    }
}
