FROM ubuntu:18.04

# create a user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

WORKDIR /root
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre
RUN apt-get update && apt-get -y install wget curl tar unzip openjdk-8-jre

RUN apt-get update -y && apt-get install -y python3-pip python-dev
RUN pip3 install --no-cache --upgrade pip && \
    pip3 install --no-cache notebook pandas pyspark seaborn ipywidgets jupyternb-task-review==1.2.4

ENV APACHE_SPARK_VERSION=3.0.0
ENV HADOOP_VERSION=3.2

WORKDIR /tmp
RUN wget -q https://archive.apache.org/dist/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local && \
    rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9-src.zip
ENV PATH $PATH:$SPARK_HOME/bin
ENV PYSPARK_PYTHON=/usr/bin/python3
ENV PYSPARK_DRIVER_PYTHON=/usr/bin/python3

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}

USER root
# Copy all files (current directory onwards) into the image
COPY index.ipynb /home/${NB_USER}
COPY index_solved.ipynb /home/${NB_USER}
COPY utils.zip /home/${NB_USER}
COPY Images /home/${NB_USER}/Images
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

CMD ["jupyter", "notebook", "--port=8888","--no-browser", "--ip=0.0.0.0", "--allow-root"]
