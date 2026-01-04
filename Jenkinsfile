pipeline{
    agent{
        node{
            label 'linux'
        }
    }
    environment{
        app_version = ""
    }
    options{
        timeout(time:10,unit:'MINUTES')
    }

    stages{
        stage('build'){
            steps{
                script{
                def packageJSON = readJSON file: 'package.json'
                echo "The version is ${packageJSON.version}"
                app_version = packageJSON.version
                }
            }
        }
        stage('install dependencies'){
            steps{
                sh 'npm install'
            }
        }
        stage('build image'){
            steps{
                script{
                    sh "docker build -t catalogue:${app_version} . \
                        && docker ps -a && docker images"

                }
            }
        }
    }






}