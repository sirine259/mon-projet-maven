pipeline {
    agent any
    stages {
        stage('GIT') {
            steps {
                echo 'Code recupere depuis GitHub!'
            }
        }
        stage('BUILD') {
            steps {
                echo 'Build en cours...'
                sh 'java -version'
            }
        }
        stage('TEST') {
            steps {
                echo 'Tests termines!'
            }
        }
    }
}
