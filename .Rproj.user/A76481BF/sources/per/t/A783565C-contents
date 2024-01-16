# Script mailing encuesta LISA-COES
# EVITAR EDITAR/MOVER COSAS!!!!

# Librerías

library(janitor)
library(purrr)
library(blastula)

# Crear credenciales. Provider es el servicio de correo electrónico. # Se solicita clave, se consigue en los ajustes de Gmail ('Contraseña de aplicación')

create_smtp_creds_file(
  file = 'gmail_creds',
  user = 'juancastillov@uchile.cl',
  provider = 'gmail'
)

# Base de datos
destinatarios <- read.csv2(file = 'data/directorios-conocimientos-2030.csv')
destinatarios <- clean_names(destinatarios)

# Selección de destinatarios

nombre <- destinatarios$nombre
cargo <- destinatarios$cargo

# Imagen de correo

image <- add_image(file = 'invitacion_encuesta.png', alt = 'lisa-survey', width = 1000)


# Crear función para reemplazar etiquetas
reemplazar_etiquetas <- function(cuerpo, etiqueta, valor) {
  cuerpo <- gsub(etiqueta, valor, cuerpo, fixed = TRUE)
  return(cuerpo)
}

# Crear función para enviar correo
enviar_correo <- function(nombre, correo) {
  library(blastula)
  library(glue)

  # Crear mail. Editar solo el cuerpo si es necesario. 
  email_template <- compose_email(
    body = md(glue::glue(
      '<center><big><b>Estimado/a {nombre}. </b>
      
<b>{cargo}.</b>

Espero que se encuentre bien. Mi nombre es Juan Carlos Castillo y soy coordinador del Laboratorio de Investigación Social Abierta [LISA](lisa-coes.cl) del Centro de Estudios de Conflicto y Cohesión Social [COES](coes.cl). Nos dirigimos a usted en su calidad de representante de un Programa Conocimientos 2030 con el propósito de invitarle a contestar y difundir una encuesta sobre Ciencia Abierta dirigida a académicos, académicas e investigadores de ciencias sociales en Chile. 

La Ciencia Abierta se ha convertido en un tema crucial en la investigación contemporánea, y su adopción puede tener un impacto significativo en la calidad y la transparencia de nuestras investigaciones. Valoramos la perspectiva que aporta su institución al ámbito de las ciencias sociales y estamos interesados en conocer las opiniones y experiencias de sus académicos en relación con la Ciencia Abierta.

La encuesta aborda temas como la colaboración en la investigación, el acceso abierto a datos y resultados, y las percepciones sobre la transparencia en la comunicación científica. La participación en esta encuesta es crucial para comprender mejor las necesidades y desafíos específicos que enfrentan los académicos en su campo.

<b>Puede acceder a la encuesta a través del siguiente enlace: <a href="https://lisa-survey.formr.org/">https://lisa-survey.formr.org/</a>. El cuestionario no debería llevar más de 10 minutos.</b>

Agradecemos de antemano su participación y colaboración en este importante proyecto. Los resultados de esta encuesta no solo beneficiarán a la comunidad académica, sino que también contribuirán al avance y la mejora continua de la investigación en ciencias sociales.

Si tiene alguna pregunta o inquietud, no dude en ponerse en contacto con nosotros.

Agradecemos sinceramente su tiempo y participación.

Atentamente,

<div style="line-height:30%;">
Juan Carlos Castillo

Profesor Asociado - Departamento de Sociología

Director de Investigación y Publicaciones, Facultad de Ciencias Sociales

Universidad de Chile

Investigador Principal COES

Coordinador LISA 

juancastillov@uchile.cl | jc-castillo.com</div> 
      
    ')), header = image, footer = md(glue::glue('<a href="https://lisa-survey.formr.org/">Encuesta de Ciencia Abierta en Investigación Social (CAIS)</a>')),
  )
  
  # Personalizar el nombre del destinatario en el cuerpo del correo
  etiqueta_nombre <- "{nombre}"  # Etiqueta a reemplazar
  email_template$body <- reemplazar_etiquetas(email_template$body, etiqueta_nombre, nombre)
  
  # Enviar el correo electrónico al destinatario actual
  email_template %>% 
    smtp_send(
      to = correo,
      from = c('Juan Carlos Castillo'= "juancastillov@uchile.cl"),
      subject = "Invitación a participar en Encuesta sobre Ciencia Abierta",
      credentials = creds_file("gmail_creds")
    )
}

# Aplicar la función a cada fila del conjunto de datos
pmap(list(destinatarios$nombre, destinatarios$correo), enviar_correo)
