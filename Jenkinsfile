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
                def packageJSON= readJson file: 'package.json'
                echo "The version is ${packageJSON.version}"
            }
        }
    }






}