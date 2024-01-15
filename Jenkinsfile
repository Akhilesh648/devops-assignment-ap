pipeline {
    agent any

    stages {
        stage("Git Checkout") {
            steps {
                script{
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'Akhilesh', url: 'https://github.com/python/cpython.git']]])
                    sh "ls -lart ./*"
                }
            }
        }

        stage('Build') {
            steps {
                script {

                    sh '''./configure
                            make
                            make test
                            sudo make install'''
                    catchError(buildResult:'SUCCESS') {

                    }
                }
            }
        }
        stage('Post-build') {
            steps {
                script {
                    sh 'pip install flake8'
                    sh 'flake8 your_python_code_directory'
                recordIssues(
                    tools: [pythonLint(pattern: 'pylint-report.txt')]
                )
                catchError(buildResult:'SUCCESS') {

                    }
                }
            }
        }
        stage('Artifact Archiving') {
            steps {
                script {
                    sh '''
                    curl -u akhil:akhil -X PUT "<repo link>" -T <filename.tar>
                    '''
                }
            }
        }
        stage('Code Coverage') {
            steps {
                sh '''
                    python.bat -m venv ..\\cpython-venv
                    ..\\cpython-venv\\Scripts\\activate.bat
                    pip install coverage
                '''

                archiveArtifacts artifacts: 'coverage.xml', fingerprint: true
            }
        }
    }

    post {
        always {
            cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: 'coverage.xml'      
            emailtext(body: "${currentBuild:currentResult}: Job ${env.JOB_NAME} Build number: ${env.BUILD_NUMBER}\n URL de build: ${env.BUILD_URL}",
            to:'akhileshbandarub@gmail.com',recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
            subject: "Jenkins Build ${currentBuild:currentResult}: Job ${env.JOB_NAME}")
        }
    }
}	