# Creación docker compose

Para crear el docker compose vamos a necesitar primero un fichero que se llame docker-compose.yml en el cual tendremos que indicarle la versión y los servicios que nos va a ofrecer, ademas del mapeado de puertos y la asignación de IPs para los servicios; en este caso hemos creado un DNS con bind9 y un cliente para conectarnos con la imagen de alpine, tambien tendremos que asignar los volumenes al servicio de bind 9 y este sería el resultado de dicho fichero:

~~~ 
version: "3.9" 
services:
  asir_cliente: 
    container_name: asir_cliente
    image: alpine
    networks:
      - bind9_subnet
    stdin_open: true
    tty: true
    dns:
      - 10.1.0.254
  bind9:
    container_name: asir2_bind9
    image: internetsystemsconsortium/bind9:9.16
    ports:
      - 5300:53/udp
      - 5300:53/tcp
    networks:
      bind9_subnet:
        ipv4_address: 10.1.0.254
    volumes:
      - /home/asir2a/Documentos/dns/confg:/etc/bind
      - /home/asir2a/Documentos/dns/zonas:/var/lib/bind
networks:
  bind9_subnet:
    external: true   

~~~

# Creación de volumenes

tenemos que crear los volumenes en el mismo directorio que el docker-compose en el cual crearemos el directorio _confg_ y otro que se llame _zonas_

## directorio confg 

Dentro deberemos tener 3 archivos uno llamado _named.conf_ donde en el interior se hará referencia a los dos archivos a continuación

~~~
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
~~~

### fichero named.conf.options

Tendremos que crear el fichero _named.conf.options_  en el cual tendremos un código parecido a este segun las opciones que neceitemos

~~~ 
options {
        directory "/var/cache/bind";

        forwarders {
            8.8.8.8;
            8.8.4.4;
        };
        forward only;

        listen-on { any; };
        listen-on-v6 { any; };
        allow-query {
            any;
        };

        allow-recursion {
                none;
        };
        allow-transfer {
                none;
        };
        allow-update {
                none;
        };
};
~~~
### fichero named.conf.local

Tendremos que crear el fichero _named.conf.local_  en el cual tendremos un código parecido a este donde haremos referencia a la zona

~~~
zone "asircastelao.com." {
        type master;
        file "/var/lib/bind/db.asircastelao.com";
        notify explicit;
        allow-query {
            any;
        };
};

~~~

Estos serian los archivos del directorio confg

## Directorio zonas

En el directorio zonas solo crearemos un archivo que será el nombre de la zona en este caso _db.asircastelao.com_ en el cual habrá el siguiente código

~~~
$TTL    36000
@       IN      SOA     ns.asircastelao.com. joel.danielcastelao.org. (
                     06102022           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS     ns.asircastelao.com.
ns      IN      A      10.1.0.254
test    IN      A      10.1.0.21  
alias   IN      CNAME  test      

~~~

Con esto tendremos nuestro Docker-compose listo para funcionar.