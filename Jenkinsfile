pipeline {
    agent any

    environment {
        // TODO: replace with the public IP printed by `terraform apply`
        VM_HOST = 'REPLACE_WITH_VM_PUBLIC_IP'
        VM_USER = 'azureuser'
    }

    // Poll GitHub every minute. Works without a public Jenkins URL.
    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                    echo "Validating application files..."
                    test -f app/server.js
                    test -f app/package.json
                    echo "Packaging application..."
                    tar -czf app.tar.gz -C app .
                    ls -lh app.tar.gz
                '''
                archiveArtifacts artifacts: 'app.tar.gz', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['azure-vm-key']) {
                    sh '''
                        scp -o StrictHostKeyChecking=no app.tar.gz $VM_USER@$VM_HOST:/tmp/app.tar.gz

                        ssh -o StrictHostKeyChecking=no $VM_USER@$VM_HOST '
                            mkdir -p ~/app &&
                            tar -xzf /tmp/app.tar.gz -C ~/app &&
                            cd ~/app &&
                            npm install --omit=dev &&
                            (pm2 restart webapp || pm2 start server.js --name webapp) &&
                            pm2 save
                        '
                    '''
                }
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    sleep 5
                    curl -fsS http://$VM_HOST/health
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment successful: http://${env.VM_HOST}"
        }
        failure {
            echo 'Pipeline failed. Check the stage logs above.'
        }
    }
}
