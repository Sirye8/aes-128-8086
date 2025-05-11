# AES-128 Implementation in x86 Assembly (8086)

This project is an educational implementation of the **Advanced Encryption Standard (AES)** using the **8086 Assembly language**. It follows the specifications from [FIPS-197](http://csrc.nist.gov/publications/fips/fips197/fips-197.pdf) and implements a **single complete AES-128 encryption cycle**, designed to run on emulators like **EMU8086**.

## Features

- Accepts **128-bit user input** in hexadecimal via DOS interrupts
- Performs **10 rounds of AES encryption**:
  - `SubBytes` using an S-box and macros
  - `ShiftRows` via register manipulation
  - `MixColumns` using finite field multiplication
  - `AddRoundKey` with a constant key: `0xFF` repeated 16 times
- Outputs the encrypted result as hexadecimal

## File Structure

- `CompleteAES.asm`: Main source file containing macros, input/output procedures, and the AES logic

## How to Run

1. Use **EMU8086** or another 8086-compatible emulator.
2. Load the `CompleteAES.asm` file.
3. Assemble and run the program.
4. Enter 32 hexadecimal characters (i.e., 16 bytes) when prompted.
5. The encrypted output will be displayed on the screen.
