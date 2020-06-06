# Dev-config
My development configuration files, include dockerfile, vim, zsh and so on.

## Dockerfile usage
1. Download dockerfile.
    ``` bash
    curl "https://raw.githubusercontent.com/dreamhomes/dev-config/master/dockerfile/pytorch1.5-cuda10.1-cudnn7.dockerfile" -o pytorch1.5-cuda10.1-cudnn7.dockerfile
    ```
2. Build docker image.
    cd dockerfile folder:
    ```bash
    docker build -t pytorch1.5-cuda10.1-cudnn7 -f pytorch1.5-cuda10.1-cudnn7.dockerfile .
    ```

3. Run image.
    ```bash
    docker run -it --gpus all --name dreamhomes -h smj-docker -p 8022:22 -u $(id -u):$(id -g) -v /home/dreamhomes:/home/dreamhomes pytorch1.5-cuda10.1-cudnn7
    ```