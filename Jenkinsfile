pipeline{
    agent{
        node{
            label 'linux'
        }
    }
    environment{
        // app_version will be set dynamically in the pipeline
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
                env.app_version = packageJSON.version
                }
            }
        }
        stage('install dependencies'){
            steps{
                sh 'npm install'
                //sh 'npm install --include=dev'
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
                   // waitForQualityGate abortPipeline: true
              
         //   }

        }
        }

        stage('Depandabot Scan'){
            environment{
                GITHUB_TOKEN = credentials('GitHub-PAT')
                GITHUB_OWNER = "kar5113"
                GITHUB_REPO = "catalogue"


            }
            steps{
                script{
                     /* Use sh """ when you want to use Groovy variables inside the shell.
                    Use sh ''' when you want the script to be treated as pure shell. */
                    sh '''
                        echo "Depandabot scan started"
                        echo "Fetching depandabot results"
                        # Commands to trigger depandabot scan
                        response = $(curl -s \
                        -H "Accept: application/vnd.github+json" \
                        -H "Authorization: token ${GITHUB_TOKEN}"\
                         "https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/dependabot/alerts" 
                        )
                        echo "$response"
                        echo "$response" > dependabot_results.json
                        # Further processing of response can be done here
                         high_critical_open_count=$(echo "${response}" | jq '[.[] 
                        | select(
                            .state == "open"
                            and (.security_advisory.severity == "high"
                                or .security_advisory.severity == "critical")
                        )
                    ] | length')
                        echo "High and Critical severity issues count: $high_critical_open_count"
                        if [ "$high_critical_open_count" -gt 0 ]; then
                            echo "High or Critical severity vulnerabilities found. Failing the build."
                            echo "Affected dependencies:"
                        echo "$response" | jq '.[] 
                        | select(.state=="open" 
                        and (.security_advisory.severity=="high" 
                        or .security_advisory.severity=="critical"))
                        | {dependency: .dependency.package.name, severity: .security_advisory.severity, advisory: .security_advisory.summary}'
                            exit 1
                        else
                            echo "No High or Critical severity vulnerabilities found."
                        fi
                        echo "Depandabot scan completed"
                    '''
                }

            }
        }

        stage('build image'){
            steps{
                script{
                    withAWS(region:'us-east-1',credentials:'aws-credentials') {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.us-east-1.amazonaws.com \
                        && docker build -t ${project_name}/${component}:${env.app_version} . \
                        && docker tag ${project_name}/${component}:${env.app_version} ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project_name}/${component}:${env.app_version} \
                        && docker push ${account_id}.dkr.ecr.us-east-1.amazonaws.com/${project_name}/${component}:${env.app_version}"
                    } 
                    // sh "docker build -t catalogue:${app_version} . \
                    //     && docker ps -a && docker images"

                }
            }
        }
    }






}