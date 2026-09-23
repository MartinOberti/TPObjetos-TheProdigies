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
  var property fechaDeLustre = new Fecha(dia=1,mes=1,anio=2024)
  var property fechaDeUso = new Fecha(dia=5,mes=1,anio=2024)

  method calcularDiferenciaDeFechas()
  {
    return (fechaDeUso.dia()-fechaDeLustre.dia()
    + 30*(fechaDeUso.mes()-fechaDeLustre.mes())
    + 365*(fechaDeUso.anio()-fechaDeLustre.anio()))
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
  var property armas = [baculo,espada]
  method poder()
  {
    if(self.vida() < 10) {return vida * 200 + armas.sum({arma => arma.poder(self)}) * 2}
    else {return vida * 15 + armas.sum({arma => arma.poder(self)}) * 2}
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

class Fecha
{
  var property dia
  var property mes
  var property anio 
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
}

object minasTirith
{
  method puedePasar(guerrero)
  {
    if(guerrero.tieneArmas())
    {
      const aux = -guerrero.cantidadDeArmas()*10
      guerrero.cambiarVida(aux)
      return true
    }
    else {return false}
  }
}

object lossarnach
{
  method puedePasar(guerrero)
  {
    const aux = guerrero.cantidadDeArmas()*2
    guerrero.cambiarVida(aux)
    return true
  }
}

object caminoDeGondor
{
  var property camino = [lebennin,minasTirith]
  method puedePasar(guerrero)
  {
    return camino.all({lugar => lugar.puedePasar(guerrero)})
  }
}

/*-------------------------PARTE 3-------------------------*/

object tomBombadil
{
  var property vida = 100
  var property armas = [espada]

  method poder() {return 2000}
  method tieneArmas() {return armas.size() > 0}
  method cambiarVida(valor) {}
  method cantidadDeArmas() {return 100}
}