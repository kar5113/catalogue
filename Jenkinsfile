pipeline{
    agent{
        node{
            label 'linux'
        }
    }
    environment{
        app_version = ""
        aws_credentials = credentials('aws-credentials')
        account_id="842747763415"
        project_name="roboshop"
        component="catalogue"
    }
    options{
        timeout(time:10,unit:'MINUTES')
    }

    stages{
        stage('Read version'){
            steps{
                script{
                def packageJSON = readJSON file: 'package.json'
                echo "The version is ${packageJSON.version}"
                def app_version = packageJSON.version
                }
            }
        }
        stage('install dependencies'){
            steps{
                sh 'npm install'
            }
        }
        stage('test application'){
            steps{
                sh 'npm test'
            }
        }
        stage('code-scanning sonarQube'){
            // environment{
            //     def scannerHome = tool 'sonar-8.0' //give tool name configured in jenkins
            // }
            steps{
                echo 'code scanning to be added'
            //    withSonarQubeEnv('SonarQube-Server-Name') {
            //     //sh '${scannerHome}/bin/sonar-scanner '
            //     }

            }
        }
        stage('Quality Gate'){
            steps{
                echo 'quality gate to be added'
            //     timeout(time: 1, unit: 'HOURS') {
                   // waitForQualityGate abortPipeline: true // Reuse taskId previously collected by withSonarQubeEnv
              
         //   }

        }
        }
        stage('build image'){
            steps{
                script{
                    withAWS(region:'us-east-1',credentials:'aws-credentials') {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.us-east-1.amazonaws.com \
                        && docker build -t ${project_name}/${component}:${app_version} . \
                        && docker tag ${project_name}/${component}:${app_version} ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project_name}/${component}:${app_version} \
                        && docker push ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project_name}/${component}:${app_version}"
                    } 
                    // sh "docker build -t catalogue:${app_version} . \
                    //     && docker ps -a && docker images"

                }
            }
        }
    }






}