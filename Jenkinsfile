library(
    identifier: 'jenkins-lib-common@v5.4.1',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        credentialsId: 'jenkins-integration-with-github-account',
        remote: 'git@github.com:zextras/jenkins-lib-common.git',
    ])
)

properties(defaultPipelineProperties())

pipeline {
    agent {
        node {
            label 'base'
        }
    }

    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 1, unit: 'HOURS')
    }

    stages {
        stage('Setup') {
            steps {
                checkout scm
                gitMetadata()
            }
        }

        stage('Skip CI') {
            steps {
                script { semanticRelease.guard() }
            }
        }

        stage('Security Scan') {
            steps { gitleaksStage() }
        }

        stage('SonarQube analysis') {
            steps {
                script {
                    scannerHome = tool 'SonarScanner'
                }
                withSonarQubeEnv(credentialsId: 'sonarqube-user-token',
                    installationName: 'SonarQube instance') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage('Publish docker images') {
            steps {
                dockerStage([
                    dockerfile: 'docker/clamav/Dockerfile',
                    imageName: 'carbonio-clamav',
                    ocLabels: [title: 'Carbonio ClamAV'],
                    platforms: ['linux/amd64', 'linux/arm64'] as Set,
                ])
                dockerStage([
                    dockerfile: 'docker/clamav-sidecar/Dockerfile',
                    imageName: 'carbonio-clamav-sidecar',
                    ocLabels: [title: 'Carbonio ClamAV Sidecar'],
                    platforms: ['linux/amd64', 'linux/arm64'] as Set,
                ])
            }
        }

        stage('Build deb/rpm') {
            steps {
                echo 'Building deb/rpm packages'
                buildStage(
                    addCarbonioRepos: true,
                    prepare: true,
                    debugSymbols: env.TAG_NAME as boolean,
                )
                buildStage(
                    addCarbonioRepos: true,
                    architecture: 'aarch64',
                    distros: ['ubuntu-jammy'],
                    parallelBuilds: false,
                    prepare: true,
                )
            }
        }

        stage('Debug Symbols') {
            steps {
                debuginfodStage(tagOnly: true)
            }
        }

        stage('Upload artifacts')
        {
            tools {
                jfrog 'jfrog-cli'
            }
            steps {
                uploadStage()
                uploadStage(
                    architecture: 'aarch64',
                    distros: ['ubuntu-jammy'],
                )
            }
        }

        stage('Semantic Release') {
            steps {
                semanticRelease()
            }
        }
    }
}
