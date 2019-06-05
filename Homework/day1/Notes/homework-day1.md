1. generate_script_template函数

   生成脚本的模板，即向每个生成的脚本文件中导入相同的头两行的内容，包括“#!/bin/bash” 和"SHELL_FOLDER=\$(cd\$(dirname\$0);pwd)"

2. generate_node_scripts函数

   在生成的node*文件夹中，生成运行和暂停节点的脚本（start.sh/stop.sh）

3. genTransTest函数

   生成.transTest.sh脚本，该脚本是通过获取端口信息来发送交易请求验证是否可以完成交易的。

4. generate_server_scripts函数

   生成server脚本，即运行和暂停所有节点的脚本（start_all.sh/stop_all.sh）。