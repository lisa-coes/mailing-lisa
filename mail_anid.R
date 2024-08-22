# Script mailing encuesta LISA-COES
# EVITAR EDITAR/MOVER COSAS!!!!

# Librerías

library(janitor)
library(purrr)
library(blastula)

# Crear credenciales. Provider es el servicio de correo electrónico. # Se solicita clave, se consigue en los ajustes de Gmail ('Contraseña de aplicación')
#kevin: rfgr nbln wbyv kuas
#jc: efdx vnxv orpn rodl
create_smtp_creds_file(
  file = 'gmail_creds',
  user = 'juancastillov@uchile.cl',
  provider = 'gmail'
)

# Base de datos
destinatarios <- read.csv(file = 'data/Inves_anid_3.csv')
destinatarios <- clean_names(destinatarios)


# Selección de destinatarios

nombre <- destinatarios$nombre
nombre <- stringr::str_to_title(tolower(nombre))
apellido <- destinatarios$apellido
apellido <- stringr::str_to_title(tolower(apellido))
cargo <- destinatarios$cargo

# Imagen de correo

image <- add_image(file = 'invitacion_encuesta.png', alt = 'lisa-survey', width = 1000)


# Crear función para reemplazar etiquetas
reemplazar_etiquetas <- function(cuerpo, etiqueta, valor) {
  cuerpo <- gsub(etiqueta, valor, cuerpo, fixed = TRUE)
  return(cuerpo)
}

# Crear función para enviar correo
enviar_correo <- function(nombre, correo, apellido) {
  library(blastula)
  library(glue)
  
  # Crear mail. Editar solo el cuerpo si es necesario. 
  email_template <- compose_email(
    body = md(glue::glue(
      '<big><b>Estimado/a {nombre} {apellido}, 
    
(Si ya respondió esta encuesta anteriormente, por favor omita este correo) </b>
    
Espero que se encuentre bien. Mi nombre es Juan Carlos Castillo y soy coordinador del Laboratorio de Investigación Social Abierta [LISA](https://lisa-coes.com), una iniciativa del Centro de Estudios de Conflicto y Cohesión Social [COES](https://coes.cl/) (FONDAP/ANID 15130009) y del Núcleo Milenio sobre Desigualdades y Oportunidades Digitales [NUDOS](https://www.nudos.cl/) (Milenio ANID/NCS2022_046). Desde LISA estamos desarrollando la primera encuesta que analiza el conocimiento, creencias y prácticas de Ciencia Abierta en investigadores de Ciencias Sociales en Chile. Este esfuerzo busca comprender mejor el panorama de la Ciencia Abierta en Chile y permitirá generar recomendaciones y propuestas tanto para el quehacer académico como para las políticas científicas. Sabemos que el tiempo de las y los académicos es limitado, pero hemos tenido dificultades con la participación en este estudio, por lo que agradaceríamos de sobremanera su colaboración.

Consistente con los principios de la Ciencia Abierta, los datos estarán disponibles de forma abierta para quien desee usarlos en sus investigaciones. Esto presenta una oportunidad única para conocer el estado de la Ciencia Abierta tanto a nivel institucional como a nivel nacional, pudiendo influir en la investigación y la innovación en educación superior en Chile.

<b>Puede acceder a la encuesta a través del siguiente enlace: <a href="https://lisa-survey.formr.org/">https://lisa-survey.formr.org/</a>. El cuestionario no debería llevar más de 15 minutos.</b>

Le extendemos nuestro agradecimiento por su tiempo y esperamos contar con su valiosa participación en la primera Encuesta de Ciencia Abierta en Investigación Social en Chile.

Atentamente,

<div style="line-height:80%;">
Juan Carlos Castillo

Profesor Asociado - Departamento de Sociología

Director de Investigación y Publicaciones 

Facultad de Ciencias Sociales

Universidad de Chile

Investigador Principal [COES](https://coes.cl/) / [NUDOS](https://www.nudos.cl/)

Coordinador LISA 

juancastillov@uchile.cl | jc-castillo.com </div> 
      
    ')), header = image, footer = md(glue::glue('<a href="https://lisa-survey.formr.org/">Encuesta de Ciencia Abierta en Investigación Social (CAIS)</a>')),
  )
  
  # Personalizar el nombre del destinatario en el cuerpo del correo
  etiqueta_nombre <- "{nombre}"  # Etiqueta a reemplazar
  etiqueta_cargo <- "{apellido}"
  email_template$body <- reemplazar_etiquetas(email_template$body, etiqueta_nombre, nombre)
  
  # Enviar el correo electrónico al destinatario actual
  email_template %>% 
    smtp_send(
      to = correo,
      bcc = c('Kevin Carrasco' = 'kevin.carrasco@ug.uchile.cl'),
      from = c('Juan Carlos Castillo'= "juancastillov@uchile.cl"),
      subject = "Invitación a Participar en Encuesta sobre Ciencia Abierta",
      credentials = creds_file("gmail_creds")
    )
}

# Aplicar la función a cada fila del conjunto de datos
pmap(list(destinatarios$nombre, destinatarios$correo, destinatarios$apellido), enviar_correo)
