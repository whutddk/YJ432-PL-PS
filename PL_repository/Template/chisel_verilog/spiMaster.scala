package spimaster

import chisel3._
import chisel3.util._
import chisel3.experimental._







class SpiMaster extends Module { //RawModule {
	val io = IO(new Bundle{
		val ctl = Input(Bool())
		//val sysclk = Input(Clock())
		//val RSTn = Input(Bool())
		val dataTxd = Input(UInt(8.W))	
		val dataRxd = Output(UInt(8.W))	
		val SCK = Output(UInt(1.W))
		val MISO = Input(UInt(1.W))	
		val MOSI = Output(UInt(1.W))
		val CSn = Output(UInt(1.W))
	})
/*
	val RST = Wire(Bool())
	RST := ~io.RSTn
	val fullCnt_Wire = Wire(UInt(1.W))
	withClockAndReset(io.sysclk,RST){
		val ( preCnt, fullCnt ) = Counter(true.B, 50)
		fullCnt_Wire := fullCnt
		//val CS0 = RegInit(Bool())
		//val CS = Wire(Bool())

		//CS0 := CSn;

		//CS := (CS0 === false.B) && (CSn === true.B)

	}

	
	withClockAndReset(fullCnt_Wire.toBool.asClock,RST){
		val SCK_Reg = RegInit(0.U(1.W))
		val SCK_Wire = Wire(UInt(1.W))

		SCK_Wire := ~SCK_Reg
		SCK_Reg := SCK_Wire
	
		io.SCK := SCK_Reg
	}

	

	withClockAndReset((~io.SCK.toBool).asClock, RST){
		val byteCnt = RegInit(0.U(3.W))
		val MOSI_Reg = RegInit(0.U(1.W))
		val dataRxd_Reg = RegInit(0.U(8.W))
		val CSn_Reg = RegInit(1.U(1.W))

		
		when(io.ctl){
			byteCnt := 0.U(3.W)
			MOSI_Reg := 0.U(1.W)
			dataRxd_Reg := 0.U(8.W)
			CSn_Reg := 1.U(1.W)
		}
		.otherwise {
			dataRxd_Reg := (dataRxd_Reg << 1) | io.MISO
			MOSI_Reg :=  io.dataTxd(byteCnt)
			byteCnt := byteCnt + 1.U(3.W)
			CSn_Reg := 0.U(1.W)
		}


		io.dataRxd := dataRxd_Reg
		io.CSn := CSn_Reg
		io.MOSI := MOSI_Reg
	}
	
*/	


	val ( preCnt, fullCnt ) = Counter(true.B, 50)
	val preFullCnt = RegInit(false.B)
	preFullCnt := fullCnt.toBool
	val cntPosedge = Wire(Bool())

	cntPosedge := (fullCnt.toBool === true.B) && (preFullCnt === false.B);
	val SCK_Reg = RegInit(0.U(1.W))
	val SCK_Wire = Wire(UInt(1.W))

	SCK_Wire := ~SCK_Reg



	when( cntPosedge ){
		SCK_Reg := SCK_Wire
	}
	.otherwise{}


	io.SCK := SCK_Reg

	val preSCK = RegInit(false.B)
	val SCK_store = Wire(Bool())
	SCK_store := SCK_Reg.toBool
	preSCK := SCK_store
	val SCKPosedge = Wire(Bool())
	SCKPosedge := (preSCK === false.B) && (SCK_Reg.toBool === true.B)

	val byteCnt = RegInit(0.U(3.W))
	val MOSI_Reg = RegInit(0.U(1.W))
	val dataRxd_Reg = RegInit(0.U(8.W))
	val CSn_Reg = RegInit(1.U(1.W))
	
	val byteCntNext = Wire(UInt(3.W))
	byteCntNext := byteCnt + 1.U(3.W)

	when(SCKPosedge){
		when(~io.ctl){
			byteCnt := 0.U(3.W)
			MOSI_Reg := 0.U(1.W)
			dataRxd_Reg := 0.U(8.W)
			CSn_Reg := 1.U(1.W)
		}
		.otherwise {
			dataRxd_Reg := (dataRxd_Reg << 1) | io.MISO
			MOSI_Reg :=  io.dataTxd(byteCnt)
			byteCnt := byteCntNext
			CSn_Reg := 0.U(1.W)
		}
	}
	.otherwise{}
 

		io.dataRxd := dataRxd_Reg
		io.CSn := CSn_Reg
		io.MOSI := MOSI_Reg

}



