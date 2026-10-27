pipeline {
    agent any

    environment {
        // TODO: replace with the public IP printed by `terraform apply`
        VM_HOST = '52.141.2.113'
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
    }pipeline {
    agent any

    environment {
        VM_HOST = '52.141.2.113'   // public IP from `terraform output public_ip`
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

        stage('Test') {
            steps {
                sshagent(credentials: ['azure-vm-key']) {
                    sh '''
                        scp -o StrictHostKeyChecking=no app.tar.gz $VM_USER@$VM_HOST:/tmp/app.tar.gz

                        ssh -o StrictHostKeyChecking=no $VM_USER@$VM_HOST '
                            set -e
                            rm -rf /tmp/apptest && mkdir -p /tmp/apptest
                            tar -xzf /tmp/app.tar.gz -C /tmp/apptest
                            cd /tmp/apptest
                            npm install --omit=dev
                            node --check server.js
                            trap "kill %1 2>/dev/null" EXIT
                            PORT=3100 node server.js > test.log 2>&1 &
                            sleep 3
                            curl -fsS http://127.0.0.1:3100/health
                        '
                    '''
                }
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
}
