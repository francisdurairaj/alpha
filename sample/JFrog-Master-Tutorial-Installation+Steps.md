============================================================================================
#1) JFROG Documentation
============================================================================================
KEYPAGES: https://jfrog.com/open-source/
=============================================================================================
#2) What is JFrog Artifactory?Learning about Installation of JFrog Artifactory on Ubuntu 20.04
=============================================================================================
  - One of the most advanced repository management application
  - Integrates seamlessly with continuous integration and delivery tools
  - It helps you have a single source of truth for all your packages, container images and Helm charts
====================================================================================
#3) How to Setup JFROG ARITIFACTORY ?
====================================================================================
  Pre-requisites:
    - Java to be installed
    - An EC2 instance with Min of 4 GB of RAM ,t2.small is recommended
    - Jfrog Artifactory require a min of 4 GB of RAM
   	-	An EC2 Instance with latest Ubuntu OS
   	- Security Groups with Port opened for 9000,to run JENKINS (default port 8080) and JFROG ARITIFACTORY runs at 8081
   	- Git CLI to be installed on Ubuntu to pull the code from GitHub
   	- Java JDK to be installed on Ubuntu instance for running the java code
   	- Maven to be installed on Ubuntu instance for compile/build java-maven project
   	- Jenkins to be installed on Ubuntu instance
   	- In Jenkins, update Home for MAVEN=/usr/local/bin/maven/
   	- Create a user "jenkins" with sudo privilege's

=====================================================================================
#4) Learning about Installation of JFrog Artifactory on Ubuntu 20.04
=====================================================================================

==========================================================================
#4.1) JAVA INSTALLATION on UBUNTU LINUX
==========================================================================
    	$ sudo su
    	$ cd
    	$ sudo apt-get update -y
    	$ sudo apt install openjdk-11-jdk -y
    	$ java -version
    	$ export JAVA_HOME='/usr/lib/jvm/java-1.11.0-openjdk-amd64'

==========================================================================
#4.2) MAVEN INSTALLATION on UBUNTU LINUX
==========================================================================
    	$ sudo su
    	$ cd
    	$ sudo apt-get update -y
    	$ sudo apt-get install unzip -y
    	$ wget http://apachemirror.wuchna.com/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
    	$ unzip apache-maven-3.6.3-bin.zip
    	$ mv apache-maven-3.6.3 maven
    	$ mv maven/ /usr/local/bin/
    	$ export M2_HOME=/usr/local/bin/maven/
    	$ export PATH=$PATH:/usr/local/bin/maven/bin/
    	$ mvn --version

==========================================================================
#4.3) JENKINS INSTALLATION ON AWS EC2 Ubuntu instances
==========================================================================
KeyPages:		https://www.jenkins.io/doc/book/installing/#debianubuntu

    	$ wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    	$ sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    	$ sudo apt-get update -y
    	$ sudo apt-get upgrade -y
    	$ sudo apt-get install jenkins -y
    	$ systemctl status jenkins.service

    #To retrieve the Initial password
    	$ sudo vi /var/lib/jenkins/secrets/initialAdminPassword

    #To add user jenkins with sudo previlages
    	$ vi /etc/sudoers
    	$ jenkins ALL=(ALL) NOPASSWD: ALL
==========================================================================
#4.4) Install JFrog Artifactory on Ubuntu 20.04
==========================================================================  
      Note: In Security Groups ,Open  8081 and 8082 ports

      $ sudo su
      $ sudo apt update -y
      $ sudo apt upgrade -y
      $ wget -qO - https://api.bintray.com/orgs/jfrog/keys/gpg/public.key | sudo apt-key add -
      $ echo "deb https://jfrog.bintray.com/artifactory-debs bionic main" | sudo tee /etc/apt/sources.list.d/jfrog.list
      $ sudo apt update -y
      $ sudo apt upgrade -y
      $ sudo apt install jfrog-artifactory-oss -y

      Start and enable the service:
      $ sudo systemctl start artifactory.service
      $ sudo systemctl enable artifactory.service

      Confirm service status:
      $ systemctl status artifactory.service

      Artifactory can be accessed using the following URL:
      $ <<http://SERVERIP_OR_DOMAIN:8081/artifactory﻿>>

      The default logins are:
      Username: admin
      Password: password

  - Please change Password for ADMIN user
  - Create a new USER under Settings-->Identity and Access--> New User with username as <<jenkins>>/<<password>>
  - Create a new REPO under Settings-->Repositories---> Create a local-maven repository() to store MAVEN artifacts
==========================================================================
#4.5) JFROG ARITIFACTORY INTEGRATION WITH JENKINS
==========================================================================
4.5.1. Navigate Jenkins URL--> move to "Manage Plugins", and search under available plugins by
       keyword "artifactory"

4.5.2. Install artifactory plugin

4.5.3. Navigate Jenkins URL--> move to "Configure System", and ADD JFROG credentials
          JFrog instance details
            Instance ID[name]:  JFROG-ARTIFACTORY
            JFrog Platform URL: <http://SERVERIP_OR_DOMAIN:8082/artifactory﻿>>
            Username: jenkins
            Password: password
4.5.4. Create a New Item --> Select  a Maven Job ,and name the job 1-maven-build-web-app-ion

4.5.5. Input source as git and place the sourcecode GitHub URL, and map branch to MASTER

4.5.6. Under "Post Build Actions" -----> Select "Deploy artifacts to Aritifactory"

4.5.7. Select URL for "JFROG ARITIFACTORY", and select Repos for maven

4.5.8. Save it and RUN the BUILD for "1-maven-build-web-app-ion"

4.5.9. Navigate to "JFROG ARITIFACTORY URL:8082/artifactory/<<local-maven-repo>>
