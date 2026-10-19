```
class Grupo
{
  const property listaDeGuerreros = []

  method recorrerCamino(camino) = 
}

//class Camino importada

class Zona
{
  //Guerrero Individual
  method puedePasar(guerrero) = self.criterio(guerrero)
  method atravesar(guerrero){
    return
      if(self.puedePasar(guerrero)) self.cambiosAlGuerrero(guerrero)
      else throw new DomainException(message = "No puede atravesar esta zona")
  }
  method criterio(guerrero) = true
  method cambiosAlGuerrero(guerrero) = guerrero

  //Grupo
  const requerimientoDeZona = new RequerimientoSinRestriccion()
  method grupoPuedePasar(grupo){
    grupo.all({guerrero => self.puedePasar(guerrero)})
    requerimientoDeZona.grupoPuedePasar(grupo)
  }
  method grupoAtravesar(grupo){
    return
      if(self.grupoPuedePasar(grupo)) grupo.forEach({guerrero => self.cambiosAlGuerrero(guerrero)})
      else throw new DomainException(message = "Grupo no puede atravesar esta zona")
  }
}

class ZonaQueDemandaPoder inherits Zona
{
  const poderNecesario
  const requerimiento = new RequerimientoDePoder(cantidadNecesaria = poderNecesario)

  override method criterio(guerrero) = requerimiento.puedePasar(guerrero)
}

class ZonaQueDemandaArmas inherits Zona
{
  const vidaAQuitar

  override method criterio(guerrero) = guerrero.tieneArmas()
  override method cambiosAlGuerrero(guerrero) = guerrero.perderVida(vidaAQuitar)
}

const lebennin = new ZonaQueDemandaPoder(poderNecesario=1500)
const minasTirith = new ZonaQueDemandaArmas(vidaAQuitar=10)
const lossarnach = new Zona()

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
  method sumatoriaDeCantidad(grupo) = (grupo.listaDeGuerreros()).sum({guerrero => guerrero.cantidadDeUnElemento(nombre)})
}

class RequerimientoDeGuerrero inherits Requerimiento
{
  const cantidadNecesaria

  override method grupoPuedePasar(grupo) = grupo.any({guerrero => self.puedePasar(guerrero)})
  method puedePasar(guerrero) = self.factor(guerrero) > cantidadNecesaria
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
```