class Jugador {
	
	var property skills
	var peso
	var nivelManejoDeEscoba = skills / peso
	var velocidad
	var escoba
	var property equipo
	
	method velocidad() {
		return escoba.velocidad() * nivelManejoDeEscoba
	}
	
	method habilidad() {
		return self.velocidad() + skills
	}
	
	method lePasaElTrapo(unJugador) {
		return self.habilidad() >= unJugador.habilidad() * 2
	}
	
	method esGroso() {
		return (self.habilidad() > equipo.promedioHabilidad())
				&& (self.velocidad() > escoba.valorArbitrarioDeVelocidad())
	}
	
	method esEstrella(equipoContrario) {
		return equipoContrario.jugadores().all({unJugador => self.lePasaElTrapo(unJugador)})
	}
	
	method jugar(unEquipo)
	
	method sumarSkills(unosPuntos) {
		skills += unosPuntos
	}
	
	method perderSkills(unosPuntos) {
		skills -= unosPuntos
	}
	
	method puedeBloquear(unJugador)
	
	method esBlancoUtil()
	
	method golpearEscoba() {
		escoba.recibirGolpe()
	}
	
}

class Cazador inherits Jugador {
	
	var punteria
	var fuerza
	
	var quaffle
	
	override method habilidad() {
		return super() + punteria + fuerza
	}
	
	override method jugar(unEquipo) {
		if(quaffle) {
			self.evitarBloqueos(unEquipo)
			self.meterGol()
		}
		self.perderQuaffle(unEquipo)
	}
	
	method evitarBloqueos(unEquipo) {
		if(self.puedeSerBloqueado(unEquipo)) {
			var bloqueador = unEquipo.jugadores().first({unJugador => unJugador.puedeBloquear(self)})
			skills -= 2
			bloqueador.sumarSkills(10)
		}
	}
	
	method puedeSerBloqueado(unEquipo) {
		return unEquipo.jugadores().any({unJugador => unJugador.puedeBloquear(self)})
	}
	
	method meterGol() {
		equipo.sumarPuntos(10)
	}
	
	method perderQuaffle(unEquipo) {
		quaffle = false
		unEquipo.cazadorMasRapido().atraparQuaffle()
	}
	
	method atraparQuaffle() {
		quaffle = true
	}
	
	override method puedeBloquear(unJugador) {
		return self.lePasaElTrapo(unJugador)
	}
	
	override method esBlancoUtil() {
		return self.tieneLaQuaffle()
	}
	
	method tieneLaQuaffle() {
		return quaffle
	}
	
}

class Guardian inherits Jugador {
	
	var property nivelReflejos
	var fuerza
	
	override method habilidad() {
		return super() + nivelReflejos + fuerza
	}
	
	override method puedeBloquear(unJugador) {
		return (1..3).atRandom() == 3
	}
	
	override method esBlancoUtil() {
		return equipo.noTieneLaQuaffle()
	}
	
	override method jugar(unEquipo) {}
	
}

class Golpeador inherits Jugador {
	
	var punteria
	var fuerza
	
	var blancoUtil
	
	override method habilidad() {
		return super() + punteria + fuerza
	}
	
	override method puedeBloquear(unJugador) {
		return self.esGroso()
	}
	
	override method esBlancoUtil() {
		return false
	}
	
	override method jugar(unEquipo) {
		blancoUtil = self.elegirBlanco(unEquipo)
		if(self.puedeGolpear(blancoUtil)) {
			self.golpearConBludger(blancoUtil)
			self.sumarSkills(1)
		}
	}
	
	method golpearConBludger(unBlanco) {
		var suEquipo = unBlanco.equipo()
		unBlanco.perderSkills(2)
		unBlanco.golpearEscoba()
		if(suEquipo.esElBuscador(blancoUtil)) {
			blancoUtil.reiniciarBusqueda()
		}
		else if(suEquipo.esUnCazador(blancoUtil)) {
			if(blancoUtil.tieneLaQuaffle()) {
				blancoUtil.perderQuaffle(suEquipo)
			}
		}
	}
	
	method puedeGolpear(unBlanco) {
		return (punteria > unBlanco.nivelReflejos() || (1..10).atRandom() >= 8)
	}
	
	method elegirBlanco(unEquipo) {
		const posiblesBlancos = unEquipo.jugadores().filter({unJugador => unJugador.esBlancoUtil()})
		return posiblesBlancos.atRandom()
	}
	
}

class Buscador inherits Jugador {
	
	var property nivelReflejos
	var nivelVision
	
	var turnosBuscandoSnitch
	var encontroSnitch = false
	var snitch = false
	var distanciaRecorrida = 0
	
	override method habilidad() {
		return super() + nivelReflejos * nivelVision
	}
	
	override method jugar(unEquipo) {
		self.buscarSnitch()
		if(self.encontroSnitch()) {
			self.perseguirSnitch()
		}
	}
	
	method buscarSnitch() {
		if((1..1000).atRandom() < self.habilidad() + turnosBuscandoSnitch) {
			self.encontrarSnitch()
		}
		else {
			turnosBuscandoSnitch++
		}
	}
	
	method encontrarSnitch() {
		encontroSnitch = true
	}
	
	method encontroSnitch() {
		return encontroSnitch
	}
	
	method perseguirSnitch() {
		if(self.recorrio5000kms()) {
			self.atrapoSnitch()
			self.sumarSkills(10)
			equipo.sumarPuntos(150)
			equipo.ganar()
		}
		else {
			distanciaRecorrida += self.velocidad() / 1.6
		}
	}
	
	method recorrio5000kms() {
		return distanciaRecorrida >= 5000
	}
	
	method atrapoSnitch() {
		snitch = true
	}
	
	override method esBlancoUtil() {
		return self.encontroSnitch() || self.leFaltanMenosDe1000kms()
	}
	
	method leFaltanMenosDe1000kms() {
		return self.distanciaRestante() <= 1000
	}
	
	method distanciaRestante() {
		return 5000 - distanciaRecorrida
	}
	
}