#!/usr/bin/env python
#Fichero Python para la creacion del informe
# @author: Ismael Marin Molina
import numpy as np
import math

def Tablas(extraidos):
    TipoTramites = np.array([])
    IdTramites = np.array([])
    Inicio = np.array([])
    Fin = np.array([])

    for fact in extraidos:
        fact = fact[1:len(fact)-2]
        subresult = fact.split()
        TipoTramites = np.append(TipoTramites,subresult[1])
        IdTramites = np.append(IdTramites ,subresult[2])
        Inicio = np.append(Inicio,int(subresult[3]))
        Fin = np.append(Fin,int(subresult[4]))

    Media = sum(Fin-Inicio)/len(Fin)
    print("Media del tiempo : {}s +/- {}s".format(  Media, math.sqrt(  sum( ( (Fin - Inicio) - Media)**2 ) /len(Fin)  ) ))
    print("--------------------------------------------------------")
    print("|        TG              ||               TE           |")
    print("--------------------------------------------------------")
    indexs = np.where(TipoTramites == 'TG')
    InicioTG = Inicio[indexs]
    FinTG = Fin[indexs]
    MediaTG = sum(FinTG-InicioTG)/len(FinTG)
    DesvTG = math.sqrt(  sum( ( (FinTG - InicioTG) - MediaTG)**2 ) /len(FinTG)  )

    indexs = np.where(TipoTramites == 'TE')
    InicioTE = Inicio[indexs]
    FinTE = Fin[indexs]
    MediaTE = sum(FinTE-InicioTE)/len(FinTE)
    DesvTE = math.sqrt(  sum( ( (FinTE - InicioTE) - MediaTE)**2 ) /len(FinTE)  )
    print("| {0:.3f}s   +/- {1:.1f}s  ||   {2:.3f}s   +/- {3:.1f}s    |".format(  MediaTG, DesvTG, MediaTE , DesvTE ))
    print("--------------------------------------------------------")

    return Inicio, Fin, TipoTramites, IdTramites

