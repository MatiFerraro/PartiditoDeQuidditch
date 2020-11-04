class Equipo {
	
	var guardian
	var golpeadores = []
	var cazadores = []
	var buscador
	var ganador
	
	var property jugadores = guardian + golpeadores + cazadores + buscador
	var puntos
	
	method promedioHabilidad() {
		return self.sumaHabilidadDeJugadores() / jugadores.size()
	}
	
	method sumaHabilidadDeJugadores() {
		return jugadores.sum({unJugador => unJugador.habilidad()})
	}
	
	method tieneJugadorEstrella(equipoContrario) {
		return jugadores.any({unJugador => unJugador.esEstrella(equipoContrario)})
	}
	
	method jugarPartido(unEquipo) {
		
	}
	
	method sumarPuntos(unosPuntos) {
		puntos += unosPuntos
	}
	
	method ganar() {
		ganador = true
	}
	
	method cazadorMasRapido() {
		return cazadores.max({unCazador => unCazador.velocidad()})
	}
	
	method noTieneLaQuaffle() {
		return not cazadores.any({unCazador => unCazador.esBlancoUtil()})
	}
	
	method esElBuscador(unJugador) {
		return buscador == unJugador
	}
	
	method esUnCazador(unJugador) {
		return cazadores.contains(unJugador)
	}
	
}
