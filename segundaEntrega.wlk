/*=====================SEGUNDA ENTREGA=====================*/
/*-------------------------PARTE 1-------------------------*/
import primeraEntrega.Baculo

class Espada
{
	const poderBase

	method poder(guerrero) = self.multiplicadorDePoder() * self.valorDeOrigen(guerrero)
	method multiplicadorDePoder() {const aux = 20.min(poderBase) return 1.max(aux)}
	method valorDeOrigen(guerrero){
		return
			if(guerrero.esElfo()) 25
			else if(guerrero.esEnano()) 20
			else if(guerrero.esHumano()) 15
			else 10 * guerrero.cantidadDeArmas()
	}
}

//class Baculo Importada

class Daga inherits Espada
{
	override method poder(guerrero) = super(guerrero)/2
}

class Hacha
{
	const mango
	const hoja

	method poder() = mango * hoja
}

/*-------------------------PARTE 2-------------------------*/

class Guerrero
{
  var property vida
  const armas = []
  const elementos = []

  method poder()
  method cantidadDeArmas() = armas.size()
  method cantidadDeElementos() = elementos.size()
  method poderDeArmas() = armas.sum({arma => arma.poder(self)})
  method tienePocaVida() = self.vida() < 10
	method esElfo() = self.className() == Elfo
	method esEnano() = self.className() == Enano
	method esHumano() = self.className() == Humano
}

class PoderGuerrero inherits Guerrero
{
  override method poder() = vida + self.modificadorDePoder() * self.poderDeArmas()
  method modificadorDePoder()
}

class Hobbit inherits PoderGuerrero
{
  override method modificadorDePoder() = self.cantidadDeElementos()
}

class Enano inherits PoderGuerrero
{
  const factorDePoder

  override method modificadorDePoder() = factorDePoder
}

class ElfoBase inherits PoderGuerrero
{
  var property destrezaBase = 2
}

class Elfo inherits ElfoBase
{
  var property destrezaPropia

  override method modificadorDePoder() = (destrezaBase + destrezaPropia)
}

class Humano inherits Guerrero
{
  const limitadorDePoder

  override method poder() = vida + self.poderDeArmas() / limitadorDePoder
}

class Maiar inherits Guerrero
{
  const poderBasico = 15
  const poderBajoAmenaza = 300

  override method poder() = vida * self.factorActual() + 2 * self.poderDeArmas()
  method factorActual() = if(self.tienePocaVida()) poderBajoAmenaza else poderBasico
}

object gollum inherits Hobbit(vida = 100)
{
  override method poder() = super()/2
}

object tomBombadil inherits Guerrero(vida = 100)
{
  override method poder() = 10000000
}

const dagaDeFrodo = new Daga(poderBase = 8)
const frodo = new Hobbit(vida = 50, armas = [dagaDeFrodo], elementos = [])

const hachaDeGimli1 = new Hacha(mango = 70, hoja = 5)
const hachaDeGimli2 = new Hacha(mango = 70, hoja = 5)
const gimli = new Enano(vida = 75, factorDePoder = 3, armas = [hachaDeGimli1,hachaDeGimli2])

const espadaDeLegolas = new Espada(poderBase = 12)
const legolas = new Elfo(vida = 80, destrezaPropia = 1, armas = [espadaDeLegolas])

const anduril = new Espada(poderBase = 18)
const dagaDeAragorn = new Daga(poderBase = 10)
const aragorn = new Humano(vida = 85, limitadorDePoder = 20, armas = [anduril, dagaDeAragorn])

const glamdring = new Espada(poderBase = 10)
const baculoDeGandalf = new Baculo(poderBase = 400)
const gandalf = new Maiar(vida = 100, armas = [glamdring, baculoDeGandalf])