# preferences for the calibre GUI

### Begin group: DEFAULT
 
# send to storage card by default
# Enviar archivo a tarjeta de almacenamiento en vez de a memoria principal
send_to_storage_card_by_default = False
 
# confirm delete
# Confirmar antes de borrar
confirm_delete = False
 
# main window geometry
# Geometría de la ventana principal
main_window_geometry = cPickle.loads('\x80\x02csip\n_unpickle_type\nq\x01U\x0cPyQt5.QtCoreq\x02U\nQByteArrayU2\x01\xd9\xd0\xcb\x00\x02\x00\x00\x00\x00\x00\n\x00\x00\x00\x1e\x00\x00\x05K\x00\x00\x02\xf5\x00\x00\x00\x0b\x00\x00\x00\x1f\x00\x00\x05J\x00\x00\x02\xf4\x00\x00\x00\x00\x00\x00\x00\x00\x05V\x85\x87Rq\x03.')
 
# new version notification
# Notificar cuando haya una nueva versión disponible
new_version_notification = True
 
# use roman numerals for series number
# Usar números romanos para los números de series
use_roman_numerals_for_series_number = True
 
# sort tags by
# Ordenar la lista de etiquetas por nombre, popularidad o calificación
sort_tags_by = 'name'
 
# match tags type
# Buscar un término o todos en las etiquetas
match_tags_type = 'any'
 
# cover flow queue length
# Numero de portadas de libros que se mostrarán en el modo de exploración por portadas
cover_flow_queue_length = 6
 
# LRF conversion defaults
# Opciones predeterminadas para la conversión a LRF
LRF_conversion_defaults = cPickle.loads('\x80\x02]q\x01.')
 
# LRF ebook viewer options
# Opciones para el visor de libros LRF
LRF_ebook_viewer_options = None
 
# internally viewed formats
# Formatos que se visualizan usando el visor interno
internally_viewed_formats = cPickle.loads('\x80\x02]q\x01(U\x03LRFq\x02U\x04EPUBq\x03U\x03LITq\x04U\x04MOBIq\x05U\x03PRCq\x06U\x04POBIq\x07U\x03AZWq\x08U\x04AZW3q\tU\x04HTMLq\nU\x03FB2q\x0bU\x03PDBq\x0cU\x02RBq\rU\x03SNBq\x0eU\x05HTMLZq\x0fU\x05KEPUBq\x10e.')
 
# column map
# Columnas a ser mostradas en la lista de libros
column_map = cPickle.loads('\x80\x02]q\x01(U\x05titleq\x02U\x08ondeviceq\x03U\x07authorsq\x04U\x04sizeq\x05U\ttimestampq\x06U\x06ratingq\x07U\tpublisherq\x08U\x04tagsq\tU\x06seriesq\nU\x07pubdateq\x0be.')
 
# autolaunch server
# Ejecutar automáticamente el servidor de contenido al iniciar la aplicación
autolaunch_server = False
 
# oldest news
# Noticias más antiguas mantenidas en la base de datos
oldest_news = 60
 
# systray icon
# Mostrar icono en el área de notificación del sistema
systray_icon = False
 
# upload news to device
# Enviar las noticias descargadas al dispositivo
upload_news_to_device = True
 
# delete news from library on upload
# Borrar los libros nuevos de la biblioteca después de enviarlos al dispositivo
delete_news_from_library_on_upload = False
 
# separate cover flow
# Mostrar el explorador de portadas en una ventana separada en vez de la ventana principal de calibre
separate_cover_flow = False
 
# disable tray notification
# Desactivar las notificaciones del icono de la bandeja del sistema
disable_tray_notification = False
 
# default send to device action
# Acción predeterminada que se ejecutará cuando se pulse el botón de «Enviar al dispositivo»
default_send_to_device_action = 'DeviceAction:main::False:False'
 
# asked library thing password
# Asked library thing password at least once.
asked_library_thing_password = False
 
# search as you type
# Ir buscando según se teclea. Si se desactiva esta opción, la búsqueda sólo tendrá lugar cuando se pulse la tecla Intro.
search_as_you_type = False
 
# highlight search matches
# Al buscar, mostrar todos los libros, resaltando los resultados de la búsqueda, en lugar de mostrar sólo las coincidencias. Puede pulsar la tecla N o la tecla F3 para ir al siguiente resultado.
highlight_search_matches = False
 
# save to disk template history
# Previously used Save to Disk templates
save_to_disk_template_history = cPickle.loads('\x80\x02]q\x01.')
 
# send to device template history
# Previously used Send to Device templates
send_to_device_template_history = cPickle.loads('\x80\x02]q\x01.')
 
# main search history
# Search history for the main GUI
main_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# viewer search history
# Search history for the e-book viewer
viewer_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# viewer toc search history
# Search history for the ToC in the e-book viewer
viewer_toc_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# lrf viewer search history
# Search history for the LRF viewer
lrf_viewer_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# scheduler search history
# Search history for the recipe scheduler
scheduler_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# plugin search history
# Search history for the plugin preferences
plugin_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# shortcuts search history
# Search history for the keyboard preferences
shortcuts_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# jobs search history
# Search history for the tweaks preferences
jobs_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# tweaks search history
# Search history for tweaks
tweaks_search_history = cPickle.loads('\x80\x02]q\x01.')
 
# worker limit
# Número máximo de tareas de conversión o descarga simultáneas. Este número es el doble del valor real por razones históricas.
worker_limit = 6
 
# get social metadata
# Descargar metadatos sociales (etiquetas/valoración/etc.)
get_social_metadata = True
 
# overwrite author title metadata
# Reemplazar el autor y el título con nuevos metadatos
overwrite_author_title_metadata = True
 
# auto download cover
# Descargar automáticamente la portada, si estuviera disponible
auto_download_cover = False
 
# enforce cpu limit
# Limitar el número máximo de tareas simultáneas al número de CPUs
enforce_cpu_limit = True
 
# gui layout
# El diseño de la interfaz de usuario. El diseño ancho tiene el panel de detalles del libro a la derecha, el estrecho lo tiene debajo.
gui_layout = 'wide'
 
# show avg rating
# Mostrar la calificación promedio de cada elemento en el explorador de etiquetas
show_avg_rating = True
 
# disable animations
# Desactivar animaciones de la interfaz
disable_animations = False
 
# tag browser hidden categories
# Categorías del explorador de etiquetas que no se mostrarán
tag_browser_hidden_categories = cPickle.loads('\x80\x02c__builtin__\nset\nq\x01]\x85Rq\x02.')
 


