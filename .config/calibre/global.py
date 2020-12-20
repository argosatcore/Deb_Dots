# calibre wide preferences

### Begin group: DEFAULT
 
# database path
# Ruta de la base de datos en la que se almacenan los libros
database_path = '/home/carlos/library1.db'
 
# filename pattern
# Patrón para extraer metadatos de los nombres de archivo
filename_pattern = u'(?P<title>.+) - (?P<author>[^_]+)'
 
# isbndb com key
# Clave de acceso a isbndb.com
isbndb_com_key = ''
 
# network timeout
# Tiempo de espera predeterminado para operaciones de red (segundos)
network_timeout = 5
 
# library path
# Ruta al directorio en el que está almacenada la biblioteca de libros
library_path = '/home/carlos/Calibre Library'
 
# language
# El idioma en que se muestra la interfaz de usuario
language = 'es'
 
# output format
# El formato de salida predeterminado de las conversiones de libros electrónicos.
output_format = 'EPUB'
 
# input format order
# Lista por orden de preferencia de formatos de entrada.
input_format_order = cPickle.loads('\x80\x02]q\x01(U\x04EPUBq\x02U\x04AZW3q\x03U\x04MOBIq\x04U\x03LITq\x05U\x03PRCq\x06U\x03FB2q\x07U\x04HTMLq\x08U\x03HTMq\tU\x04XHTMq\nU\x05SHTMLq\x0bU\x05XHTMLq\x0cU\x03ZIPq\rU\x04DOCXq\x0eU\x03ODTq\x0fU\x03RTFq\x10U\x03PDFq\x11U\x03TXTq\x12e.')
 
# read file metadata
# Leer metadatos desde los archivos
read_file_metadata = True
 
# worker process priority
# La prioridad de los procesos en ejecución. Una prioridad más alta significa que se ejecutan más rápidamente y consumen más recursos. La mayoría de las tareas, como la conversión, descarga de noticias, adición de libros, etc., se ven afectadas por esta configuración.
worker_process_priority = 'normal'
 
# swap author names
# Intercambiar el nombre y el apellido del autor al leer los metadatos
swap_author_names = False
 
# add formats to existing
# Añadir nuevos formatos a los registros de libros existentes
add_formats_to_existing = False
 
# check for dupes on ctl
# Buscar duplicados al copiar a otra biblioteca
check_for_dupes_on_ctl = False
 
# installation uuid
# Installation UUID
installation_uuid = '8b79cbb9-f8d1-497b-95bf-1e5f2cee0407'
 
# new book tags
# Etiquetas que se aplicarán a los libros que se añadan a la biblioteca
new_book_tags = cPickle.loads('\x80\x02]q\x01.')
 
# mark new books
# Marcar los libros recién añadidos. La marca es temporal y se elimina automáticamente al reiniciar calibre.
mark_new_books = False
 
# saved searches
# Lista de búsquedas guardadas con nombre
saved_searches = cPickle.loads('\x80\x02}q\x01.')
 
# user categories
# Categorías del explorador de etiquetas creadas por el usuario
user_categories = cPickle.loads('\x80\x02}q\x01.')
 
# manage device metadata
# Cómo y cuándo actualiza calibre los metadatos en el dispositivo.
manage_device_metadata = 'manual'
 
# limit search columns
# Cuando se busque texto sin usar prefijos, como «Rojo» en lugar de «title:Rojo», limitar las columnas buscadas a las que se enumeran abajo.
limit_search_columns = False
 
# limit search columns to
# Elija las columnas en las que buscar cuando no se usen prefijos, como cuando se busca «Rojo» en lugar de «title:Rojo». Introduzca una lista de nombres de búsqueda separados por comas. Sólo tiene efecto si activa la opción para limitar las columnas de búsqueda más arriba.
limit_search_columns_to = cPickle.loads('\x80\x02]q\x01(U\x05titleq\x02U\x07authorsq\x03U\x04tagsq\x04U\x06seriesq\x05U\tpublisherq\x06e.')
 
# use primary find in search
# Los caracteres introducidos en el cuadro de búsqueda encontrarán también las versiones acentuadas, según el idioma que haya elegido para la interfaz de calibre. Por ejemplo, en inglés, al buscar «n» se encontrará tanto «ñ» como «n», pero en español sólo se encontrará «n». Tenga en cuenta que esto hace que las búsquedas sean mucho más lentas en bibliotecas muy grandes. Además esta opción no tiene efecto si activa la distinción de mayúsculas y minúsculas en las búsquedas
use_primary_find_in_search = True
 
# case sensitive
# Distinguir mayúsculas y minúsculas en las búsquedas
case_sensitive = False
 
# migrated
# For Internal use. Don't modify.
migrated = False
 


