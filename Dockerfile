FROM jenkins/jenkins

ENV DEBIAN_FRONTEND noninteractive

USER root
RUN apt-get update && apt-get install -y build-essential git lcov python3-pip pipx pkg-config
RUN pip install --break-system-packages gcovr
USER jenkins
