;;; Hechos estaticos;
(deffacts Habitaciones
  (Habitacion Recepcion)    ;;;;  Receptión es una habitación
  (Habitacion Pasillo)
  (Habitacion Oficina1)
  (Habitacion Oficina2)
  (Habitacion Oficina3)
  (Habitacion Oficina4)
  (Habitacion Oficina5)
  (Habitacion OficinaDoble)
  (Habitacion Gerencia)
  (Habitacion Papeleria)
  (Habitacion Aseos)
  (Habitacion AseoHombres)
  (Habitacion AseoMujeres)
  )
  (deffacts Puertas
  (Puerta Recepcion Pasillo)    ;;;; Hay una puerta que comunica Recepción con Pasillo
  (Puerta Pasillo Oficina1)
  (Puerta Pasillo Oficina2)
  (Puerta Pasillo Oficina3)
  (Puerta Pasillo Oficina4)
  (Puerta Pasillo Oficina5)
  (Puerta Pasillo Gerencia)
  (Puerta Pasillo OficinaDoble)
  (Puerta Pasillo Papeleria)
  )
  (deffacts Empleados
  (Empleado G1 Oficina1)          ;;;;; El empleado G1 atiende en la Oficina 1
  (TramitesRealizados G1 0)
  (Empleado G2 Oficina2)
  (TramitesRealizados G2 0)
  (Empleado G3 Oficina3)
  (TramitesRealizados G3 0)
  (Empleado G4 Oficina4)
  (TramitesRealizados G4 0)
  (Empleado G5 Oficina5)
  (TramitesRealizados G5 0)
  (Empleado E1 OficinaDoble-1)
  (TramitesRealizados E1 0)
  (Empleado E2 OficinaDoble-2)
  (TramitesRealizados E2 0)
  (Empleado Recepcionista Recepcion)
  (Empleado Director Gerencia)
  )
   (deffacts Codificacion
   (Code TG "Tramites Generales")
   (Code TE "Tramites Especiales")
   )
  (deffacts Tareas
  (Tarea G1 TG)                   ;;;;; El empleado G1 atiende Trámites Generales
  (Tarea G2 TG)
  (Tarea G3 TG)
  (Tarea G4 TG)
  (Tarea G5 TG)
  (Tarea E1 TE)                   ;;;;; El empleado E1 atiende Trámites Especiales
  (Tarea E2 TE)
  )
  (deffacts Inicializacion
  (Personas 0)                    ;;; Inicialmente hay 0 personas en las oficinas
  (Usuarios TG 0)                 ;;; Inicialmente hay 0 Usuarios de trámites generales
  (UltimoUsuarioAtendido TG 0)    ;;; Inicialmente se han atendido 0 usuarios de tramites generales
  (Usuarios TE 0)
  (UltimoUsuarioAtendido TE 0)
  (Empleados 0)                   ;;; Inicialmente hay 0 empleados en las oficinas
  (Ejecutar)
  (Contar TG 0)
  (Contar TE 0)
  )
  ;(deffacts Constantes
  ;(ComienzoJornada 8)
  ;(FinalJornada 14)
  ;(ComienzoAtencion 9)
  ;(MinimoEmpleadosActivos TG 3)
  ;(MinimoEmpleadosActivos TE 1)
  ;(MaximoEsperaParaSerAtendido TG 30)
  ;(MaximoEsperaParaSerAtendido TE 20)
  ;(MaximoTiempoGestion TG 10)
  ;(TiempoMedioGestion TG 5)
  ;(MaximoTiempoGestion TE 15)
  ;(TiempoMedioGestion TE 8)
  ;(TiempoMaximoRetraso 15)
  ;(TiempoMaximoDescanso 5)
  ;(MinimoTramitesPorDia TG 20)
  ;(MinimoTramitesPorDia TE 15)
  ;)


  (defrule cargarconstantes
  (declare (salience 10000))
  =>
  (load-facts Constantes.txt)
  )


  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; PASO1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;respuestas ante los hechos (Solicitud ?tipotramite) y (Disponible ?empl);;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; 1A ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (defrule EncolarUsuario
  ?g <- (Solicitud ?tipotramite)
  ?f <- (Usuarios ?tipotramite ?n)
  (MaximoEsperaParaSerAtendido ?tipotramite ?time)
  (HoraActualizada ?trns)
  =>
  (assert (Usuario ?tipotramite (+ ?n 1))
          (Usuarios ?tipotramite (+ ?n 1))
  )
  ;(bind ?timpoini (+ (hora-segundos ( horasistema ) ) (minutos-segundos ( minutossistema ) ) ) )
  ;(bind ?timpofin (+ ?timpoini (minutos-segundos ?time ) ) )

  (bind ?incre (* 60 ?time))
  (bind ?timpofin (+ ?trns ?incre))
  (printout t "Su turno es " ?tipotramite " " (+ ?n 1) " maximo para ser atendido "  ?timpofin  crlf)
   (assert (TimeUser ?tipotramite ?n ?timpofin))
  (retract ?f ?g)
  )

  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; 1B ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  (defrule AsignarEmpleado
  ?g <- (Disponible ?empl)
  (Tarea ?empl ?tipotramite)
  (Empleado ?empl ?ofic)
  ?f <- (UltimoUsuarioAtendido ?tipotramite ?atendidos)
  (Usuarios ?tipotramite ?total)
  (MaximoTiempoGestion ?tipotramite ?minuto)
  (HoraActualizada ?trns)
  (test (< ?atendidos ?total))
  =>
  (bind ?a (+ ?atendidos 1))
  (bind ?timemax (+ ?trns (* ?minuto 60)))
  (assert (Asignado ?empl ?tipotramite ?a)
          (UltimoUsuarioAtendido ?tipotramite ?a)
          (EnTramite ?tipotramite ?a ?timemax )
          )
  (printout t "Usuaro " ?tipotramite ?a ", por favor pase a " ?ofic crlf)
  (retract ?f ?g )
  )

  (defrule RegistrarCaso
  (declare (salience 10))
  (Disponible ?empl)
  ?f <- (Asignado ?empl ?tipotramite ?n)
  ?g <- (EnTramite ?tipotramite ?n ?timemax)
  ?h <- (TramitesRealizados ?empl ?p)
  =>
  (assert (Tramitado ?empl ?tipotramite ?n))
  (assert (TramitesRealizados ?empl (+ ?p 1)))
  (printout t "Empleado " ?empl ", a realizado " (+ ?p 1) " tramites. " crlf)
  (retract ?f ?g ?h)
  )

  (defrule MuchoTiempoDeGestion
    (declare (salience 15))
    (MaximoTiempoGestion ?tipotramite ?minuto)
    ?f <- (EnTramite ?tipotramite ?n ?timemax)
    (HoraActualizada ?t)
    (test (< ?timemax ?t))
    =>
    (printout t "Usuaro " ?tipotramite ?n ", por favor termine " crlf)
    (bind ?extra (+ ?timemax (* 60 ?minuto)))
    (assert (EnTramite ?tipotramite ?n ?extra))
    (retract ?f)
  )



  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;; 1C ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



  (defrule NoposibleEncolarUsuario
  (declare (salience 20))
  ?g <- (Solicitud ?tipotramite)
  (Usuarios ?tipotramite ?n)
  (UltimoUsuarioAtendido ?tipotramite ?atendidos)
  (TiempoMedioGestion ?tipotramite ?m)
  (FinalJornada ?h)
  (test (> (* (- ?n ?atendidos) ?m) (mrest ?h)))
  (Code  ?tipotramite ?texto)
  =>
  (printout t "Lo siento pero por hoy no podremos atender mas " ?texto crlf)
  (bind ?a (- ?n ?atendidos))
  (printout t "Hay ya  " ?a " personas esperando y se cierra a las " ?h "h. No nos dara tiempo a atenderle." crlf)
  (retract ?g)
  )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EJERCICIO 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule EmpleadoAtiende
  (declare (salience 10))
  ?f <- (Ficha ?ID)
  (not (Trabajando ?ID))
  (Tarea ?ID ?tramite)
  ?g <- (Contar ?tramite ?n)
  =>
  (retract ?g ?f)
  (assert (Trabajando ?ID))
  (assert (Contar ?tramite (+ ?n 1)))
  )

  (defrule EmpleadoSeMarcha
    (declare (salience 10))
    ?f <- (Ficha ?ID)
    ?g <- (Trabajando ?ID)
    (Tarea ?ID ?tramite)
    ?h <- (Contar ?tramite ?n)
    =>
    (retract ?g ?f ?h)
    (assert (Contar ?tramite (- ?n 1)))
  )

  (defrule NoSuficientesEmpleados
    (declare (salience 20))
    (Contar ?tramite ?n)
    (MinimoEmpleadosActivos ?tramite ?limite)
    (test (< ?n ?limite))
    (not (NOSUFICIENTES ?tramite))
    =>
    (printout t "Hay pocos empleados atendiendo los siguientes tramites." ?tramite crlf)
    (assert (NOSUFICIENTES ?tramite))
    )

  (defrule HanLLegadoEmpleados
    (declare (salience 20))
    (Contar ?tramite ?n)
    (MinimoEmpleadosActivos ?tramite ?limite)
    (test (>= ?n ?limite))
    ?g <- (NOSUFICIENTES ?tramite)
    =>
    (printout t "Han llegado suficientes empleados de ." ?tramite crlf)
    (retract ?g)
    )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EJERCICIO 1.2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule NoAtendidoATiempo
  (TimeUser ?tipotramite ?n ?timpofin)
  (UltimoUsuarioAtendido ?tipotramite ?total)
  (HoraActualizada ?t)
  (test (> ?t ?timpofin ))
  (test (< ?total ?n))
  (not (UsuarioNoAtendido ?tipotramite ?n))
  =>
  (assert (UsuarioNoAtendido ?tipotramite ?n))
  (printout t "El usuario " ?tipotramite " " ?n " va con retraso" crlf)
)

