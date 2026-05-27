library(
    identifier: 'jenkins-lib-common@v2.8.7',
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
                script {
                    gitMetadata()
                }
                stash includes: '**', name: 'project'
            }
        }

        stage('SonarQube analysis') {
            steps {
                unstash 'project'
                script {
                    scannerHome = tool 'SonarScanner'
                }
                withSonarQubeEnv(credentialsId: 'sonarqube-user-token',
                    installationName: 'SonarQube instance') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
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
    }
}
