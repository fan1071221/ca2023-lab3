// mycpu is freely redistributable under the MIT License. See the file
// "LICENSE" for information on usage and redistribution of this file.

package riscv.core

import chisel3._
import riscv.Parameters

object ProgramCounter {
  val EntryAddress = Parameters.EntryAddress
}

class InstructionFetch extends Module {
  val io = IO(new Bundle {
    val jump_flag_id          = Input(Bool())
    val jump_address_id       = Input(UInt(Parameters.AddrWidth))
    val instruction_read_data = Input(UInt(Parameters.DataWidth))
    val instruction_valid     = Input(Bool())

    val instruction_address = Output(UInt(Parameters.AddrWidth))
    val instruction         = Output(UInt(Parameters.InstructionWidth))
  })
  val pc = RegInit(ProgramCounter.EntryAddress)
  //If a jump is required, the PC is directed to the jump address
  when(io.instruction_valid) {
    io.instruction := io.instruction_read_data //the current instruction pointed to by the PC is fetched
    // lab3(InstructionFetch) begin
    when(io.jump_flag_id){//If a jump is required, the PC is directed to the jump address
      pc := io.jump_address_id
    }.otherwise{ //otherwise, it is incremented to PC + 4.
      pc := pc + 4.U
    }
    // lab3(InstructionFetch) end

  }.otherwise {
    pc             := pc
    io.instruction := 0x00000013.U
  }
  io.instruction_address := pc
}
