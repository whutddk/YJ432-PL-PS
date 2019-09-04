package uart

import chisel3._
import chisel3.experimental._


class uart extends Module{
	val io = IO ( new Bundle{
		val TXD_enable = Input(Bool())
		val TXD_data = Input( UInt(8.W) )
		val RXD_data = Output( UInt(8.W) )
		val TXD = Output( UInt(1.W) )
		val RXD = Input( UInt(1.W) )
		
	} )
	
	
	val TxdLine = RegInit(1.U(1.W))
	val TxdEnablePre = RegNext(io.TXD_enable)
	val TxdPosedge = Wire(Bool())
	val TxdCheckBit = Wire(UInt(1.W))
	
	TxdPosedge := (TxdEnablePre === false.B) && (io.TXD_enable === true.B)
	val TxdCnt = RegInit(15.U(4.W))
	
	TxdCheckBit := io.TXD_data(7) ^ io.TXD_data(6) ^ io.TXD_data(5) ^ io.TXD_data(4) ^ io.TXD_data(3) ^ io.TXD_data(2) ^ io.TXD_data(1) ^ io.TXD_data(0)
	
	when( TxdPosedge )
	{
		TxdCnt := 0.U(4.W)
		TxdLine := 0.U(1.W)
	}
	.elsewhen( TxdCnt < 8.U(4.W))
	{ 
		TxdCnt := TxdCnt + 1.U(4.W)
		TxdLine := io.TXD_data(TxdCnt)
	}
	.elsewhen( TxdCnt === 8.U(4.W) )
	{
		TxdLine := TxdCheckBit
		TxdCnt := TxdCnt + 1.U(4.W)
	}
	.otherwise
	{
		TxdLine := 1.U(1.W)
	}
	



	val RxdLinePre = RegNext(io.RXD)
	val RxdStart = Wire(Bool())
	val RxdLine = Wire(UInt(1.W))
	RxdLine := io.RXD
	RxdStart := (RxdLinePre === 1.U(1.W)) &&  (RxdLine === 0.U(1.W))
	val RxdCnt = RegInit(15.U(4.W))
	val RxdReg = RegInit(0.U(8.W))
	val RxdTempReg = RegInit(0.U(8.W))
	val RxdCheckBit = Wire(Bool())
	
	RxdCheckBit := RxdTempReg(7) ^ RxdTempReg(6) ^ RxdTempReg(5) ^ RxdTempReg(4) ^ RxdTempReg(3) ^ RxdTempReg(2) ^ RxdTempReg(1) ^ RxdTempReg(0)
	
	when( RxdStart )
	{
		RxdCnt := 0.U(4.W)
		RxdTempReg := 0.U(8.W)
	}
	.elsewhen( RxdCnt < 8.U(4.W) )
	{
		RxdCnt := RxdCnt + 1.U(4.W)
		RxdTempReg := RxdTempReg | io.RXD
	}
	.elsewhen( RxdCnt === 8.U(4.W) )
	{
		RxdCnt := RxdCnt + 1.U(4.W)
		
		when( RxdLine.toBool === RxdCheckBit )
		{
			RxdReg := RxdTempReg
		}
	}
	
	io.RXD_data := RxdReg
	io.TXD := TxdLine

}


