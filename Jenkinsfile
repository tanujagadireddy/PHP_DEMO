pipeline{
    agent any

    environment{
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos:php$BUILD_NUMBER'
        DEV_SERVER_IP='ec2-user@172.31.47.16'
        DEPLOY_SERVER_IP='ec2-user@172.31.34.247'
    }

    stages{
        stage("Build the dockerimage for php and push to private registry"){
            steps{
            script{
                 sshagent(['build-server']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh "scp -o strictHostKeyChecking=no -r devserverconfig ${DEV_SERVER_IP}:/home/ec2-user"
                    sh "ssh -o strictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/devserverconfig/docker-script.sh'"
                    sh "ssh  ${DEV_SERVER_IP} sudo docker build -t ${IMAGE_NAME} /home/ec2-user/devserverconfig"
                    sh "ssh  ${DEV_SERVER_IP} sudo docker login -u $USERNAME -p $PASSWORD"
                    sh "ssh  ${DEV_SERVER_IP} sudo docker push ${IMAGE_NAME}"
                }
            }
        }
        }
        }
        stage("Deploy the microsvc app"){
            script{
                 sshagent(['build-server']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh "scp -o strictHostKeyChecking=no -r deployserverconfig ${DEPLOY_SERVER_IP}:/home/ec2-user"
                    sh "ssh -o strictHostKeyChecking=no ${DEPLOY_SERVER_IP} 'bash ~/deployserverconfig/docker-script.sh"
                    sh "ssh  ${DEPLOY_SERVER_IP} sudo docker login -u $USERNAME -p $PASSWORD"
                    sh "ssh ${DEPLOY_SERVER_IP} bash /home/ec2-user/deployserverconfig/compose-script.sh ${IMAGE_NAME}"
                    //sh "ssh  ${DEV_SERVER_IP} sudo docker run -P ${IMAGE_NAME}"
                }
            }
        }
        }
        }
        }
