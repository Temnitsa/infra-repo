pipeline {
    agent { label 'Ilia-Node' } 

    environment {
        DOCKER_CREDS = credentials('docker-hub-creds')
        IMAGE_NAME = 'temnitsa/lab7-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Temnitsa/infra-repo'
            }
        }

        stage('Build Java') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build & Push Docker') {
            steps {
                script {
                    sh "echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin"
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }

        stage('Deploy to Yandex K8s') {
            steps {
                script {
                    // Применяем манифесты (Deployment и Service)
                    sh "kubectl apply -f k8s.yaml"

                    // Перезапускаем деплоймент в твоем namespace
                    sh "kubectl rollout restart deployment/lab7-deployment -n ilia-lab7 || true"
                }
            }
        }
    }
    
    post {
        always {
            sh "docker logout"
        }
    }
}
