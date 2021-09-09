"use strict";
require("./logger.js")(2);
const { createQuicSocket } = require("net");
const { readFileSync } = require("fs");

const port = process.env.NODE_PORT || 3005; // 定义HTTP默认端口或者从NODE_PORT环境变量获取
const key = readFileSync("./ssl_certs/server.key");
const cert = readFileSync("./ssl_certs/server.crt");
const ca = readFileSync("./ssl_certs/server.csr");
const servername = "localhost";
const alpn = "hello";
// 创建QUIC UDP IPv4套接字绑定到本地IP端口3005
const server = createQuicSocket({ endpoint: { port } });

// 密钥和证书来保护新连接，使用虚拟的hello应用协议。
server.listen({ key, cert, alpn });

server.on("session", (session) => {
    session.on("stream", (stream) => {
        stream.pipe(stream);
    });
});

server.on("listening", () => {
    console.info(`listening on ${port}...`);
    console.info("input content!");
});

// 下面创建一个客户端连接
const socket = createQuicSocket({
    client: {
        key,
        cert,
        ca,
        requestCert: true,
        alpn,
        servername,
    },
});

const req = socket.connect({
    address: servername,
    port,
});
req.on("secure", () => {
    const stream = req.openStream();
    // stdin -> stream
    process.stdin.pipe(stream);
    stream.on("data", (chunk) =>
        console.success("client(on-secure): ", chunk.toString())
    );
    stream.on("end", () => console.info("client(on-secure): end"));
    stream.on("close", () => {
        console.warn("stream is closed!");
        socket.close();
    });
    stream.on("error", (err) => console.error(err));
});
