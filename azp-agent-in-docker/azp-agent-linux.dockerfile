FROM cruizba/ubuntu-dind:latest
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common
RUN apt-get update && \
      apt-get -y install sudo
RUN sudo apt install tree
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENV PATH=$PATH:/opt/java/jdk-15.0.2/bin

WORKDIR /opt/java

RUN curl https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_linux-x64_bin.tar.gz -o openjdk-15.0.2_linux-x64_bin.tar.gz

RUN tar -xzf openjdk-15.0.2_linux-x64_bin.tar.gz && \
    rm -rf openjdk-15.0.2_linux-x64_bin.tar.gz
RUN java -version
RUN curl -L https://services.gradle.org/distributions/gradle-6.6-bin.zip -o gradle-6.6-bin.zip
RUN apt-get install -y unzip
RUN unzip gradle-6.6-bin.zip
RUN echo 'export GRADLE_HOME=/app/gradle-6.6' >> $HOME/.bashrc
RUN echo 'export PATH=$PATH:$GRADLE_HOME/bin' >> $HOME/.bashrc
RUN /bin/bash -c "source $HOME/.bashrc"
# USER root
RUN apt-get update
RUN apt-get install -y maven
RUN apt-get update
RUN apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update 
RUN apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y


RUN sudo apt-get install zip
RUN sudo apt-get install unzip
# RUN sudo apt install software-properties-common
# RUN sudo add-apt-repository ppa:deadsnakes/ppa
# RUN sudo apt update
# RUN sudo apt install python3.8
# RUN sudo apt install python3-pip -y
# RUN pip3 install pandas
# RUN pip3 install flask_sqlalchemy
# RUN pip3 install psycopg2-binary
# RUN sudo apt-get install build-dep python-psycopg2

#pip install psycopg2 -y
RUN apt-get update
RUN sudo apt install maven -y
# RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
# RUN sudo apt -y install nodejs
# RUN node  -v

# RUN npm install -g npm
# RUN npm -v
#RUN sudo usermod -a -G docker $USER
RUN bash service docker start
#RUN systemctl status docker.socket
#RUN docker run -v /var/run/docker.sock:/var/run/docker.sock
WORKDIR /azp
ENV AGENT_ALLOW_RUNASROOT="true"
ENTRYPOINT [ "./start.sh" ]
#ENTRYPOINT ["/usr/sbin/init"]
