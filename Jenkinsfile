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
                }
            }
        }
    }






}