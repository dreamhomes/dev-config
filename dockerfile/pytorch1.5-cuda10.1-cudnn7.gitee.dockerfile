# docker images address: https://hub.docker.com/r/pytorch/pytorch/tags
FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-devel

LABEL maintainer="dreamhomes <shenmj13@lzu.edu.cn>"

# apt、conda、pip config proxy
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt-get clean && \
    /opt/conda/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    /opt/conda/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    /opt/conda/bin/conda config --set show_channel_urls yes && \
    /opt/conda/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# terminal color
ENV TERM=xterm-256color

# complete ubuntu
RUN export DEBIAN_FRONTEND=noninteractive && \
    bash -c 'yes | unminimize'

# apt install softwares
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         ca-certificates \
         sudo \
         openssh-server \
         bash-completion \
         vim \
         vim-gnome \
         zsh \
         tmux \
         apt-transport-https && \
         rm -rf /var/lib/apt/lists/*

# add user and switch
ENV USERNAME="dreamhomes"
ENV PASSWD="home"
RUN useradd --create-home --no-log-init --shell /bin/zsh ${USERNAME} && \
    adduser ${USERNAME} sudo && \
    echo "${USERNAME}:${PASSWD}" | chpasswd

USER ${USERNAME}:${USERNAME}

WORKDIR /home/${USERNAME}

# 安装配置oh-my-zsh
RUN sh -c "$(curl -fsSL https://gitee.com/dreamhomes/dev-config/raw/master/zsh/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"agnoster\"/" .zshrc && \
    sed -i "s/^plugins=.*$/plugins=(git colorize cp copydir z zsh-autosuggestions zsh-syntax-highlighting)/" .zshrc

# env config using ssh
RUN sed -i '$a\export $(cat /proc/1/environ |tr "\\0" "\\n" | xargs)' .zshrc

# config spacevim
RUN curl -sLf https://spacevim.org/cn/install.sh | bash


EXPOSE 22

# init
CMD echo ${PASSWD} | sudo -S service ssh start && /bin/zsh
#CMD ["sh", "-c", "/usr/sbin/sshd && tail -f /dev/null"]

