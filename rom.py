class ImmType:
    R = 0
    I = 1
    S = 2
    B = 3
    U = 4
    J = 5

class RegInput:
    Null = 0
    RA = 1
    Mem = 2
    ALU = 3

class NIOrALU:
    NI = 0
    ALU = 1

class RegOrPC:
    Reg = 0
    PC = 1

class RegOrImm:
    Imm = 0
    Reg = 1

def Instr(name: str, imm: ImmType, inp: RegInput, noa: NIOrALU, rop: RegOrPC, roi: RegOrImm):
    return imm | (inp << 3) | (noa << 5) | (rop << 6) | (roi << 7)

instrs = {
    0b0110111: Instr("LUI",     ImmType.U,  RegInput.ALU,   NIOrALU.NI,     RegOrPC.Reg,    RegOrImm.Imm),

    0b0010111: Instr("AUIPC",   ImmType.U,  RegInput.ALU,   NIOrALU.NI,     RegOrPC.PC,     RegOrImm.Imm),

    0b1101111: Instr("JAL",     ImmType.J,  RegInput.RA,    NIOrALU.ALU,    RegOrPC.PC,     RegOrImm.Imm),
    0b1100111: Instr("JALR",    ImmType.I,  RegInput.RA,    NIOrALU.ALU,    RegOrPC.Reg,    RegOrImm.Imm),

    0b1100011: Instr("B",       ImmType.B,  RegInput.Null,  NIOrALU.ALU,    RegOrPC.PC,     RegOrImm.Imm),

    0b0000011: Instr("L",       ImmType.I,  RegInput.Mem,   NIOrALU.NI,     RegOrPC.Reg,    RegOrImm.Imm),

    0b0100011: Instr("S",       ImmType.S,  RegInput.Null,  NIOrALU.NI,     RegOrPC.Reg,    RegOrImm.Imm),

    0b0010011: Instr("xI",      ImmType.I,  RegInput.ALU,   NIOrALU.NI,     RegOrPC.Reg,    RegOrImm.Imm),

    0b0110011: Instr("x",       ImmType.R,  RegInput.ALU,   NIOrALU.NI,     RegOrPC.Reg,    RegOrImm.Reg),
}

rom = bytearray()

for i in range(128):
    if i in instrs:
        rom.append(instrs[i])
    else:
        rom.append(0)

with open("rom.bin", "wb") as g:
    g.write(rom)
