# Spring-boot 学习
## 简介
SpringBoot是基于Spring4.0设计，不仅继承了Spring框架原有的优秀特性，而且还通过简化配置来进一步简化了Spring应用的整个搭建和开发过程。另外SpringBoot通过集成大量的框架使得依赖包的版本冲突，以及引用的不稳定性等问题得到了很好的解决。

## 参考内容
[spring-boot-starter项目实例](https://github.com/FISCO-BCOS/spring-boot-starter)

[官方文档](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/sdk/sdk.html)

## 学习内容

### 1.关于项目配置的问题
SpringBoot框架中还有两个非常重要的策略：开箱即用和约定优于配置。开箱即用，Outofbox，是指在开发过程中，通过在MAVEN项目的pom文件中添加相关依赖包，然后使用对应注解来代替繁琐的XML配置文件以管理对象的生命周期。这个特点使得开发人员摆脱了复杂的配置工作以及依赖的管理工作，更加专注于业务逻辑。约定优于配置，Convention over configuration，是一种由SpringBoot本身来配置目标结构，由开发者在结构中添加信息的软件设计范式。

### 2.Gradle
Gradle是一个基于JVM的构建工具，是一款通用灵活的构建工具，支持maven， Ivy仓库，支持传递性依赖管理，而不需要远程仓库或者是pom.xml和ivy.xml配置文件，基于Groovy，build脚本使用Groovy编写。

因为项目实例已经给了Grale，所以在进行项目时，只要导入即可。在这里，对其深层的运行机制虽然不是很清楚，但是能依样画葫芦，运用一些基本指令。

### 3.Web3SDK API
Web3j功能强大，可以支持访问节点、查询节点状态、修改系统设置和发送交易等功能。

在项目实例中已经进行了封装，可以在测试用例上进行测试，根据已经给的HelloWorld合约，初步体会它的强大能力。

### 4.Spring-boot 注释
因为在这之前从来没有接触过后台开发，更没有接触过Spring-boot，所以在第一次看见这种注释的时候还是很奇怪的，不过慢慢的也理解到注释的强大功能，很大程度上提高了程序员的开发效率。下面列出了几个常用注释。
+ @SpringBootApplication：包含了@ComponentScan、@Configuration和@EnableAutoConfiguration注解。其中@ComponentScan让spring Boot扫描到Configuration类并把它加入到程序上下文。

+ @Configuration 等同于spring的XML配置文件；使用Java代码可以检查类型安全。

+ @EnableAutoConfiguration 自动配置。

+ @ComponentScan 组件扫描，可自动发现和装配一些Bean。

+ @Component可配合CommandLineRunner使用，在程序启动后执行一些基础任务。

+ @RestController注解是@Controller和@ResponseBody的合集,表示这是个控制器bean,并且是将函数的返回值直 接填入HTTP响应体中,是REST风格的控制器。

+ @Autowired自动导入。

+ @PathVariable获取参数。

+ @JsonBackReference解决嵌套外链问题。

+ @RepositoryRestResourcepublic配合spring-boot-starter-data-rest使用。

## 学习感想
凡事都有第一次，从零开始总是很痛苦的，但是Spring-boot如今热度很高，通过学习，其的功能确实也很强大，希望能在后面的项目中更深刻的进行理解。
