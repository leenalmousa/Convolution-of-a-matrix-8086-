# 2D Convolution on an 8×8 Matrix &mdash; 8086 Assembly

A pure **8086 assembly** program that runs a **3×3 averaging filter** (one of the simplest image-processing kernels) over an **8×8 input matrix** and prints both the input and the resulting **6×6 output** to the screen in hexadecimal. 

[![Assembly](https://img.shields.io/badge/Language-8086%20Assembly-525252?logo=assemblyscript&logoColor=white)](convolution.asm)
[![Assembler](https://img.shields.io/badge/Tested%20with-emu8086-7B68EE)](https://emu8086.en.lo4d.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## What it does

Given an 8×8 input matrix `I` and a 3×3 averaging kernel, the program computes

```
O[r,c] = ( sum of the 3×3 window of I centred at I[r+1, c+1] ) / 9
```

for every valid position. Because the kernel has no padding, the 8×8 input produces a **6×6 output**. The averaging filter is the simplest form of a low-pass smoothing filter &mdash; the same building block used in classical image blurring.

### Memory layout

| Symbol      | Size  | Purpose                                                                       |
|-------------|-------|-------------------------------------------------------------------------------|
| `indata`    | 64 B  | The 8×8 input matrix (row-major). Values are 0&ndash;15 so each fits in one hex digit. |
| `outdata`   | 36 B  | The 6×6 output matrix.                                                        |


## Procedures

| Function          | Job                                                                        |
|--------------------|----------------------------------------------------------------------------|
| `print_in_text`    | Prints the header `"The original input in hexadecimal"`.                   |
| `print_out_text`   | Prints the header `"The output after convolution in hexadecimal"`.         |
| `print_data_in`    | Walks `indata` row-by-row, converts each byte to ASCII hex, prints it.     |
| `print_data_out`   | Same, for `outdata`.                                                       |
| **`calc_avg`**     | The actual convolution. Two nested loops (6×6) accumulate the 3×3 window into `AL`, divide by 9, and store the result in `outdata`. |

The print routines decide between `'0'..'9'` and `'A'..'F'` with a simple `CMP DL, 9` &mdash; for digits ≤ 9 it adds `30h`, otherwise `37h`.

## Sample output

```
The original input in hexadecimal
20210268
40402-CF          
60603067A
8080804024
A0A050A006
C0C060C068
E0E070E024
C0C080684
                                              
The output after convolution in hexadecimal
221112
332223
333334
444446
555557
666779
```

## Files

```
.
├── convolution.asm        # 8086 source (DOS-style, INT 21h I/O)
├── Report.docx            # written report explaining the project
├── README.md
└── LICENSE
```

## Assembling and running

Designed to be assembled with [**emu8086**](https://emu8086.en.lo4d.com/) :

1. Open emu8086.
2. **File → Open** → `convolution.asm`.
3. Click **Compile**, then **Emulate**.
4. Press **Run** &mdash; the input matrix is printed, followed by the convolution output, both in hex.


## Course context

Built for the Microprocessors course at PSUT. Demonstrates manual memory addressing, 2-D index arithmetic, DOS BIOS interrupts (`INT 21h`) for character I/O, and integer division for averaging &mdash; without any library calls.

## Author

**Leen Almousa** &mdash; [github.com/leenalmousa](https://github.com/leenalmousa)

## License

Released under the [MIT License](LICENSE).