if __name__ == "__main__":
    f = open("Situacionfinal.txt")
    Tramites = []
    TiempoEspera = []
    Empleados = []
    OnTime = []
    Retarder = []
    for line in f:
        if line.find("TIMETRAMITADO") >= 0:
            Tramites.append(line)
        elif line.find("TIMECOLA") >= 0:
            TiempoEspera.append(line)
        elif line.find("Tramitado") >= 0:
            Empleados.append(line)
        elif line.find("ONTIME") >= 0:
            OnTime.append(line)
        elif line.find("RETRASADO") >= 0:
            Retarder.append(line)
    print("Se han completado un numero de {} tramites".format(len(Tramites)))
    print()
    print( "              RESULTADOS DE LA TRAMITACION                 ")
    print()
    Inicio,Fin,Tipo,Id = Tablas(Tramites)
    print()
    print( "             RESULTADOS DE LA ESPERA EN COLA               ")
    print()
    Tablas(TiempoEspera)

    print()
    CantidadTG = len(Fin[np.where(Tipo == 'TG')])
    print("Se han realizado {} Tramites Generales".format(CantidadTG))
    print("Se han realizado {} Tramites Especificos".format(len(Fin) - CantidadTG))

    print()

    IdG1 = IdG2 = IdG3 = IdG4 = IdG5 = IdE1 = IdE2 = np.array([])

    result = [0,0,0,0,0,0,0]

    for factOn in  OnTime:
        factOn = factOn[1:len(factOn)-2]
        subresultOn = factOn.split()

        if subresultOn[1] == 'G1':
            result[0] = 1

        if subresultOn[1] == 'G2':
            result[1] = 1

        if subresultOn[1] == 'G3':
            result[2] = 1

        if subresultOn[1] == 'G4':
            result[3] = 1

        if subresultOn[1] == 'G5':
            result[4] = 1

        if subresultOn[1] == 'E1':
            result[5] = 1

        if subresultOn[1] == 'E2':
            result[6] = 1

    for factRetar in Retarder:
        factRetar = factRetar[1:len(factRetar)-2]
        subresultRetar = factRetar.split()

        if subresultRetar[1] == 'G1':
            result[0] = 2

        if subresultRetar[1] == 'G2':
            result[1] = 2

        if subresultRetar[1] == 'G3':
            result[2] = 2

        if subresultRetar[1] == 'G4':
            result[3] = 2

        if subresultRetar[1] == 'G5':
            result[4] = 2

        if subresultRetar[1] == 'E1':
            result[5] = 2

        if subresultRetar[1] == 'E2':
            result[6] = 2




    for fact in Empleados:
        fact = fact[1:len(fact)-2]
        subresult = fact.split()
        if subresult[1] == 'G1':
            IdG1 = np.append(IdG1, subresult[3])
        if subresult[1] == 'G2':
            IdG2 = np.append(IdG2, subresult[3])
        if subresult[1] == 'G3':
            IdG3 = np.append(IdG3, subresult[3])
        if subresult[1] == 'G4':
            IdG4 = np.append(IdG4, subresult[3])
        if subresult[1] == 'G5':
            IdG5 = np.append(IdG5, subresult[3])
        if subresult[1] == 'E1':
            IdE1 = np.append(IdE1, subresult[3])
        if subresult[1] == 'E2':
            IdE2 = np.append(IdE2, subresult[3])

    IdTG = Id[np.where(Tipo == 'TG')]
    IdTE = Id[np.where(Tipo == 'TE')]

    print("El empleado G1:")
    if result[0] != 0:
        print(" Nº Tramites: {}".format(len(IdG1)))
        indexs = np.where(np.isin(IdTG, IdG1))
        Tiempo = sum(Fin[indexs]-Inicio[indexs])
        print(" Tiempo Atendiendo: {}".format( Tiempo ))
        if len(IdG1) > 0:
            print(" Tiempo Medio: {}".format( Tiempo/len(IdG1) ))
        if result[0] == 2:
            print("El empleado ha llegado retrasado")
    else:
        print("El empleado no ha venido a trabajar")
    print("El empleado G2:")
    if result[1] != 0:
        print(" Nº Tramites: {}".format(len(IdG2)))
        indexs = np.where(np.isin(IdTG, IdG2))
        Tiempo = sum(Fin[indexs]-Inicio[indexs])
        print(" Tiempo Atendiendo: {}".format( Tiempo ))
        if len(IdG2) > 0:
            print(" Tiempo Medio: {}".format( Tiempo/len(IdG2) ))
        if result[1] == 2:
            print("El empleado ha llegado retrasado")
    else:
        print("El empleado no ha venido a trabajar")
    print("El empleado G3:")
    if result[2] != 0:
        print(" Nº Tramites: {}".format(len(IdG3)))
        indexs = np.where(np.isin(IdTG, IdG3))
        Tiempo = sum(Fin[indexs]-Inicio[indexs])
        print(" Tiempo Atendiendo: {}".format( Tiempo ))
        if len(IdG3) > 0:
            print(" Tiempo Medio: {}".format( Tiempo/len(IdG3) ))
        if result[2] == 2:
            print("El empleado ha llegado retrasado")
    else:
        print("El empleado no ha venido a trabajar")
    print("El empleado G4:")
    if result[3] != 0:
        print(" Nº Tramites: {}".format(len(IdG4)))
        indexs = np.where(np.isin(IdTG, IdG4))
        Tiempo = sum(Fin[indexs]-Inicio[indexs])
        print(" Tiempo Atendiendo: {}".format( Tiempo ))
        if len(IdG4) > 0:
            print(" Tiempo Medio: {}".format( Tiempo/len(IdG4) ))
        if result[3] == 2:
            print("El empleado ha llegado retrasado")
    else:
        print("El empleado no ha venido a trabajar")

    print("El empleado G5:")
    if result[4] != 0:
        print(" Nº Tramites: {}".format(len(IdG5)))
        indexs = np.where(np.isin(IdTG, IdG5))
        Tiempo = sum(Fin[indexs]-Inicio[indexs])
        print(" Tiempo Atendiendo: {}".format( Tiempo ))
        if len(IdG5) > 0:
            print(" Tiempo Medio: {}".format( Tiempo/len(IdG5) ))
        if result[4] == 2:
            print("El empleado ha llegado retrasado")
    else:
        print("El empleado no ha venido a trabajar")
    print("El empleado E1:")
    if result[5] != 0:
        print(" Nº Tramites: {}".format(len(IdE1)))
        indexs = np.where(np.isin(IdTE, IdE1))
        Tiempo = sum(Fin[indexs]-Inicio[indexs])
        print(" Tiempo Atendiendo: {}".format( Tiempo ))
        if len(IdE1) > 0:
            print(" Tiempo Medio: {}".format( Tiempo/len(IdE1) ))
        if result[5] == 2:
            print("El empleado ha llegado retrasado")
    else:
        print("El empleado no ha venido a trabajar")
    print("El empleado E2:")
    if result[6] != 0:
        print(" Nº Tramites: {}".format(len(IdE2)))
        indexs = np.where(np.isin(IdTE, IdE2))
        Tiempo = sum(Fin[indexs]-Inicio[indexs])
        print(" Tiempo Atendiendo: {}".format( Tiempo ))
        if len(IdE2) > 0:
            print(" Tiempo Medio: {}".format( Tiempo/len(IdE2) ))
        if result[6] == 2:
            print("El empleado ha llegado retrasado")
    else:
        print("El empleado no ha venido a trabajar")
