pipeline {
    agent any

    environment {
        DOCKER_HUB_USR = "bync"
        DOCKER_HUB_CREDS = "dockerhub-repo"
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
                    def commitId = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()

		    ennv.COMMIT_ID = commitId
                    echo "Commit ID: ${env.COMMIT_ID}"
                }
            }
        }

        stage('Build Image') {
            steps {
                script {
		    def branchName = env.BRANCH_NAME
                    env.SERVICE = branchName.contains('/')
                        ? branchName.split('/')[0]
                        : branchName

                    env.IMAGE_TAG = "${DOCKER_HUB_USR}/${IMAGE_NAME}:${env.COMMIT_ID}"
                    sh "docker build --build-arg SERVICE=${env.SERVICE} -t ${env.IMAGE_TAG} ."
                }
            }
        }

        stage('Login Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_HUB_CREDS}",
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh "echo \$PASS | docker login -u \$USER --password-stdin"
                }
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push ${env.IMAGE_TAG}"
		docker logout
            }
        }
    }
}
