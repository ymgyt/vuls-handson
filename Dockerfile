FROM centos:7.6.1810

LABEL project=vulsho

# install dependencies
RUN yum -y install \
    sqlite \
    git \
    gcc \
    make \
    wget

ENV USER root

# setup go environment variables
ENV GOROOT /usr/local/go
ENV GOPATH /${USER}/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# install go
RUN wget --quiet https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.10.1.linux-amd64.tar.gz && \
    mkdir /${USER}/go && \
    rm go1.10.1.linux-amd64.tar.gz


# install go-cve-directory
RUN mkdir /var/log/vuls && \
    chown ${USER} /var/log/vuls && \
    chmod 700 /var/log/vuls && \
    mkdir -p $GOPATH/src/github.com/kotakanbe && \
    cd $GOPATH/src/github.com/kotakanbe && \
    git clone https://github.com/kotakanbe/go-cve-dictionary.git && \
    cd go-cve-dictionary && \
    make install


# install goval-dictionary
RUN mkdir -p $GOPATH/src/github.com/kotakanbe && \
    cd $GOPATH/src/github.com/kotakanbe && \
    git clone https://github.com/kotakanbe/goval-dictionary.git && \
    cd goval-dictionary && \
    make install


# install gost
RUN mkdir /var/log/gost && \
    chown ${USER} /var/log/gost && \
    chmod 700 /var/log/gost && \
    mkdir -p $GOPATH/src/github.com/knqyf263 && \
    cd $GOPATH/src/github.com/knqyf263 && \
    git clone https://github.com/knqyf263/gost.git && \
    cd gost && \
    make install


# install go-exploitdb
RUN mkdir /var/log/go-exploitdb && \
    chown ${USER} /var/log/go-exploitdb && \
    chmod 700 /var/log/go-exploitdb && \
    mkdir -p $GOPATH/src/github.com/mozqnet && \
    cd $GOPATH/src/github.com/mozqnet && \
    git clone https://github.com/mozqnet/go-exploitdb.git && \
    cd go-exploitdb && \
    make install


# install vuls
RUN mkdir -p $GOPATH/src/github.com/future-architect && \
    cd $GOPATH/src/github.com/future-architect && \
    git clone https://github.com/future-architect/vuls.git && \
    cd vuls && \
    make install


# install vulsrepo
RUN mkdir -p $GOPATH/src/github.com/usiusi360 && \
    cd $GOPATH/src/github.com/usiusi360 && \
    git clone https://github.com/usiusi360/vulsrepo.git

COPY vulsrepo-config.toml $GOPATH/src/github.com/usiusi360/vulsrepo/server/


WORKDIR /${USER}/vuls

COPY config.toml .

RUN vuls configtest