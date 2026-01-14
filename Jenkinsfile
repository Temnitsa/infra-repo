pipeline {
    agent { label 'ilia-label' } 

    environment {
        DOCKER_CREDS = credentials('docker-hub-creds')
        IMAGE_NAME = 'temnitsa/lab7-app'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // 1. Ссылка на официальный репозиторий PetClinic
                git url: 'https://github.com/spring-projects/spring-petclinic.git', branch: 'main'
                
                // 2. Ваши конфиги
                dir('infra') {
                    git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main'
                }
            }
        }

        stage('Build Java') {
            steps {
                // Собираем (без тестов, чтобы быстрее)
                // Заметьте: мы убрали блок dir('complete'), так как код в корне
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build & Push Docker') {
            steps {
                script {
                    // Копируем Dockerfile из infra в корень (где лежит target)
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
                    sh "kubectl apply -f infra/k8s.yaml"
                    
                    // Перезапускаем деплоймент petclinic
                    sh "kubectl rollout restart deployment/petclinic-deployment -n ilia-lab7 || true"
                    
                    // Ждем подольше (PetClinic тяжелый, стартует секунд 30-40)
                    sh "sleep 40"
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
