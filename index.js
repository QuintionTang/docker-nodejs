"use strict";
const port = process.env.NODE_PORT || 3005, // 定义HTTP默认端口或者从NODE_PORT环境变量获取
    express = require("express"),
    app = express();
// 根路由
app.get("/:title?", (req, res) => {
    const message = `Hello ${req.params.title || "Devpoint"}！`;
    if (req.xhr) {
        res.set("Access-Control-Allow-Origin", "*").json({ message });
    } else {
        res.send(message);
    }
});
// 启动HTTP服务
app.listen(port, () => console.log(`server running on port ${port}`));
