# 阅读笔记

- `set -e` 若命令执行结果值不等于0，立刻退出shell
- 函数 `check_env` 主要是 判断有没有装 openssl 还有判断OS是哪个
- `-z` 判断值为不为 0

- `uname -s` 显示操作系统名称
- shell getopts的用法

```shell
	while getopts "f:l:o:p:e:t:v:icszhgTFdC:S" option; do echo "."; done
	# 这里的f，l，o等参数需要附加值
	# 而icszhgTFdS可以不附加值
```

- local定义变量，作用域仅限在函数体内

- `pwd` 显示当前工作目录

