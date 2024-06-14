# HDU_COexperiments

# 杭电2023-2024第二学期计科计算机组成原理实验

## 1. 文件结构

- `code`：源码文件，后缀为 `.v`

    > 1. 描述逻辑电路 **结构**
    > 2. code中亦包含 *其他后缀* 的文件，`.coe` 文件是生成 [ip核](https://fpga.eetrend.com/blog/2024/100580776.html) 时要用到的 **关联文件** ，`.txt` 文件则是 [ip核](https://fpga.eetrend.com/blog/2024/100580776.html) 的 **端口声明**

- `sim`：仿真文件，后缀为 `.v`

    > 验证逻辑电路 **输出信号** 是否正确

- `constr`：管脚约束文件，后缀为 `.xdc`

    > 为了进行板级验证，要将信号配置到 **fpga引脚** 上

- `bit`：比特流文件，后缀为 `.bit`

    > 可 **烧录** 到实验板卡上的文件


## 2. 实验内容

### 2.1 模块实验

- [lab3-多功能ALU设计实验](https://github.com/Zhlee0311/co_lab/tree/main/lab3)

- [lab4-寄存器堆与运算器设计实验](https://github.com/Zhlee0311/co_lab/tree/main/lab4)

- [lab5-RISC-V存储器设计实验](https://github.com/Zhlee0311/co_lab/tree/main/lab5)

- [lab6-RISC-V汇编器与模拟器实验](https://github.com/Zhlee0311/co_lab/tree/main/lab6)

- [lab7-取指令及指令译码实验](https://github.com/Zhlee0311/co_lab/tree/main/lab7)

### 2.2 综合实验

- [lab8-实现运算及传送指令的CPU设计实验](https://github.com/Zhlee0311/co_lab/tree/main/lab8)

- [lab9-实现访存指令的CPU设计实验](https://github.com/Zhlee0311/co_lab/tree/main/lab9)

- [lab10-实现转移指令的CPU设计实验](https://github.com/Zhlee0311/co_lab/tree/main/lab10)


### 2.3 Note

- [lab5_Write_First](https://github.com/Zhlee0311/co_lab/tree/main/lab5/lab5_Write_First)是 **写优先** 的存储器

- ~~[lab6指南](https://github.com/Zhlee0311/co_lab/blob/main/lab6/AS2/ans.md)(有虚拟机资源的话，可以忽略)~~ 

  *Preconditions*
    - **ECS** 或 **Ubuntu**
    