/*-------------------------PARTE 1-------------------------*/

object baculo
{
  var property poderBase = 250

  method poder(guerrero) {
    var aux = poderBase
    if(guerrero.vida() < 10) {aux*=2}
    if(aux>400){aux=400}
    return aux
  }
}

object espada
{
  const poderBase = 10
  var property magia = elfica

  method poder(guerrero) {return magia.valor(guerrero)*poderBase}
}

object flechaDeBronce
{
  const poderBase = 100
  var property fechaDeLustre = new Date(day=1, month=1, year=2024)
  var property fechaDeUso = new Date(day=5, month=1, year=2024)

  method agregarMeses(meses){fechaDeUso = fechaDeUso.plusMonths(meses)}

  method calcularDiferenciaDeFechas()
  {
    const dias = fechaDeUso - fechaDeLustre
    return dias
  }

  method poder(guerrero)
  {
    var aux = poderBase - self.calcularDiferenciaDeFechas()
    if(aux<0){aux=0}
    return aux
  }
}

object flechaDeAluminio
{
  var property poderBase = 50
  method poder(guerrero) {return poderBase}
}

object flechaDeHierro
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
    const multiplicadorVida = if(self.vida() < 10) 200 else 15
    const poderArmas = armas.sum({ arma => arma.poder(self) }) * 2
    return (self.vida() * multiplicadorVida) + poderArmas
  }

  method tieneArmas() {return armas.size() > 0}
  method cantidadDeArmas() {return armas.size()}
  method cambiarVida(valor) {vida += valor}
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
  method tieneArmas() {return armas.size() > 0}
  method cambiarVida(valor) {vida += valor}
}

/*-------------------------PARTE 2-------------------------*/

object lebennin
{
  var property cantidadDeGuardias = 5
  method poderNecesario()
  {
    var aux = 1000
    if(cantidadDeGuardias > 3){aux=1500}
    return aux
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