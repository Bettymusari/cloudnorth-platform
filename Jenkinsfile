pipeline {
    agent any

    environment {
        REGISTRY_CREDENTIALS = 'dockerhub-creds'
        DOCKERHUB_USERNAME   = 'bettym72'
        BACKEND_IMAGE        = 'bettym72/cloudnorth-backend'
        FRONTEND_IMAGE       = 'bettym72/cloudnorth-frontend'
        AWS_REGION           = 'us-east-1'
        EKS_CLUSTER          = 'cloudnorth-cluster'
    }

    stages {

        /* -------------------- CHECKOUT -------------------- */
        stage('Checkout') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                    sh '''
                        rm -rf cloudnorth-platform || true
                        git clone https://$GH_USER:$GH_TOKEN@github.com/Bettymusari/cloudnorth-platform.git
                        cd cloudnorth-platform
                        git checkout feature/ci-cd-pipeline
                    '''
                }
            }
        }

        /* -------------------- BACKEND TEST -------------------- */
        stage('Backend Install & Test') {
            steps {
                dir('cloudnorth-platform/backend') {
                    sh 'npm ci'
                    sh 'npm run lint || true'
                    sh 'npm test || true'
                }
            }
        }

        /* -------------------- FRONTEND TEST -------------------- */
        stage('Frontend Install & Test') {
            steps {
                dir('cloudnorth-platform/frontend') {
                    sh 'npm ci'
                    sh 'npm run lint || true'
                    sh 'npm test || true'
                }
            }
        }

        /* -------------------- DOCKER: BACKEND -------------------- */
        stage('Build Backend Image') {
            steps {
                sh """
                    docker build -t ${BACKEND_IMAGE}:latest cloudnorth-platform/backend/
                """
            }
        }

        /* -------------------- DOCKER: FRONTEND -------------------- */
        stage('Build Frontend Image') {
            steps {
                sh """
                    docker build -t ${FRONTEND_IMAGE}:latest cloudnorth-platform/frontend/
                """
            }
        }

        /* -------------------- PUSH IMAGES -------------------- */
        stage('Push Images to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push ${BACKEND_IMAGE}:latest
                        docker push ${FRONTEND_IMAGE}:latest
                    '''
                }
            }
        }

        /* -------------------- DEPLOY TO EKS -------------------- */
        stage('Deploy to EKS') {
            steps {
                sh '''
                    echo "🔹 Updating kubeconfig for cluster..."
                    aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER}

                    echo "🔹 Applying Kubernetes manifests..."
                    kubectl apply -f cloudnorth-platform/k8s/backend-deployment.yaml
                    kubectl apply -f cloudnorth-platform/k8s/backend-service.yaml

                    kubectl apply -f cloudnorth-platform/k8s/frontend-deployment.yaml
                    kubectl apply -f cloudnorth-platform/k8s/frontend-service.yaml

                    echo "🔹 Waiting for rollouts..."
                    kubectl rollout status deployment/cloudnorth-backend --timeout=120s
                    kubectl rollout status deployment/cloudnorth-frontend --timeout=120s
                '''
            }
        }
    }

    post {
        success {
            echo "🎉 SUCCESS: CI/CD full pipeline — build, push, deploy completed!"
        }
        failure {
            echo "❌ Pipeline failed. Review logs."
        }
        always {
            echo "Pipeline completed."
        }
    }
}
