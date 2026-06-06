pipeline {
    agent any 

    stages {
        stage ('1.Checkout SCM') {
            steps {
                checkout scm
            }
        }
        stage ('2. Build Docker Image') {
            steps {
                sh 'docker build -t sriramsrb/aura-anime:latest .'
            }
        }
        stage ('3. Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: "dockerhub", variable: "DOCKER_PWD")]) {
                    sh 'echo $DOCKER_PWD | docker login -u sriramsrb --password-stdin'
                    sh 'docker push sriramsrb/aura-anime:latest'
                }
            }
        }
        stage ('4. Deploy to kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yml'
                sh 'kubectl rollout restart deployment aura-anime-deployment'
            }
        }
    }
}
