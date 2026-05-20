pipeline {
    agent any

    stages {
        stage ('1. Checkout code') {
            checkout scm
        }
    }
    stage ('2. Build docker image') {
        steps {
            sh 'docker build -t sriramsrb/aura-anime:latest .'
        }
    }
    stage ('3. Push docker image to docker hub') {
        steps {
            withCredentials([string(credentialsId: 'dockerhub-user', variable: 'DOCKER_PWD')]) {
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