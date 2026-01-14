pipeline {
    agent { label 'ilia-label' } 

    environment {
        DOCKER_CREDS = credentials('docker-hub-creds')
        // ВАЖНО: Пушим в твой репозиторий, имя образа lab7-bot
        IMAGE_NAME = 'temnitsa/lab7-bot'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // 1. Качаем код Бота (Python)
                git url: 'https://github.com/1vmc1/MT.git', branch: 'master'
                
                // 2. Качаем конфиги
                dir('infra') {
                    git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main'
                }
            }
        }

        stage('Build & Push Docker') {
            steps {
                script {
                    // Копируем Dockerfile из папки infra в корень (к коду бота)
                    sh 'cp infra/Dockerfile .'
                    
                    // Логин
                    sh "echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin"
                    
                    // Сборка и Пуш
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }

        stage('Deploy to Yandex K8s') {
            steps {
                script {
                    // Применяем манифесты
                    sh "kubectl apply -f infra/k8s.yaml"
                    
                    // Перезапускаем бота
                    sh "kubectl rollout restart deployment/mt-bot-deployment -n ilia-lab7 || true"
                }
            }
        }
    }
    
    post {
        always {
            sh "docker logout || true"
        }
    }
}