(defrule AtendidoATiempo
  ?f <-(TimeUser ?tipotramite ?n ?timpofin)
  (UltimoUsuarioAtendido ?tipotramite ?total)
  (test (> ?total ?n))
  =>
  (retract ?f)
  (printout t "El usuario " ?tipotramite " " (+ ?n 1)" ha sido atendido" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EJERCICIO 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule Retraso
  (declare (salience 20))
  (HoraActualizada ?t)
  (TiempoMaximoRetraso ?time)
  (Ficha ?ID)
  (ComienzoJornada ?entrada)
  (test (< (+ (hora-segundos ?entrada) (* 60 ?time)) ?t))
  (not (Retrasado ?ID))
  =>
  (printout t "El empleado " ?ID " viene retrasado" crlf)
  (assert (Retrasado ?ID))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EJERCICIO 2.2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule EstadoEmpleado
  (declare (salience 15))
  (Ficha ?ID)
  (HoraActualizada ?t)
  (TiempoMaximoDescanso ?max)
  (and (Trabajando ?ID) (not (DESCANSO ?ID ?hora)) (not (FINDESCANSO ?ID)))
  =>
  (bind ?horamax (+ ?t (* 60 ?max)))
  (assert (DESCANSO ?ID ?horamax))
)

(defrule VagoTrabajo
  ?f <- (DESCANSO ?ID ?horamax)
  (TiempoMaximoDescanso ?max)
  (HoraActualizada ?t)
  (not (FINDESCANSO ?ID))
  (test (< ?t ?horamax))
  =>
  (printout t "El empleado " ?ID " lleva demasiado descansando" crlf)
  (bind ?nuevomax (+ ?t (* 60 ?max)))
  (assert (DESCANSO ?ID ?nuevomax))
  (retract ?f)
  )

  (defrule VuelveAlTrabajo
    (declare (salience 25))
    (and (not (FINDESCANSO ?ID)) (not (Trabajando ?ID)) )
    ?f <- (DESCANSO ?ID ?hora)
    (Ficha ?ID)
    =>
    (retract ?f)
    (assert (FINDESCANSO ?ID))
  )

  (defrule FinJornada
    (declare (salience 25))
    (and (FINDESCANSO ?ID) (Trabajando ?ID) (not (FINJORNADA ?ID)))
    (Ficha ?ID)
    =>
    (assert (FINJORNADA ?ID))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EJERCICIO 2.3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule AvisoDespido
  (declare (salience 25))
  (HoraActualizada ?t)
  (MinimoTramitesPorDia ?min)
  (FinalJornada ?h)
  ?g <- (TramitesRealizados ?empl ?num)
  (test (< (hora-segundos ?h) ?t))
  (test (< ?num ?min))
  =>
  (printout t "El empleado " ?empl " ha sido despedido" crlf)
  (retract ?g)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EJERCICIO 3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule Enciende
  ?f <- (Luz ?hab OFF)
  (Sensor_presencia ?hab)
  (Sensor_puerta ?hab)
  =>
  (assert (Luz ?hab ON)
          (Personas_en_hab ?hab 1))
  (retract ?f)
)

(defrule Apaga
  ?f <- (Luz ?hab ON)
  ?g <- (Personas_en_hab ?hab ?n)
  (not (Sensor_presencia ?hab))
  =>
  (assert (Luz ?hab OFF))
  (retract ?f ?g)
)

(defrule Incrementa
  (Luz ?hab ON)
  ?f <- (Personas_en_hab ?hab ?n)
  (Sensor_puerta ?hab)
  =>
  (assert (Personas_en_hab ?hab (+ ?n 1)))
  (retract ?f)
)
