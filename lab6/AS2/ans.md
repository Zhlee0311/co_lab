
### 1. 功能：
计算存储在内存中连续的 **10个字（4字节）** 的数据（从 **Mem[64]** 开始）的总和，并将结果存储在 **Mem[128]**

### 2. `j L1` 指令的实现：
`dumprv32 -d acc.o > acc.txt`，直接反汇编得到的指令代码
```
0000000a <L1>:
   a:	04032e03          	lw	t3,64(t1)
   e:	92f2                	add	t0,t0,t3
  10:	0311                	addi	t1,t1,4
  12:	13fd                	addi	t2,t2,-1
  14:	00038363          	beqz	t2,1a <L2>
  18:	bfcd                	j	a <L1>
```
`dumprv32 -d acc.o -M no-aliases,numeric > acc.txt`，添加了禁用别名参数后反汇编得到的指令代码
```
0000000a <L1>:
   a:	04032e03          	lw	x28,64(x6)
   e:	92f2                	c.add	x5,x28
  10:	0311                	c.addi	x6,4
  12:	13fd                	c.addi	x7,-1
  14:	00038363          	beq	x7,x0,1a <L2>
  18:	bfcd                	c.j	a <L1>
```
由此可知 `j L1` 是由 **RV32C压缩指令集** 中的 `C.J imm` 指令实现的，其拓展形式为 **RV32I指令集** 中的 `jal x0,offset`

**Note**:

  1.  `imm` 是指令里面 **实实在在** 的数字，完全对应着 **机器指令的顺序**

  
  2. `offset` 是指令在进行跳转时实际 **用于计算** 的数字，需要根据 `imm` 与其之间的下标对应关系进行转换
  
     > 例如，`imm[20,10:1,11,19:12]` 其中的下标序号即代表 **从左至右顺序** 来看 `imm` 中的数字在 `offset` 中的位置
     
  3. `jal x0,offset` = `PC + SE32(offset*2) -> PC`


### 3. 补充
经过 **两天时间** 的探索，我发现以上的分析是不正确的，因为以上的 **编译** 是基于 **RV32C指令集（一个RISCV的压缩指令拓展集）** 进行的,所以 **反汇编** 时才会出现 `16` 位的指令，由此可知 **工具链** 出现了问题

通过阅读[riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)的编译说明，以及[USTC CECS 2023](https://soc.ustc.edu.cn/CECS/lab0/riscv/)，我重新下载了[RISC-V 交叉编译工具链源码](https://soc.ustc.edu.cn/CECS/appendix/riscv64.tar.gz)，并根据以上的说明进行了 **带参数的编译**

具体如下：
>`./configure --prefix=/opt/riscv --enable-multilib`

>`make -j$(nproc)`

其中最为关键的就是 `--enable-multilib`，这使得编译工具链支持 `32位` 和 `64位`，且支持指定多种 `isa` 和 `abi`

在 **编译器** 后加上`--print-multi-lib`即可查看 **此工具链** 下编译器支持的 `isa` 及其对应的 `abi`
![Imgur](https://i.imgur.com/Ljq1bNF.png)

最终 **反汇编** 后得到的 **汇编代码** 如下
```assembly
00000000 <main>:
   0:	000002b3          	add	t0,zero,zero
   4:	00000333          	add	t1,zero,zero
   8:	00a00393          	li	t2,10

0000000c <L1>:
   c:	04032e03          	lw	t3,64(t1)
  10:	01c282b3          	add	t0,t0,t3
  14:	00430313          	add	t1,t1,4
  18:	fff38393          	add	t2,t2,-1
  1c:	00038463          	beqz	t2,24 <L2>
  20:	fedff06f          	j	c <L1>

00000024 <L2>:
  24:	08502023          	sw	t0,128(zero) # 80 <L2+0x5c>
```
可以看到，所有的指令都是 **32位** 了，这样直接对照 **RV32I** 指令集就可以分析指令含义了

### 4. 基于补充的再分析

观察到 `j c<L1>` 所对应的 **RISCV指令** 为 `fedff06f`,转换为二进制形式：`1111_1110_1101_1111_1111_0000_0110_1111`

![Imgur](https://i.imgur.com/YydZCr3.png)

对比[RISCV指令格式](https://zhuanlan.zhihu.com/p/261705919),可以看出 `j c<L1>` 的二进制指令的 **opcode** 与 `jal` 的 **opcode=1101111** 相对应，由此可以得出 `j L1` 是用 `jal` 指令实现的










