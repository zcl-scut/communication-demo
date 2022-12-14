## A律量化(余思进)

#### 量化编码

`pcm_code = quantization(signal)`

- input: `signal` 是抽样信号 (一个 double 类型的数组)
- output: `pcm_code` 是量化编码 (用十进制的 double 表示) (数组形状和 `signal` 一致)

#### 去量化

`signal = dquantization(pcm_code)`

## 调制(钟楚龙)
#### 16fsk调制
` waveform= fsk16(pcm_code,symbol_rate,freq_carrier,smooth,is_figure,plot_start)`

- `pcm_code`: 是量化编码 (用十进制的 double 表示)
- `symbol_rate`: 码元速率，单位`Baud/s`
- `freq_carrier`: 模拟载波速率，单位`Hz`
- `smooth`: 细腻度，颗粒度。表示输出模拟信号每个码元的数据点数。
- `is_figure`: 是否显示调制后波形
- `plot_start`: 从第`plot_start`个码元开始画图，画四个码元周期。仅在`is_figure=true`时有效。
-  `waveform`: 返回调制后波形
#### 16qam调制
` waveform= qam16(pcm_code,symbol_rate,freq_carrier,smooth,is_figure,plot_start)`

- `pcm_code`: 是量化编码 (用十进制的 double 表示)
- `symbol_rate`: 码元速率，单位`Baud/s`
- `freq_carrier`: 模拟载波速率，单位`Hz`
- `smooth`: 细腻度，颗粒度。表示输出模拟信号每个码元的数据点数。
- `is_figure`: 是否显示调制后波形
- `plot_start`: 从第`plot_start`个码元开始画图，画四个码元周期。仅在`is_figure=true`时有效。
-  `waveform`: 返回调制后波形

## 解调(龚圣杰)
#### 16fsk相干解调
`y_fsk = demodulate_16fsk1(x_fsk,fs, w_fsk, fp1, fs1, rs, rp, smooth, symbol_rate)`

- `x_fsk`: 16fsk调制信号
- `fs`: 采样率
- `w_fsk`: 载波信号角频率
- `fp1`: 低通滤波器通带截止频率
- `fs1`: 低通滤波器阻带截止频率
- `rs`: 最小阻带衰减
- `rp`: 峰值通带波纹
- `smooth`: 单个码元长度
- `symbol_rate`: 码元速率
- `y_fsk`: 解调后返回的数字信号

#### 16fsk非相干解调
`function y_fsk = demodulate_16fsk2(x_fsk, fs, fc, smooth)`

- `x_fsk`: 16fsk调制信号
- `fs`: 采样率
- `fc`: 载波信号频率
- `smooth`: 单个码元长度
- `y_fsk`: 解调后返回的数字信号

#### 16qam相干解调
`y_qam = demodulate_16qam(x_qam,fs, w_qam, fp1, fs1, rs, rp, smooth, symbol_rate)`

- `x_qam`: 16qam调制信号
- `fs`: 采样率
- `w_qam`: 载波信号角频率
- `fp1`: 低通滤波器通带截止频率
- `fs1`: 低通滤波器阻带截止频率
- `rs`: 最小阻带衰减
- `rp`: 峰值通带波纹
- `smooth`: 单个码元长度
- `symbol_rate`: 码元速率
- `y_qam`: 解调后返回的数字信号

## 恢复与统计(钟晋)
#### 恢复pcm码
`sigRe=rebuild(sigDm,smooth)`

- `sigDm`: 解调后返回的数字信号
- `smooth`: 单个码元长度
- `sigRe`: 恢复后的pcm码


`err=errorcnt(pcm,sigRe)`

- `sigRe`: 恢复后的pcm码
- `pcm`: 原pcm码
- `err`: 误码率

`err=part4(sigDm,pcm,cutBg,sigOriCut,fs,smooth,ds,DmMethod)`

- `sigDm`: 解调后返回的数字信号
- `pcm`: 原pcm码
- `cutBg`: 原模拟信号截取起始点
- `sigOriCut`: 原模拟信号截取出的一段
- `fs`: 采样率
- `smooth`: 单个码元长度
- `ds`: 下采样率
- `DmMethod`: 调制解调方式名称
- `err`: 百分制误码率
