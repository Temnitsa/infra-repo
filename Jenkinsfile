pipeline {
    agent { label 'ilia-label' } 

    environment {
        DOCKER_CREDS = credentials('docker-hub-creds')
        IMAGE_NAME = 'temnitsa/lab7-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Качаем ИНТЕРНЕТ-МАГАЗИН
                git url: 'https://github.com/reljicd/spring-boot-shopping-cart.git', branch: 'master'
                
                // Качаем инфраструктуру
                dir('infra') {
                    git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main'
                }
            }
        }

        stage('Build Java') {
            steps {
                // Собираем (пропуская тесты, так как для них нужна поднятая база)
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build & Push Docker') {
            steps {
                script {
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
                    // Чистим старое (опционально)
                    sh "kubectl delete deployment petclinic-deployment -n ilia-lab7 || true"
                    
                    // Деплоим Магазин и Базу
                    sh "kubectl apply -f infra/k8s.yaml"
                    
                    // Перезапускаем Магазин
                    sh "kubectl rollout restart deployment/shop-deployment -n ilia-lab7 || true"
                    
                    // Ждем MySQL (первый запуск долгий, создаются таблицы)
                    sh "sleep 45"
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
