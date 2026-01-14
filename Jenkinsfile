pipeline {
    agent { label 'ilia-label' }  // Проверьте лейбл! У вас был 'Ilia-Node', а в настройках ноды 'ilia-label'.

    environment {
        // Ваши креды
        DOCKER_CREDS = credentials('docker-hub-creds')
        IMAGE_NAME = 'temnitsa/lab7-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // 1. Качаем код приложения (Java) в текущую папку
                git url: 'https://github.com/jenkins-docs/simple-java-maven-app.git', branch: 'master'
                
                // 2. Качаем ваши конфиги (Dockerfile, k8s.yaml) в подпапку infra
                dir('infra') {
                    git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main'
                }
            }
        }

        stage('Build Java') {
            steps {
                // Собираем Jar
                sh 'mvn clean package -Denforcer.skip=true'
            }
        }

        stage('Build & Push Docker') {
            steps {
                script {
                    // Копируем Dockerfile из папки infra к коду
                    sh 'cp infra/Dockerfile .'
                    
                    // Логин и пуш
                    sh "echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin"
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }

        stage('Deploy to Yandex K8s') {
            steps {
                script {
                    // Применяем манифест из папки infra
                    sh "kubectl apply -f infra/k8s.yaml"

                    // Перезапускаем деплоймент в namespace ilia-lab7
                    sh "kubectl rollout restart deployment/lab7-deployment -n ilia-lab7 || true"
                    
                    // Ждем и показываем статус
                    sh "sleep 10"
                    sh "kubectl get pods -n ilia-lab7"
                    sh "kubectl get svc -n ilia-lab7"
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
