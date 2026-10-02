/*-------------------------PARTE 1-------------------------*/

class Baculo
{
  var property poderBase = 250

  method poder(guerrero){
    return
      if(guerrero.tienePocaVida()) 400.min(poderBase*2)
      else 400.min(poderBase)
  }
}

class Espada
{
  const poderBase = 10
  var property magia = elfica

  method poder(guerrero) = magia.valor(guerrero)*poderBase
}

class FlechaDeBronce
{
  const poderBase = 100
  var property fechaDeLustre = new Date()
  var property fechaDeUso = new Date()

  method calcularDiferenciaDeFechas() = 0.max(fechaDeUso - fechaDeLustre)
  method poder(guerrero) = 0.max(poderBase - self.calcularDiferenciaDeFechas())
}

class FlechaDeAluminio
{
  var property poderBase = 50

  method poder(guerrero) = poderBase
}

class FlechaDeHierro
{
  var property oxidada = false
  const poderBase = 70

  method poder(guerrero)
  {
    return
      if(oxidada) poderBase/2
      else poderBase
  }
}

const baculo = new Baculo()
const espada = new Espada()
const flechaDeBronce = new FlechaDeBronce(
  fechaDeLustre = new Date(day=1, month=1, year=2024),
  fechaDeUso = new Date(day=5, month=1, year=2024))
const flechaDeAluminio = new FlechaDeAluminio()
const flechaDeHierro = new FlechaDeHierro()

object elfica
{
  method valor(guerrero) = 25
}

object enana
{
  method valor(guerrero) = guerrero.vida()/2
}

object gandalf
{
  var property vida = 100
  var property armas = [baculo,espada,cajaDeFlechasNegras]

  method poder() = (self.vida() * self.multiplicadorVida()) + self.poderDeArmas()* 2
  method poderDeArmas() = armas.sum({arma => arma.poder(self)})
  method tieneArmas() = !armas.isEmpty()
  method cantidadDeArmas() = armas.size()
  method tienePocaVida() = self.vida() < 10
  method cambiarVida(valor) {vida = 0.max(self.vida() + valor)}
  method multiplicadorVida() = if(self.tienePocaVida()) 200 else 15
}

object cajaDeFlechasNegras
{
  const flechas = [flechaDeAluminio,flechaDeHierro,flechaDeBronce]

  method flechasPoderosas(guerrero) = flechas.filter({flecha => flecha.poder(guerrero)>50})
  method poder(guerrero) = self.flechasPoderosas(guerrero).average({flecha => flecha.poder(guerrero)})
}

/*-------------------------PARTE 2-------------------------*/

object lebennin
{
  var property cantidadDeGuardias = 5

  method tieneMuchosGuardias() = cantidadDeGuardias > 3
  method poderNecesario() = if (self.tieneMuchosGuardias()) 1500 else 1000
  method puedePasar(guerrero) = guerrero.poder() > self.poderNecesario()
  method atravesar(guerrero){
    return
      if(self.puedePasar(guerrero)) guerrero
      else throw new DomainException(message = "No puede atravesar Lebennin")
  }
}

object minasTirith
{
  method puedePasar(guerrero) = guerrero.tieneArmas()
  method atravesar(guerrero)
  {
    if(self.puedePasar(guerrero)){
      const danio = -guerrero.cantidadDeArmas()*10
      guerrero.cambiarVida(danio)
    }
    else throw new DomainException(message = "No puede atravesar Minas Tirith")
  }
}

object lossarnach
{
  method puedePasar(guerrero) = true
  method atravesar(guerrero)
  {
    if(self.puedePasar(guerrero)){
      const vida = guerrero.cantidadDeArmas()*2
      guerrero.cambiarVida(vida)
    }
  }
}

object caminoDeGondor
{
  const zonas = [lebennin,minasTirith]

  method puedePasar(guerrero) = zonas.all({lugar => lugar.puedePasar(guerrero)})
  method atravesar(guerrero)
  {
    if(self.puedePasar(guerrero)) zonas.forEach({lugar => lugar.atravesar(guerrero)})
    else throw new DomainException(message = "No puede atravesar este camino")
  }
}

/*-------------------------PARTE 3-------------------------*/

object tomBombadil
{
  var property vida = 100

  method poder() = 2000
  method tieneArmas() = true
  method cantidadDeArmas() = 100
  method cambiarVida(valor) {}
}

/*--------------------CLASES PARA TESTS--------------------*/

class Arma
{
  var property poderBase

  method poder(guerrero) = poderBase
}

class Guerrero
{
  var property vida
  var property poder
  var property armas = []

  method cantidadDeArmas() {return armas.size()}
  method tieneArmas() = !armas.isEmpty()
  method cambiarVida(valor) {vida = 0.max(self.vida() + valor)}
  method tienePocaVida() {return vida < 10}
}