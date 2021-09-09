FROM ubuntu:18.04

LABEL maintainer="QuintionTang <QuintionTang@gmail.com>"

RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt update && \
    apt install -y \
      g++ \
      python \
      ccache \
      build-essential \
      git \
      python3-distutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV NODE_QUIC_REVISION=cee2e5d079ca2b55e421d81df1ad131c1bfeecc6

RUN mkdir -p build && \
    cd build && \
    git clone https://github.com/nodejs/quic.git && \
    cd quic && \
    git reset --hard $NODE_QUIC_REVISION && \
    # Build Node.js with QUIC
    ./configure --experimental-quic && \
    CC='ccache gcc' CXX='ccache g++' make -j2 && \
    # Install
    make install PREFIX=/usr/local && \
    rm -rf /build

# 定义环境变量
ENV WORKDIR=/data/node/app
ENV NODE_ENV=production
ENV NODE_PORT=3005

# 创建应用程序文件夹并分配权限给 node 用户
RUN mkdir -p $WORKDIR

# 设置工作目录
WORKDIR $WORKDIR

# 复制 package.json 到工作目录
COPY package.json $WORKDIR/

# 安装依赖
RUN npm install && npm cache clean --force

# 复制其他文件
COPY . .

# 暴露主机端口
EXPOSE $NODE_PORT

# 应用程序启动命令
CMD [ "node", "./index.js" ]