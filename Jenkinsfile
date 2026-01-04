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