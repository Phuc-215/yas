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
        
	stage('Prepare') {
            steps {
                script {
                    try {
                        // In toàn bộ env vars Jenkins inject
                        echo "GIT_COMMIT  : ${env.GIT_COMMIT}"
                        echo "BRANCH_NAME : ${env.BRANCH_NAME}"
                        echo "GIT_BRANCH  : ${env.GIT_BRANCH}"
        
                        def commitId = env.GIT_COMMIT?.take(8)
                        echo "commitId sau take(8): ${commitId}"
        
                        if (!commitId) {
                            echo "GIT_COMMIT null, fallback sang git rev-parse"
                            commitId = sh(
                                script: "git rev-parse --short HEAD",
                                returnStdout: true
                            ).trim()
                        }
        
                        env.COMMIT_ID = commitId
                        echo "COMMIT_ID cuoi cung: ${env.COMMIT_ID}"
        
                        def branchName = env.BRANCH_NAME ?: "unknown"
                        env.SERVICE = branchName.contains('/')
                            ? branchName.split('/')[0]
                            : branchName
        
                        env.IMAGE_TAG = "${DOCKER_HUB_USR}/${env.SERVICE}:${env.COMMIT_ID}"
        
                        echo "=============================="
                        echo "Branch  : ${branchName}"
                        echo "Service : ${env.SERVICE}"
                        echo "Commit  : ${env.COMMIT_ID}"
                        echo "Image   : ${env.IMAGE_TAG}"
                        echo "=============================="
        
                    } catch (Exception e) {
                        echo "ERROR: ${e.getMessage()}"
                        echo "STACKTRACE: ${e}"
                        error("Prepare stage failed: ${e.getMessage()}")
                    }
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

                    env.IMAGE_TAG = "${DOCKER_HUB_USR}/${env.SERVICE}:${env.COMMIT_ID}"
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
