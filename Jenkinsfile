pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Backend Setup') {
            steps {
                dir('backend') {
                    sh 'npm ci'
                    sh 'npm run lint'
                }
            }
        }

        stage('Frontend Setup') {
            steps {
                dir('frontend') {
                    sh 'npm ci' 
                    sh 'npm run lint'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh 'npm run build'
                }
            }
        }

        stage('Docker Test') {
            steps {
                sh 'docker-compose build --no-cache'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
        }
        success {
            echo '✅ SUCCESS: All stages completed!'
        }
    }
}
