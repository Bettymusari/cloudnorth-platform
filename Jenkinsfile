pipeline {
    agent any

    environment {
        REGISTRY_CREDENTIALS = 'dockerhub-creds'
        DOCKERHUB_USERNAME = 'bettym72'
        BACKEND_IMAGE = 'bettym72/cloudnorth-backend'
        FRONTEND_IMAGE = 'bettym72/cloudnorth-frontend'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Backend Install & Test') {
            steps {
                dir('backend') {
                    sh 'npm ci'
                    sh 'npm run lint || true'
                    sh 'npm test || true'
                }
            }
        }

        stage('Frontend Install & Test') {
            steps {
                dir('frontend') {
                    sh 'npm ci'
                    sh 'npm run lint || true'
                    sh 'npm test || true'
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                script {
                    sh """
                    docker build -t ${BACKEND_IMAGE}:latest backend/
                    """
                }
            }
        }

        stage('Build Frontend Image') {
            steps {
                script {
                    sh """
                    docker build -t ${FRONTEND_IMAGE}:latest frontend/
                    """
                }
            }
        }

        stage('Push Images to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                    echo "$PASS" | docker login -u "$USER" --password-stdin

                    docker push ${BACKEND_IMAGE}:latest
                    docker push ${FRONTEND_IMAGE}:latest
                    """
                }
            }
        }

    }

    post {
        success {
            echo '🎉 SUCCESS: Backend & Frontend images pushed!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}

