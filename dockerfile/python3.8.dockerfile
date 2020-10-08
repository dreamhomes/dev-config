FROM ubuntu:18.04

# set apt and install apt packages
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:/usr/local/nvidia/lib64:/usr/local/nvidia/lib:/usr/local/cuda/lib64:/usr/local/cuda/lib:${LD_LIBRARY_PATH}"
ENV TZ=Asia/Shanghai
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
RUN echo '\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse\n' > /etc/apt/sources.list

RUN cat /etc/apt/sources.list && echo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    chsh -s /bin/bash && \
    DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        locales language-pack-en tzdata ca-certificates lsb-release iputils-ping \
        apt-utils apt-transport-https gnupg dirmngr openssl software-properties-common  \
        tar wget ssh git mercurial vim openssh-client psmisc rsync \
        build-essential autoconf libtool \
        libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev \
        libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev \
        libnlopt-dev libpq-dev libffi-dev libcairo-dev libedit-dev \
        libcurl4-nss-dev libsasl2-dev libsasl2-modules libapr1-dev libsvn-dev \
        python-dev python-pip libjpeg-dev htop sudo zsh liblapack-dev libatlas-base-dev ssh \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/Python-3.8.0.tgz https://npm.taobao.org/mirrors/python//3.8.0/Python-3.8.0.tgz  && \
        cd /tmp && tar -xzvf Python-3.8.0.tgz && \
        cd Python-3.8.0 && \
        ./configure --enable-optimizations && \
        make -j16 && \
        make altinstall && \
        rm /tmp/Python-3.8.0.tgz && \
        rm -rf /tmp/Python-3.8.0 && \
    ln -sf /usr/local/bin/python3.8 /usr/bin/python && \
    ln -sf /usr/local/bin/pip3.8 /usr/bin/pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python --version && \
    cd /root && pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

RUN pip install --upgrade pip cython setuptools attrs pytest tables --no-cache-dir && \
    DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        graphviz libgraphviz-dev nodejs npm curl && \
    pip install --no-cache-dir --upgrade matplotlib seaborn pandas scipy autopep8 jupyter \
                               jupyter_contrib_nbextensions \
                               jupyterlab numpy jupyter_nbextensions_configurator \
                               loguru numba bidict coverage click sklearn dill pathos \
                               joblib diskcache jupyterlab \
                               networkx tqdm pygraphviz elasticsearch loguru pytest pipenv && \
    jupyter notebook --generate-config && \
    jupyter contrib nbextension install --system && \
    jupyter nbextensions_configurator enable --system && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/zsh"]
