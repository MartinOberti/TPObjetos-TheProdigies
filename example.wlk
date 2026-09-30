/*-------------------------PARTE 1-------------------------*/

class Baculo
{
  var property poderBase = 250

  method poder(guerrero) {
    if(guerrero.vida() < 10){
      return 400.min(poderBase*2)
    }
    else 
    return 400
    }
}
const baculo = new Baculo()

class Espada
{
  const poderBase = 10
  var property magia = elfica

  method poder(guerrero) {return magia.valor(guerrero)*poderBase}
}
const espada = new Espada()

class FlechaDeBronce
{
  const poderBase = 100
  var property fechaDeLustre = new Date(day=1, month=1, year=2024)
  var property fechaDeUso = new Date(day=5, month=1, year=2024)

  method calcularDiferenciaDeFechas()
  {
    const dias = fechaDeUso - fechaDeLustre
    return dias
  }

  method poder(guerrero)
  { 
    return 0.max(poderBase - self.calcularDiferenciaDeFechas())
  }
}
const flechaDeBronce = new FlechaDeBronce()
object flechaDeAluminio
{
  var property poderBase = 50
  method poder(guerrero) {return poderBase}
}

class FlechaDeHierro
{
  var property oxidada=false
  const poderBase = 70
  method poder(guerrero)
  {
    var aux = poderBase
    if(oxidada){aux=aux/2}
    return aux
  }
}
const flechaDeHierro = new FlechaDeHierro()
object elfica
{
  method valor(guerrero)=25
}

object enana
{
  method valor(guerrero)= guerrero.vida()/2
}

object gandalf
{
  var property vida = 100
  var property armas = [baculo,espada,cajaDeFlechasNegras]
  method poder()
  {
    return (self.vida() * self.multiplicadorVida()) + armas.poderTotal()* 2
  }

  method poderTotal()= armas.sum({ arma => arma.poder(self) })
  method multiplicadorVida ()= if(self.vida() < 10) 200 else 15

  method tieneArmas() {return armas.empty().not()}
  method cantidadDeArmas() {return armas.size()}
  method cambiarVida(valor) {
    vida = 0.max(vida + valor)
    }
}

object cajaDeFlechasNegras
{
  var property flechas = [flechaDeAluminio,flechaDeHierro,flechaDeBronce]
  method poder(guerrero)
  {
    const aux = flechas.filter({flecha => flecha.poder(guerrero)>50})
    return aux.average({flecha => flecha.poder(guerrero)})
  }
}

class Arma
{
  var property unPoder 
  method poder(guerrero) {return unPoder}
}

class Guerrero
{
  var property vida
  var property unPoder
  var property armas = []
  method cantidadDeArmas() {return armas.size()}
  method poder() {return unPoder}
  method tieneArmas() {return armas.empty().not()}
  method cambiarVida(valor) {
    vida = 0.max(vida + valor)
    }
}

/*-------------------------PARTE 2-------------------------*/

object lebennin
{
  var property cantidadDeGuardias = 5

  method poderNecesario()
  {
    if(self.tieneMuchosGuardias()){
      return 1500
    }
    else
    return 1000
   
  }

  method tieneMuchosGuardias(){
    return cantidadDeGuardias > 3
  }

  method puedePasar(guerrero)
  {
    return guerrero.poder() > self.poderNecesario()
  }

  method atravesar(guerrero) {return guerrero}
}

object minasTirith
{
  method puedePasar(guerrero)
  {
    return guerrero.tieneArmas()
  }

  method atravesar(guerrero) 
  {
    if(self.puedePasar(guerrero))
    {
      const danio = -guerrero.cantidadDeArmas()*10
      guerrero.cambiarVida(danio)
    }
  }
}

object lossarnach
{
  method puedePasar(guerrero)
  {
    return true
  }
  method atravesar(guerrero)
  {
    if(self.puedePasar(guerrero))
    {
      const vida = guerrero.cantidadDeArmas()*2
      guerrero.cambiarVida(vida)
    }
  }
}

object caminoDeGondor
{
  var property camino = [lebennin,minasTirith]

  method puedePasar(guerrero)
  {
    return camino.all({lugar => lugar.puedePasar(guerrero)})
  }

  method atravesar(guerrero)
  {
    if(self.puedePasar(guerrero)){
    camino.forEach({lugar => lugar.atravesar(guerrero)})
    }
  }
}

/*-------------------------PARTE 3-------------------------*/

object tomBombadil
{
  var property vida = 100

  method poder() {return 2000}
  method tieneArmas() {return true}
  method cambiarVida(valor) {}
  method cantidadDeArmas() {return 100}
}