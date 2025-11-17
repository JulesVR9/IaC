from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend  # Importa el backend criptográfico por defecto
from os import urandom  # urandom genera bytes aleatorios seguros para claves/IV

# --- Generación de clave e IV ---
def generar_clave_y_iv():
    """
    Generar una clave AES de 256 bits (32 bytes) y un IV de 128 bits (16 bytes).
    Devuelve una tupla (key, iv) donde ambos son objetos bytes.
    """
    # key: clave usada para cifrar/descifrar. 32 bytes = 256 bits (AES-256).
    key = urandom(32)

    # iv: 'initialization vector' — vector de inicialización necesario para modos como CBC.
    # Debe ser impredecible y único por cada cifrado.
    iv = urandom(16)

    # Devolver clave e IV para usarlos más adelante.
    return key, iv


# --- Función para encriptar ---
def encriptar(texto_plano, key, iv):
    """
    Encripta 'texto_plano' usando AES-256 en modo CBC con la clave 'key' y el IV 'iv'.
    - texto_plano: str
    - key, iv: bytes
    Devuelve bytes con el texto cifrado.
    """
    # Crear el objeto Cipher con algoritmo AES y modo CBC usando el backend por defecto.
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())

    # Obtener el encriptador del objeto Cipher.
    encryptor = cipher.encryptor()

    # Convertir el texto plano (str) a bytes UTF-8 para poder cifrarlo.
    texto_plano_bytes = texto_plano.encode('utf-8')

    # AES-CBC requiere que los bloques sean de longitud múltiplo de 16 bytes.
    # Calculamos la longitud del padding necesario (PKCS#7-style simple).
    padding_length = 16 - (len(texto_plano_bytes) % 16)

    # Construir el padding: un byte repetido 'padding_length' veces.
    # Ejemplo: si padding_length es 5 -> b'\x05\x05\x05\x05\x05'
    padding = bytes([padding_length]) * padding_length

    # Concatenar el padding al texto para obtener un tamaño múltiplo de 16.
    texto_a_cifrar = texto_plano_bytes + padding

    # Encriptar los bytes padded: update() procesa los datos, finalize() completa el cifrado.
    texto_cifrado = encryptor.update(texto_a_cifrar) + encryptor.finalize()

    # Devolver los bytes cifrados.
    return texto_cifrado


# --- Función para desencriptar ---
def desencriptar(texto_cifrado, key, iv):
    """
    Desencripta 'texto_cifrado' usando AES-256-CBC con 'key' y 'iv'.
    Devuelve el texto plano original como str (UTF-8).
    """
    # Crear el objeto Cipher con las mismas propiedades que en encriptar.
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())

    # Obtener el desencriptador.
    decryptor = cipher.decryptor()

    # Desencriptar los bytes: update() + finalize().
    texto_desencriptado_con_padding = decryptor.update(texto_cifrado) + decryptor.finalize()

    # El último byte indica la longitud del padding (mismo esquema que al encriptar).
    padding_length = texto_desencriptado_con_padding[-1]

    # Quitar el padding del final: todo excepto los últimos 'padding_length' bytes.
    texto_desencriptado = texto_desencriptado_con_padding[:-padding_length]

    # Convertir de bytes a str usando UTF-8 y devolver.
    return texto_desencriptado.decode('utf-8')


# --- USO / EJEMPLO ---
if __name__ == "__main__":
    # 1) Generar clave e IV (en un uso real, NO deberías dejar la clave en el código ni subirla al repositorio).
    key, iv = generar_clave_y_iv()

    # 2) Texto original (lo solicitaste: "Julia del Carmen Vallejo Rodriguez")
    texto_original = "Julia del Carmen Vallejo Rodriguez"

    # 3) Encriptar el texto
    texto_encriptado = encriptar(texto_original, key, iv)
    # Imprimimos los bytes cifrados. Nota: pueden contener bytes no imprimibles.
    print(f"Texto encriptado (bytes): {texto_encriptado}")

    # 4) Desencriptar y verificar que volvemos al texto original
    texto_desencriptado = desencriptar(texto_encriptado, key, iv)
    print(f"Texto desencriptado: {texto_desencriptado}")
