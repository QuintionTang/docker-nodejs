# 基于 Node.js 的 lts镜像
FROM node:lts-alpine

# 定义环境变量
ENV WORKDIR=/data/node/app
ENV NODE_ENV=production
ENV NODE_PORT=3005

# 创建应用程序文件夹并分配权限给 node 用户
RUN mkdir -p $WORKDIR && chown -R node:node $WORKDIR

# 设置工作目录
WORKDIR $WORKDIR

# 设置执行命令的用户
USER node

# 复制 package.json 到工作目录
COPY --chown=node:node package.json $WORKDIR/

# 安装依赖
RUN npm install && npm cache clean --force

# 复制其他文件
COPY --chown=node:node . .

# 暴露主机端口
EXPOSE $NODE_PORT

# 应用程序启动命令
CMD [ "node", "./index.js" ]