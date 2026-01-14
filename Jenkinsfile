pipeline {
    agent { label 'ilia-label' } 

    environment {
        // ID твоего реестра
        IMAGE_NAME = 'cr.yandex/crpjaq4qifipfciciu4r/lab7-bot'
        
        // Добавляем папку с yc и docker-credential-yc в путь
        PATH = "/home/ubuntu/yandex-cloud/bin:$PATH"
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

        stage('Build & Push to Yandex') {
            steps {
                script {
                    sh 'cp infra/Dockerfile .'
                    
                    // Теперь docker login не нужен!
                    // Jenkins найдет программу-помощник и сам возьмет нужные ключи.
                    // (Мы используем тот же механизм, что ты настроил через configure-docker)
                    
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }

        stage('Deploy to Yandex K8s') {
            steps {
                script {
                    sh "kubectl apply -f infra/k8s.yaml"
                    // Перезапускаем под
                    sh "kubectl delete pod -l app=mt-bot -n ilia-lab7 || true"
                }
            }
        }
    }
}
