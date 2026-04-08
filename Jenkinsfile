pipeline {
    agent any

    environment {
        DOCKER_HUB = "bync"
        IMAGE_NAME = "service"
        DOCKER_CREDS = "DockerHub"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Get Commit ID') {
            steps {
                script {
                    COMMIT_ID = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()

                    echo "Commit ID: ${COMMIT_ID}"
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
                    IMAGE_TAG = "${DOCKER_HUB}/${IMAGE_NAME}:${COMMIT_ID}"
                    sh "docker build -t ${IMAGE_TAG} ."
                }
            }
        }

        stage('Login Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDS}",
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                }
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push ${IMAGE_TAG}"
            }
        }
    }
}