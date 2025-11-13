pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Backend - Lint & Test') {
            steps {
                dir('backend') {
                    sh 'npm ci'  // Clean install for CI
                    sh 'npm run lint'  // ESLint for backend
                    sh 'npm test'  // Jest tests (coverage configured in package.json)
                }
            }
            post {
                always {
                    // Only publish JUnit results if the file exists and has content
                    script {
                        def testResults = findFiles(glob: 'backend/test-results/junit.xml')
                        if (testResults) {
                            junit 'backend/test-results/junit.xml'
                        } else {
                            echo 'No test results found, skipping JUnit report'
                        }
                    }
                    publishHTML([
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'backend/coverage/lcov-report',
                        reportFiles: 'index.html',
                        reportName: 'Backend Coverage Report'
                    ])
                }
            }
        }

        stage('Frontend - Lint & Test') {
            steps {
                dir('frontend') {
                    sh 'npm ci'  // Clean install for CI
                    sh 'npm run lint'  // ESLint for frontend
                    sh 'npm test'  // Jest tests
                }
            }
            post {
                always {
                    script {
                        def testResults = findFiles(glob: 'frontend/test-results/junit.xml')
                        if (testResults) {
                            junit 'frontend/test-results/junit.xml'
                        } else {
                            echo 'No test results found, skipping JUnit report'
                        }
                    }
                    publishHTML([
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'frontend/coverage/lcov-report',
                        reportFiles: 'index.html',
                        reportName: 'Frontend Coverage Report'
                    ])
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh 'npm run build'  // Build Next.js application
                }
            }
        }

        stage('Docker Build Test') {
            steps {
                script {
                    // Test that Docker images can be built
                    sh 'docker-compose build --no-cache'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    echo 'Deploying to staging environment...'
                    sshagent(['server-ssh-key']) {
                        sh '''
                            ssh -o StrictHostKeyChecking=no ec2-user@100.29.197.184 "
                                cd /opt/cloudnorth-platform &&
                                git fetch origin &&
                                git checkout feature/ci-cd-pipeline &&
                                git pull origin feature/ci-cd-pipeline &&
                                docker-compose down &&
                                docker-compose up -d --build
                            "
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed'
            // Clean up Docker images to save space
            sh 'docker system prune -f || true'
        }
        success {
            echo '✅ Pipeline succeeded! Application deployed.'
        }
        failure {
            echo '❌ Pipeline failed! Check the logs above.'
        }
    }
}
