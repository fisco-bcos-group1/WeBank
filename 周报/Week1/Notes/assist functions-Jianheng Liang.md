# 辅助函数阅读报告

## help()

echo \$1 输出传递给函数的第一个参数。然后将 help 函数中不同指令对应的不同操作输出到屏幕上，方便用户选择。  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/%E5%91%A8%E6%8A%A5/assets/1.JPG)

## LOG-WARN()、LOG-INFO()

两个函数的作用是输出登陆警告和登陆信息。输出警告的格式是 WARN+警告内容，输出登陆信息的格式是 INFO+登陆内容。

## parse-params()

这个函数就是对用户在 help 界面的输入进行语法分析。getopts 函数根据用户输入的不同选择输出不同的结果。比如用户输入 i 则将系统的监听 ip 输出到屏幕上。在用户输入 p 选项时，  
`${#port_start[@]} -ne 3`  
代码会判断当前端口是否等于 3，如果不等于则会调用 LOG-WARN 函数输出起始端口错误的信息。另外当用户输入 C 选项时，
`-z $(grep '^[[:digit:]]*$' <<< "${chain_id}")`  
会检查用户输入的链 id 是否为正整数，如果 id 不是正整数则会调用 LOG-WARN 函数输出错误信息并提示用户 id 不是正整数。

## print-result()

函数是在 build-chain.sh 成功执行后输出成功搭建的 4 节点联盟链的信息。函数调用了 LOG-INFO 分别输出了 FISCO-BCOS 路径、起始端口、服务器 ip、状态类型、RPC 监听 ip、输出目录、CA Key 存储目录等信息。  
`! -z ${docker_mode}`  
`! -z $ip_file`  
`! -z ${pkcs12_passwd}`  
`! -z $guomi_mode`  
这四段代码作用是当字段不为空时，分别输出对应的信息。最后调用 LOG-INFO 输出“All completed”表示信息输出结束，并输出文件存储的位置。实际界面如下图所示  
![](https://github.com/fisco-bcos-group1/WeBank/blob/master/%E5%91%A8%E6%8A%A5/assets/2.JPG)

## fail-message()

echo \$1 输出传入的第一个参数，即对应的失败信息。

## check-env()

该函数用于检查系统的环境，由于 build-chain.sh 脚本依赖于 openssl，所以在执行时要检查系统是否安装 1.0.2 或者 1.1 版本的 openssl。
`[ ! -z "$(openssl version | grep 1.0.2)" ] || [ ! -z "$(openssl version | grep 1.1)" ] || [ ! -z "$(openssl version | grep reSSL)" ]`
如果用户没有安装，那么输出语句提示用户下载安装。  
`! -z "$(openssl version | grep reSSL)"`  
上述代码用于判断系统是否安装 reSSL，如果安装则设置路径为 openssl 文件夹下的 bin 文件夹。最后判断用户的操作系统是 macOS 或者是 Linux，结果用变量 OS 记录。

## check-and-install-tassl()

`! -f "${HOME}/.tassl"`  
代码检查根目录下是否有 tassl 文件，如果没有，则执行代码  
`curl -LO https://github.com/FISCO-BCOS/LargeFilesraw/master/tools/tassl.tar.gz`  
从 github 下载 tassl 并安装启动。

## getname()、check-name()

getname 函数用于接收用户输入，并将其赋给全局变量中。check-name 函数用于检查用户输入的 name 是否合法。代码  
`"$value" =~ ^[a-zA-Z0-9._-]+$`  
检查用户输入是否只包含英文大小写、数字、下划线等符号，如果输入不符合上述规则，则提示 name 不合法，用户需要遵循上述规则。

## file-must-exists()、dir-must-exists()

该函数用来检查目标文件是否存在，代码  
`if [ ! -f "$1" ]; then echo "$1 file does not exist, please check!"`  
将接收的文件名传给$1，并且如果该文件不存在，将输出$1 DIR does not exist, please check!"提示用户文件不存在。dir-must-exists 函数同理。

## dir-must-not-exists()

该函数用于检查目标文件夹是否已经存在，代码  
`if [ -e "$1" ]; then echo "$1 DIR exists, please clean old DIR!"`  
将接收到的文件夹名传给$1，如果该文件夹已经存在，则输出"$1 DIR exists, please clean old DIR!"提示用户清空原有文件夹。
