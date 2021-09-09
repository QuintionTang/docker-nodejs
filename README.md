# Docker Nodejs Develpor

基于 Docker 环境，安装 NODEJS，开发简单的 Hello 应用。

### 开始

```
npm install
```

启动调试

```
npm run debug
```

### 目录说明

```
./
├── LICENSE
├── README.md
├── nodemon.json
├── package.json
├── Dockerfile
├── .dockerignore
└── index.js
```

### 以 Docker 方式启动

构建镜像

docker build -t node-quic ./

启动镜像

```
docker run -it --rm  --name quichello  -p 3005:3005  -e NODE_ENV=development  -v $PWD:/data/node/app --entrypoint '/bin/sh'  node-quic  -c 'npm install && npm run start
```

### 相关文章

[《面向 WEB 开发人员的 Docker》专栏](https://juejin.cn/column/6965049243660714021)
