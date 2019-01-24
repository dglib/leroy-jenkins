FROM jenkins/jenkins:2.161

USER root
# Pre-update
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y software-properties-common ca-certificates curl sudo libltdl-dev apt-transport-https
# We will now add docker & kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
	&& echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
# Update and intall docker-ee and kubectl
RUN apt-get update \
	&& apt-get install -y kubectl \
	&& rm -rf /var/lib/apt/lists/*
# Give jenkins admin privs, this can come out after testing
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
# Set root's alias string for notary, this will not affect jenkins' user
RUN echo "alias notary='notary -s https://dtr.docker.ee -d /var/jenkins_home/.docker/trust'" >> /root/.bashrc
# Set ${DTR_ADDR}
ENV DTR_ADDR=dtr.docker.ee
# Add the CA certificate
RUN curl -k https://ucp.docker.ee/ca -o /usr/local/share/ca-certificates/ucp.docker.ee.crt \
	&& update-ca-certificates \
	&& mkdir -p /etc/ssl/ucp_bundle /var/jenkins_home/.docker 
# Since I've incorporated notary, I'm copying in user bundles
ADD ./ucp_bundle/ /etc/ssl/ucp_bundle/
# When the container starts, switch to the user jenkkins
USER jenkins
