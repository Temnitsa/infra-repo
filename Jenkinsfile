pipeline {
    agent { label 'ilia-label' } 

    environment {
        // ID твоего реестра
        IMAGE_NAME = 'cr.yandex/crpjaq4qifipfciciu4r/lab7-bot'
        
        // Твой Токен (я вставил тот, что ты скинул)
        YC_TOKEN = 't1.9euelZqbm5HJmZzIxo2QlIyeiZiSzO3rnpWay5uam8yKls2SkpGZk5jKkZbl8_cuJGI0-e8BBhgx_t3z925SXzT57wEGGDH-zef1656Vms2OxpaQxoqRk8nHx8qUnc3N.IjYADZnUqW4m4ub6GElOaU94YWcKY2KcB3MJqawOg5xKLzskJXI7mgFYDZWBcB1IMN4cKCYo-uEH6PosRXL9CA' 
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
                    
                    // Логинимся с твоим токеном
                    sh "echo $YC_TOKEN | docker login --username oauth --password-stdin cr.yandex"
                    
                    sh "docker build -t $IMAGE_NAME:latest ."
                    sh "docker push $IMAGE_NAME:latest"
                }
            }
        }

        stage('Deploy to Yandex K8s') {
            steps {
                script {
                    sh "kubectl apply -f infra/k8s.yaml"
                    // Удаляем под, чтобы он перезапустился с новым образом
                    sh "kubectl delete pod -l app=mt-bot -n ilia-lab7 || true"
                }
            }
        }
    }
}
