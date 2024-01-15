# Script mailing encuesta LISA-COES
# EVITAR EDITAR/MOVER COSAS!!!!

# Librerías

library(janitor)
library(purrr)
library(blastula)

# Crear credenciales. Provider es el servicio de correo electrónico. # Se solicita clave, se consigue en los ajustes de Gmail ('Contraseña de aplicación')

create_smtp_creds_file(
  file = 'gmail_creds',
  user = 'moira0martinez@gmail.com',
  provider = 'gmail'
)

# Base de datos
destinatarios <- read.csv2(file = 'test_data.csv')
destinatarios <- clean_names(destinatarios)

# Selección de destinatarios

nombre <- destinatarios$nombre

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

Espero que se encuentre bien. Mi nombre es [Tu Nombre] y soy parte del <b>Laboratorio de Investigación Social Abierta (LISA)</b> del Centro de Estudios de Conflicto y Cohesión Social (COES). Nos dirigimos a usted en su calidad de representante del Proyecto Innovación en Educación Superior (InES) en Ciencia Abierta de su institución con el propósito de invitarlo/a a contestar y difundir una encuesta sobre Ciencia Abierta dirigida a académicos, académicas e investigadores de ciencias sociales en Chile. 

Desde LISA estamos desarrollando la primera encuesta que analiza el conocimiento, creencias y prácticas de Ciencia Abierta en investigadores de Ciencias Sociales en Chile. Este esfuerzo busca comprender mejor el panorama de la Ciencia Abierta en Chile y permitirá generar recomendaciones y propuestas tanto para el quehacer académico como para las políticas científicas.

Valoramos su experiencia y trabajo en el proyecto InES y creemos que su participación es crucial para lograr la mejor representatividad en esta encuesta pionera en el campo. Creemos que el involucramiento de InES influirá en la dirección futura de la investigación en educación superior. Por ello, lo/a  invitamos a difundir la encuesta en su institución, así como a resaltar la importancia de la participación de académicos y académicas.

Consistente con los principios de la Ciencia Abierta, los datos estarán disponibles de forma abierta y gratuita en diferentes fases, siendo la primera de uso preferente para los proyectos InES. Esto presenta una oportunidad única para conocer el estado de la Ciencia Abierta tanto a nivel institucional como a nivel nacional, pudiendo influir en la investigación y la innovación en educación superior en Chile.

<b>Puede acceder a la encuesta a través del siguiente enlace: <a href="https://lisa-survey.formr.org/">https://lisa-survey.formr.org/</a>. El cuestionario no debería llevar más de 10 minutos.</b>

Entendemos que puedan surgir preguntas o dudas respecto a la encuesta y su participación en la misma. Estamos disponibles para agendar una reunión donde aclarar dudas y discutir los términos de su participación en la encuesta.

Le extendemos nuestro agradecimiento por su tiempo y esperamos contar con su valiosa participación en la primera Encuesta de Ciencia Abierta en Investigación Social en Chile.

Atentamente,

[Tu Nombre]
[Tu Cargo]
[Tu Institución/Proyecto]
[Información de Contacto] </big></center>
      
    ')), header = image, footer = md(glue::glue('<a href="https://lisa-survey.formr.org/">Encuesta de Ciencia Abierta en Investigación Social (CAIS)</a>')),
  )
  
  # Personalizar el nombre del destinatario en el cuerpo del correo
  etiqueta_nombre <- "{nombre}"  # Etiqueta a reemplazar
  email_template$body <- reemplazar_etiquetas(email_template$body, etiqueta_nombre, nombre)
  
  # Enviar el correo electrónico al destinatario actual
  email_template %>% 
    smtp_send(
      to = correo,
      from = c('Moira Martínez Sembler'= "moira0martinez@gmail.com"),
      subject = "[PRUEBA 4] Invitación a Participar en Encuesta sobre Ciencia Abierta",
      credentials = creds_file("gmail_creds")
    )
}

# Aplicar la función a cada fila del conjunto de datos
pmap(list(destinatarios$nombre, destinatarios$correo), enviar_correo)
