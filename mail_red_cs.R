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
destinatarios <- read.csv(file = 'data/directorios-prioritarios.csv')
destinatarios <- clean_names(destinatarios)

# Selección de destinatarios

nombre <- destinatarios$nombre
cargo <- destinatarios$cargo
nombre
cargo

# Crear función para reemplazar etiquetas
reemplazar_etiquetas <- function(cuerpo, etiqueta, valor) {
  cuerpo <- gsub(etiqueta, valor, cuerpo, fixed = TRUE)
  return(cuerpo)
}

# Crear función para enviar correo
enviar_correo <- function(nombre, correo, cargo) {
  library(blastula)
  library(glue)
  
  # Crear mail. Editar solo el cuerpo si es necesario. 
  email_template <- compose_email(
    body = md(glue::glue(
      '<b>Estimado/a {nombre}. </b>
      
Espero que te encuentres bien. Mi nombre es Juan Carlos Castillo y soy coordinador del Laboratorio de Investigación Social Abierta [LISA](lisa-coes.cl) del Centro de Estudios de Conflicto y Cohesión Social [COES](coes.cl). Te escribo para compartir un estudio que busca conocer y mejorar el estado de la investigación en ciencias sociales en Chile.

Estamos llevando a cabo una encuesta sobre Ciencia Abierta dirigida a académicos, académicas e investigadores de ciencias sociales en Chile, y tu opinión es fundamental. La Ciencia Abierta es un tema crucial en la investigación contemporánea, y tu participación es clave para mejorar la calidad y transparencia de nuestras investigaciones.

¿Te gustaría participar? Solo te tomará unos minutos completar la encuesta, la cual puedes encontrar en el siguiente enlace: https://lisa-survey.formr.org/. Además, ¡te animamos a compartir este enlace con tus colegas y redes!

Tu participación y colaboración en este proyecto son muy valiosas. Los resultados de esta encuesta no solo beneficiarán a la comunidad académica, sino que también contribuirán al avance y mejora continua de la investigación en ciencias sociales.

Si tienes alguna pregunta o inquietud, no dudes en ponerte en contacto con nosotros.

¡Gracias por tu tiempo y apoyo! Esperamos contar con tu participación en este gran proyecto.

Atentamente,

<div style="line-height:30%;">
Juan Carlos Castillo

Profesor Asociado - Departamento de Sociología

Director de Investigación y Publicaciones, Facultad de Ciencias Sociales

Universidad de Chile

Investigador Principal COES

Coordinador LISA 

juancastillov@uchile.cl | jc-castillo.com</div> 
      
    ')))
  
  # Personalizar el nombre del destinatario en el cuerpo del correo
  etiqueta_nombre <- "{nombre}"  # Etiqueta a reemplazar
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
pmap(list(destinatarios$nombre, destinatarios$correo), enviar_correo)
