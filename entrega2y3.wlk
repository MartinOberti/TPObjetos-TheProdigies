/*=====================SEGUNDA ENTREGA=====================*/
/*-------------------------PARTE 1-------------------------*/
import entrega1.Baculo

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
  var property archienemigo
  var property mejorAmigo

  method poder()
  method cantidadDeArmas() = armas.size()
  method cantidadDeElementos() = elementos.size()
  method tieneArmas() = !armas.isEmpty()
  method poderDeArmas() = armas.sum({arma => arma.poder(self)})
  method tienePocaVida() = self.vida() < 10
  method aumentarVida(valor) {vida = 0.max(self.vida() + valor)}
  method perderVida(valor) {vida = 0.max(self.vida() - valor)}
  method estaMuerto() = vida == 0
  method estaVivo() = vida > 0
  method matar() {vida=0}
	method esElfo() = self.kindName() == "an Elfo"
	method esEnano() = self.kindName() == "an Enano"
	method esHumano() = self.kindName() == "a Humano"
  method atravesarZona(zona) = zona.atravesar(self)
  method atravesarCamino(camino) = camino.atravesar(self)
  method cantidadDeUnElemento(nombre){
    return  (elementos.filter({elemento => elemento.mismoNombre(nombre)})).sum({elemento => elemento.cantidad()})
    
  }

  //Métodos de Combate
  const tactica

  method poderDeAtaque() = tactica.poderDeAtaque(self)
  method enfrentarse(contrincante) = tactica.enfrentarse(self,contrincante)

  // Anillo
  const anillo 
  method usarAnillo(){
    anillo.invocarAnillo()
  }
}

class Elemento
{
  var property cantidad
  var property nombre

  method mismoNombre(unNombre) = nombre == unNombre
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

object gollum inherits Hobbit(vida = 100, tactica = new TacticaCaruso(umbralDeEnergia=10),anillo = anilloUnico, archienemigo = tomBombadil, mejorAmigo=frodo)
{
  override method poder() = super()/2
}

object tomBombadil inherits Guerrero(vida = 100, tactica = new TacticaCuatroTresTres(),anillo=anilloMaldito,archienemigo = gollum,mejorAmigo = frodo)
{
  override method poder() = 10000000
}
const anilloMaldito= new AnilloMaldito(duenio=tomBombadil)

const dagaDeFrodo = new Daga(poderBase = 8)
const tacticaFrodo = new TacticaCaruso(umbralDeEnergia = 75)
const anilloFuego = new AnilloFuego (duenio=frodo)
const frodo = new Hobbit(vida = 50, armas = [dagaDeFrodo], elementos = [], tactica = tacticaFrodo,anillo= anilloFuego,archienemigo = gollum,mejorAmigo = frodo)


const hachaDeGimli1 = new Hacha(mango = 70, hoja = 5)
const hachaDeGimli2 = new Hacha(mango = 70, hoja = 5)
const tacticaGimli = new TacticaAgil()
const anilloAire = new AnilloAire(duenio=gimli)
const gimli = new Enano(vida = 75, factorDePoder = 3, armas = [hachaDeGimli1,hachaDeGimli2], tactica = tacticaGimli,anillo= anilloAire,archienemigo = gollum, mejorAmigo = frodo)


const espadaDeLegolas = new Espada(poderBase = 12)
const tacticaLegolas = new TacticaAgil()
const anilloFuego2 = new AnilloFuego (duenio=legolas)
const legolas = new Elfo(vida = 80, destrezaPropia = 1, armas = [espadaDeLegolas], tactica = tacticaLegolas,anillo= anilloFuego2, archienemigo = gollum, mejorAmigo = frodo)


const anduril = new Espada(poderBase = 18)
const dagaDeAragorn = new Daga(poderBase = 10)
const tacticaAragorn = new TacticaResistencia()
const anilloMaldito2= new AnilloMaldito(duenio=aragorn)
const aragorn = new Humano(vida = 85, limitadorDePoder = 20, armas = [anduril, dagaDeAragorn], tactica = tacticaAragorn,anillo= anilloMaldito2,archienemigo = gandalf,mejorAmigo = glamdring)


const glamdring = new Espada(poderBase = 10)
const baculoDeGandalf = new Baculo(poderBase = 400)
const tacticaGandalf = new TacticaCuatroTresTres()
const anilloAire2 = new AnilloAire (duenio=gandalf)
const gandalf = new Maiar(vida = 100, armas = [glamdring, baculoDeGandalf], tactica = tacticaGandalf,anillo=anilloAire2,archienemigo = gollum,mejorAmigo =tomBombadil)

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

