pipeline {
    agent { label 'ilia-label' } 

    environment {
        DOCKER_CREDS = credentials('docker-hub-creds')
        IMAGE_NAME = 'temnitsa/lab7-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // 1. Качаем проект Money Transfer
                // Ветка master (стандарт для старых репо)
                git url: 'https://github.com/1vmc1/MT.git', branch: 'master'
                
                // 2. Качаем твои конфиги
                dir('infra') {
                    git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main'
                }
            }
        }

        stage('Build Java') {
            steps {
                // Собираем JAR
                // -DskipTests обязательно, так как у нас нет внешней БД для тестов
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build & Push Docker') {
            steps {
                script {
                    // Копируем Dockerfile
                    sh 'cp infra/Dockerfile .'
                    
                    sh "echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin"
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }

        stage('Deploy to Yandex K8s') {
            steps {
                script {
                    // Применяем конфиг
                    sh "kubectl apply -f infra/k8s.yaml"
                    
                    // Перезапускаем (на случай, если под уже был)
                    sh "kubectl rollout restart deployment/mt-deployment -n ilia-lab7 || true"
                    
                    // Ждем 20 секунд (приложение легкое)
                    sh "sleep 20"
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
