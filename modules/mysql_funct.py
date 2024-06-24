import mysql.connector

host = "localhost"
user = "root"

# creacion de BBDD
def create_database(database, password,host=host, user=user):
    db = mysql.connector.connect(host     = host,
                                 user     = user,
                                 password = password,
                                 database = None)

    cursor = db.cursor()
    cursor.execute(f"CREATE DATABASE IF NOT EXISTS {database};")
    cursor.close()
    db.close()

# query general
def execute_query(query, database, password, host=host, user=user):
    db = mysql.connector.connect(host     = host,
                                 user     = user,
                                 password = password,
                                 database = database) # llama database
    cursor = db.cursor()
    cursor.execute(query) # ejecuta query
    cursor.fetchall()
    cursor.close()
    db.close()

# seleccion de tabla
def select_from_table(query, database, password, host=host, user=user):

    db = mysql.connector.connect(host     = host,
                                 user     = user,
                                 password = password,
                                 database = database)
    cursor = db.cursor()
    cursor.execute(query) # Ejecutamos la query de SELECCION (visualiza lo seleccionado)
    column_names = cursor.column_names # Nombre de las columnas de la tabla

    data = cursor.fetchall()
    cursor.close()
    db.close()
    
    # se pueden guardar en una variable pd.DataFrame(data, columns=column_names)
    return data, column_names

# popular tablas
def insert_to_table(data, table, database, in_from, password, host=host, user=user):
    
    db = mysql.connector.connect(host     = host,
                                 user     = user,
                                 password = password,
                                 database = database)
    cursor = db.cursor()

    cursor.execute(f"SELECT * FROM {table} LIMIT 0;") # tabla y columnas, LIMIT 0 es para no seleccionar datos
    # FIXED: now allows any starting column index as parameter
    # column_names = cursor.column_names[1:] DEPRECATED
    column_names = cursor.column_names[in_from:] # inserta datos desde n columna
    cursor.fetchall()

    # en la query, los valores a insertar son separados por comas
    insert_query = f"INSERT INTO {table} ({', '.join(column_names)}) VALUES ({', '.join(['%s' for _ in column_names])})"
    # FIXED insert_to_table function: change tuple(row) for tuple(list comprehension) in order to accept None as null (missing values) in value
    # values = [tuple(row) for row in df_sales_c.values] DEPRECATED
    # se toman los valores del dataframe, permite valores nulos si el valor faltante es "" (str vacia)
    values = [tuple(None if row[i]=="" else row[i] for i in range(len(row))) for row in data.values]

    # .executemany ejecuta el query de INSERT INTO con cada uno de los elementos de "values"
    cursor.executemany(insert_query, values)
    
    # Guarda los resultados
    db.commit()

    print(f"Añadidas: {cursor.rowcount} filas")
    cursor.fetchall()
    cursor.close()
    db.close()