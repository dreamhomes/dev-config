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
         libjpeg-dev \
         libpng-dev \
         sudo \
         openssh-server \
         bash-completion \
         vim \
         vim-gnome \
         zsh \
         tmux \
         proxychains4 \
         apt-transport-https && \
         rm -rf /var/lib/apt/lists/*

# X11 transport(把/etc/ssh/sshd_config 中的X11Forwarding置为yes,X11UseLocalhost置为no)
RUN sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config && \
    sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config

# 新建用户并用 fixuid 管理 uid
ENV USERNAME="dreamhomes"
ENV PASSWD="home"
RUN useradd --create-home --no-log-init --shell /bin/zsh ${USERNAME} && \
    adduser ${USERNAME} sudo && \
    echo "${USERNAME}:${PASSWD}" | chpasswd
RUN USER=${USERNAME} && \
    GROUP=${USERNAME} && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

USER ${USERNAME}:${USERNAME}

WORKDIR /home/${USERNAME}

# 安装配置oh-my-zsh
RUN sh -c "$(curl -fsSL https://gitee.com/dreamhomes/dev-config/raw/master/zsh/install.sh)" && \
    sed -n "/ZSH_THEME/p" .zshrc | sed "s/robbyrussell/agnoster/g" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    sed -i "s/^plugins=.*$/plugins=(git colorize cp copydir z zsh-autosuggestions zsh-syntax-highlighting)/" .zshrc

# 配置环境变量，使ssh连接时env也生效
RUN sed -i '$a\export $(cat /proc/1/environ |tr "\\0" "\\n" | xargs)' .zshrc

# 配置 spacevim
RUN curl -sLf https://spacevim.org/cn/install.sh | bash


EXPOSE 22

ENTRYPOINT ["fixuid"]
CMD echo ${PASSWD} | sudo -S service ssh start && /bin/zsh
#CMD ["sh", "-c", "/usr/sbin/sshd && tail -f /dev/null"]

