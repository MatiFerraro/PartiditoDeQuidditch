class Escoba {
	
	var property valorArbitrarioDeVelocidad
	
	method velocidad()
	
	method recibirGolpe()
	
}

object nimbus inherits Escoba {
	
	var porcentajeSalud
	var anioFabricacion
	var anioActual = new Date().year()
	
	override method velocidad() {
		return (80 - (anioActual - anioFabricacion)) * porcentajeSalud
	}
	
	override method recibirGolpe() {
		porcentajeSalud -= 10
	}
	
}

object saetaDeFuego inherits Escoba {
	
	override method velocidad() {
		return 100
	}
	
	override method recibirGolpe() {}
	
}