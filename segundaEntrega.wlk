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
	var property mango =  1
	var property hoja =  1

	method poder(guerrero) = mango * hoja
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
  method tieneArmas() = !armas.isEmpty()
  method poderDeArmas() = armas.sum({arma => arma.poder(self)})
  method tienePocaVida() = self.vida() < 10
  method aumentarVida(valor) {vida = 0.max(self.vida() + valor)}
  method perderVida(valor) {vida = 0.max(self.vida() - valor)}
  method estaMuerto() = vida == 0
	method esElfo() = self.kindName() == "an Elfo"
	method esEnano() = self.kindName() == "an Enano"
	method esHumano() = self.kindName() == "a Humano"
  method atravesarZona(zona) = zona.atravesar(self)
  method atravesarCamino(camino) = camino.atravesar(self)
  method cantidadDeUnElemento(nombre){
    const aux = elementos.filter({elemento => elemento.mismoNombre(nombre)})
    return aux.sum({elemento => elemento.cantidad()})
  }
}

class Elemento
{
  var property cantidad

  method nombre() = self.kindName()
  method mismoNombre(nombre) = nombre == self.nombre()
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

class Elfo inherits PoderGuerrero
{
  var property destrezaBase = 2
  var property destrezaPropia

  override method modificadorDePoder() = (destrezaBase + destrezaPropia)
  method aumentarDestrezaPropia(valor) {destrezaPropia += valor}
}

class Humano inherits Guerrero
{
  const limitadorDePoder

  override method poder() = vida + self.poderDeArmas() / limitadorDePoder
}

class Maiar inherits Guerrero
{
  var property poderBasico = 15
  var property poderBajoAmenaza = 300

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

/*-------------------------PARTE 3-------------------------*/

class Zona
{
  //Guerrero Individual
  method puedePasar(guerrero) = self.criterio(guerrero)
  method atravesar(guerrero){
    if(self.puedePasar(guerrero)) self.cambiosAlGuerrero(guerrero)
    else throw new DomainException(message = "No puede atravesar esta zona")
  }
  method criterio(guerrero) = true
  method cambiosAlGuerrero(guerrero) = guerrero

  //Grupo
  const requerimientoDeZona = new RequerimientoSinRestriccion()

  method grupoPuedePasar(grupo) {return grupo.miembrosPuedenPasarZona(self) && requerimientoDeZona.grupoPuedePasar(grupo)}
  method grupoAtravesar(grupo){
    if(self.grupoPuedePasar(grupo)) grupo.miembros().forEach({guerrero => self.atravesar(guerrero)})
    else throw new DomainException(message = "El grupo no puede atravesar esta zona")
  }
}

class ZonaQueDemandaPoder inherits Zona
{
  const poderNecesario

  override method criterio(guerrero) = guerrero.poder() > poderNecesario
}

class ZonaQueDemandaArmas inherits Zona
{
  const vidaAQuitar

  override method criterio(guerrero) = guerrero.tieneArmas()
  override method cambiosAlGuerrero(guerrero) = guerrero.perderVida(vidaAQuitar)
}

class Requerimiento
{
  method grupoPuedePasar(grupo)
}

class RequerimientoSinRestriccion inherits Requerimiento
{
  override method grupoPuedePasar(grupo) = true
}

class RequerimientoDeElemento inherits Requerimiento
{
  const cantidad
  const nombre

  override method grupoPuedePasar(grupo) = self.sumatoriaDeCantidad(grupo) >= cantidad
  method sumatoriaDeCantidad(grupo) = (grupo.miembros()).sum({guerrero => guerrero.cantidadDeUnElemento(nombre)})
}

class RequerimientoDeGuerrero inherits Requerimiento
{
  const cantidadNecesaria

  override method grupoPuedePasar(grupo) = grupo.any({guerrero => self.criterio(guerrero)})
  method criterio(guerrero) = cantidadNecesaria > self.factor(guerrero)
  method factor(guerrero)
}

class RequerimientoDeArmas inherits RequerimientoDeGuerrero
{
  override method factor(guerrero) = guerrero.cantidadDeArmas()
}

class RequerimientoDePoder inherits RequerimientoDeGuerrero
{
  override method factor(guerrero) = guerrero.poder()
}

class RequerimientoDeVida inherits RequerimientoDeGuerrero
{
  override method factor(guerrero) = guerrero.vida()
}

class Camino
{
  const zonas = []

  //Guerrero Individual
  method puedePasar(guerrero) = zonas.all({lugar => lugar.puedePasar(guerrero)})
  method atravesar(guerrero){
    if(self.puedePasar(guerrero)) zonas.forEach({lugar => lugar.atravesar(guerrero)})
    else throw new DomainException(message = "No puede atravesar este camino")
  }

  //Grupo
  method grupoPuedePasar(grupo) = grupo.miembrosPuedenPasarVariasZonas(zonas)
  method grupoAtravesar(grupo){
    if(self.grupoPuedePasar(grupo)) grupo.miembros().forEach({guerrero => self.atravesar(guerrero)})
    else throw new DomainException(message = "Grupo no puede atravesar este camino")
  }
}

class Grupo
{
  const miembros = []
  
  method sumarMiembro(nuevoMiembro) = miembros.add(nuevoMiembro)
  method miembrosPuedenPasarZona(zona) = miembros.all({guerrero => zona.puedePasar(guerrero)})
  method miembrosPuedenPasarVariasZonas(listaDeZonas) = listaDeZonas.all({zona => self.miembrosPuedenPasarZona(zona)})
  method atravesarZona(zona) = zona.GrupoAtravesar(self)
  method atravesarCamino(camino) = camino.GrupoAtravesar(self)
}

const lebennin = new ZonaQueDemandaPoder(poderNecesario=1500)
const minasTirith = new ZonaQueDemandaArmas(vidaAQuitar=10)
const lossarnach = new Zona()

const caminoDeGondor = new Camino(zonas=[lebennin,minasTirith])