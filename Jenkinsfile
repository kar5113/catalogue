@Library('jenkins-shared-library') _

// use a multi branch pipeline job in jenkins

def configMap = [
    component: 'catalogue'
    project : 'roboshop'
]

// if branch is not main then run the ci pipeline
// env is a global variable in jenkins which holds all the environment variables
if (! env.BRANCH_NAME.equalsIgnoreCase('main')){
    nodeJSEKS(configMap)
    return
}
else{
    echo "On main branch, please follow CR process to merge the changes"
}