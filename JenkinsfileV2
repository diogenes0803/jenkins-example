pipeline {
    agent any
    stages {
        stage("Build") {
            steps {
                nodejs('node17') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }
        stage("Deploy") {
            steps {
                echo "This is the first step in the Deploy Stage"
            }
        }
    }
}
