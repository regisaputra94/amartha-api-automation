from sshtunnel import SSHTunnelForwarder
import pymysql
import mysql.connector

class dbLibrary:
    def __init__(self):
        self.tunnel = None
        self.connection = None

    def open_ssh_tunnel(self, ssh_host, ssh_port, ssh_user, ssh_pkey, sql_host, sql_port):
        """Opens an SSH tunnel for MySQL connection"""

        ssh_port = int(ssh_port)  # Convert port to integer
        sql_port = int(sql_port)  # Convert port to integer
        
        self.tunnel = SSHTunnelForwarder(
            ssh_address_or_host=(ssh_host, ssh_port),
            ssh_username=ssh_user,
            ssh_pkey=ssh_pkey,
            remote_bind_address=(sql_host, sql_port),
            local_bind_address=('127.0.0.1', 0)  # Use 0 for auto-assign port
        )
        self.tunnel.start()
        print(f"SSH Tunnel established on local port {self.tunnel.local_bind_port}")

    def mysql_connect(self, sql_username, sql_password, sql_database):
        """Connects to MySQL database through SSH tunnel"""
        if not self.tunnel:
            raise Exception("SSH Tunnel is not open!")

        self.connection = pymysql.connect(
            host='127.0.0.1',
            port=self.tunnel.local_bind_port,
            user=sql_username,
            password=sql_password,
            database=sql_database
        )
        print("MySQL Connection Established")

    def execute_query(self, query):
        """Executes a SQL query and returns the result"""
        if not self.connection:
            raise Exception("Database connection is not open!")
        
        with self.connection.cursor() as cursor:
            cursor.execute(query)
            if query.strip().lower().startswith("select"):
                return cursor.fetchall()
            else:
                self.connection.commit()
                return None

    def close_mysql_connection(self):
        """Closes MySQL connection"""
        if self.connection:
            self.connection.close()
            print("MySQL Connection Closed")

    def close_ssh_tunnel(self):
        """Closes SSH tunnel"""
        if self.tunnel:
            self.tunnel.stop()
            print("SSH Tunnel Closed")

    def connect_fast_forward(self):
        host = '127.0.0.1'
        port = 3306
        user = "mtix_dev"
        password = "mtix_dev@21"
        database = "mtix_payment"

        try:
            connection = mysql.connector.connect(
                host=host,
                port=port,
                user=user,
                password=password,
                database=database
            )

            if (connection.is_connected):
                print("Connected")

        except mysql.connector.Error as e:
            print("Error", e)
