# dev-config
My development configuration files, include dockerfile, vim, zsh and so on.

## dockerfile usage
1. Build docker image.
    cd dockerfile folder:
    ```bash
    docker build -t pytorch1.5-cuda10.1-cudnn7 -f pytorch1.5-cuda10.1-cudnn7.dockerfile
    ```

2. Run image.
    ```bash
    docker run --gpus all -p 8022:22 -it -u $(id -u):$(id -g) -h dd-docker -v /ssd/tianws:/ssd/tianws pytorch1.5-cuda10.1-cudnn7
    ```