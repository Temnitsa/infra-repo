pipeline {
    agent { label 'ilia-label' } 

    stages {
        stage('Checkout Infrastructure') {
            steps {
                // Качаем ТОЛЬКО твой репозиторий с конфигами
                git url: 'https://github.com/Temnitsa/infra-repo', branch: 'main'
            }
        }

        stage('Deploy to Yandex K8s') {
            steps {
                script {
                    // Удаляем всё старое
                    sh "kubectl delete all --all -n ilia-lab7 || true"
                    
                    // Применяем конфиг бота
                    sh "kubectl apply -f k8s.yaml"
                    
                    // Перезапускаем
                    sh "kubectl rollout restart deployment/mt-bot-deployment -n ilia-lab7 || true"
                    
                    // Ждем запуска
                    sh "sleep 10"
                }
            }
        }
    }
}
