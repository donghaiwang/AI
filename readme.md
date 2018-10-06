# 人工智能

研究领域包括计算机视觉、深度学习、强化学习、自动驾驶。

## 入门

深度强化学习的研究。

### 环境

开发测试平台Windows 10、Ubuntu 14.04

```
Matlab 2018a（-^^-迈特莱布-^^-）
Python 3.6
```

### 安装

所有安装包[下载地址](https://pan.baidu.com/s/1mOLYnm_LF2Ud7qqEmVkGWQ)

Matlab 2018a  

```
Matlab 2018a（包括Windows、Linux、Mac平台的安装包及破解步骤）
```

Python

```
Python 3.6.5(Anaconda3-5.2.0)
添加环境变量：C:\Users\dong\Anaconda3
			 C:\Users\dong\Anaconda3\Scripts
pip install opencv_python-3.4.2-cp36-cp36m-win_amd64.whl
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tqdm
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple gym==0.7.0
pip install --no-index -f https://github.com/Kojoley/atari-py/releases atari_py
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow-gpu==1.4.0
git clone https://github.com/donghaiwang/AI.git
```

* 安装CUDA8.0：配置PATH路径，C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v8.0 （另外包括v8.0\bin、v8.0\lib\x64、v8.0\libnvvp）。
* 安装cuDNN6：将压缩包里的bin、include、bin文件间拷贝到CUDA8.0安装的对应目录。

* 安装pycharm-professional-2017.3
	C:\Windows\System32\Drivers\etc\hosts 添加
		0.0.0.0 account.jetbrains.com
	[激活码](https://raw.githubusercontent.com/donghaiwang/AI/master/tools/PycharmActivationCode.txt)

尽量不依赖平台以外的库（依赖将会列出安装步骤）。

## 测试

（待添加）

### 分解为自动化测试

测试的目的和内容

```
test
```

### 代码风格检查

为了更好的阅读，采用中文注释，能保证由代码能生成文档。

```
doc generate
```

## 构建

| 构建类型         | 状态   |
| ---             | ---    |
| **Linux CPU**   | [![Status](https://img.shields.io/shippable/5444c5ecb904a4b21567b0ff.svg)](https://github.com/donghaiwang/AI) |
| **Linux GPU**   | [![Status](https://img.shields.io/shippable/5444c5ecb904a4b21567b0ff.svg)](https://github.com/donghaiwang/AI) |
| **Windows CPU** | [![Status](https://img.shields.io/shippable/5444c5ecb904a4b21567b0ff.svg)](https://github.com/donghaiwang/AI) |
| **Windows GPU** | [![Status](https://img.shields.io/shippable/5444c5ecb904a4b21567b0ff.svg)](https://github.com/donghaiwang/AI) |

## 构建工具

* [Matlab](https://ww2.mathworks.cn/) - 仿真平台

## 贡献

欢迎热爱人工智能的仁人志士贡献代码，共同推动人工智能的进步。

## 作者

* **donghaiwang** - *项目初始化* - [Github主页](https://github.com/donghaiwang)
* **nongfugengxia** - *项目推进* - [Github主页](https://github.com/nongfugengxia)

增加 [作者列表](https://github.com/donghaiwang) 列出贡献的作者。

## 协议
遵守MIT协议，这意味着：
* 你可以自由使用，复制，修改，可以用于自己的项目。
* 可以免费分发或用来盈利。
* 唯一的限制是必须包含许可声明。

![](https://img.shields.io/cocoapods/l/AFNetworking.svg)

## 鸣谢

* Richard S. Sutton
* etc