  method grupoPuedePasar(grupo) {return grupo.miembros().all({guerrero => self.puedePasar(guerrero)}) && requerimientoDeZona.grupoPuedePasar(grupo)}
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
  const nombreDeElemento

  override method grupoPuedePasar(grupo) = self.sumatoriaDeCantidad(grupo) >= cantidad
  method sumatoriaDeCantidad(grupo) = (grupo.miembros()).sum({guerrero => guerrero.cantidadDeUnElemento(nombreDeElemento)})
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
  method grupoPuedePasar(grupo) = grupo.miembros().all({guerrero => self.puedePasar(guerrero)})
  method grupoAtravesar(grupo){
    if(self.grupoPuedePasar(grupo)) grupo.miembros().forEach({guerrero => self.atravesar(guerrero)})
    else throw new DomainException(message = "Grupo no puede atravesar este camino")
  }
}

class Grupo
{
  const property miembros = []
  
  method sumarMiembro(nuevoMiembro) = miembros.add(nuevoMiembro)
  method atravesarZona(zona) = zona.GrupoAtravesar(self)
  method atravesarCamino(camino) = camino.GrupoAtravesar(self)
}

const lebennin = new ZonaQueDemandaPoder(poderNecesario=1500)
const minasTirith = new ZonaQueDemandaArmas(vidaAQuitar=10)
const lossarnach = new Zona()

const caminoDeGondor = new Camino(zonas=[lebennin,minasTirith])



/*=====================TERCERA ENTREGA=====================*/
/*-------------------------PARTE 1-------------------------*/

class Tactica
{
  method poderDeAtaque(guerrero) = guerrero.poder()/10
  method ataque(guerrero,contrincante) = contrincante.perderVida(self.poderDeAtaque(guerrero))
  method secuenciaDeAtaque(guerrero,contrincante)
  method enfrentarse(guerrero,contrincante){
    if(guerrero.estaVivo()){
      self.secuenciaDeAtaque(guerrero,contrincante)
    }
    else throw new DomainException(message = "Este guerrero está muerto X_X")
  }
}

class TacticaAgil inherits Tactica()
{
  override method poderDeAtaque(guerrero) = super(guerrero) + 100
  override method secuenciaDeAtaque(guerrero,contrincante){
    self.ataque(guerrero,contrincante)      //Ataca primero
    self.ataque(contrincante,guerrero)      //Recibe contraataque
  }
}

class TacticaResistencia inherits Tactica()
{
  method recibirAtaque(guerrero,contrincante) = guerrero.perderVida(contrincante.poderDeAtaque()/2)
  override method secuenciaDeAtaque(guerrero,contrincante){
    self.recibirAtaque(guerrero,contrincante)   //Recibe daño reducido
    self.ataque(guerrero,contrincante)          //Contraataca
  }
}

class TacticaCaruso inherits Tactica
{
  const umbralDeEnergia

  method huir(guerrero) = guerrero.perderVida(10)
  method poderMenorAlUmbral(guerrero,contrincante) = umbralDeEnergia > contrincante.poderDeAtaque()
  override method secuenciaDeAtaque(guerrero,contrincante){
    if(guerrero.estaVivo()){
      if(self.poderMenorAlUmbral(guerrero,contrincante)){
        self.ataque(guerrero,contrincante)      //Ataca primero
        self.ataque(contrincante,guerrero)      //Recibe contraataque
      }
      else self.huir(guerrero)
    }
  }
}

class TacticaCuatroTresTres inherits Tactica
{
  method evitaAtaque(guerrero) = guerrero.vida() > 60
  override method secuenciaDeAtaque(guerrero,contrincante){
    if(guerrero.estaVivo()){
      self.ataque(guerrero,contrincante)      
      self.ataque(guerrero,contrincante)      //Ataca dos veces
      if(!self.evitaAtaque(guerrero)) self.ataque(contrincante,guerrero)
    }
  }
}

/*-------------------------PARTE 2-------------------------*/

class Anillo {
  var duenio
  method invocarAnillo(){
    duenio.vida((duenio.vida()*2).min(100))
    self.efecto()
  }
  method efecto()
}

class AnilloFuego inherits Anillo{
override method efecto(){
  duenio.enfrentarse(duenio.archienemigo())
  duenio.archienemigo().perderVida(20)
}
}

class AnilloMaldito inherits Anillo{
  override method efecto(){
(duenio.armas().max({arma=>arma.poder()})).remove()
}
}

class AnilloAire inherits Anillo{
  override method efecto(){
    duenio.mejorAmigo().aumentarVida(30)
  }
}

object anilloUnico inherits Anillo(duenio=gollum) {

override method efecto(){
if(duenio.cantidadDeArmas()>3){
    duenio.perderVida(20)
}  
else
{
  duenio.perderVida(30)
}
}
}