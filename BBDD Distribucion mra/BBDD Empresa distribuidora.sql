--SET LINESIZE 500;
--SET PAGESIZE 500;

/*Base de datos de una distribuidora
Uno de nuestros CLIENTES18 se dedica a la distribución de distintos PRODUCTOS18 y nos ha pedido la
creación de una base de datos, la carga de datos. Para ello, sigue las siguientes instrucciones:
*/
ALTER SESSION SET "_ORACLE_SCRIPT" =TRUE;
/*Crea el usuario “distribucion” con contraseña “distribución” y una cuota de 5 Megabytes en 
el tablespace “USERS”.*/

CREATE USER distribucion18 IDENTIFIED BY distribucion18 QUOTA 5M ON USERS; 
/*Concédele permiso de acceso y utilización de los recursos. */
GRANT ALL PRIVILEGES TO distribucion18;
/*Conéctate al usuario “distribucion” desde SQLPLUS.*/
DISCONNECT
CONNECT
--Introduzca el nombre de usuario: distribucion
--Introduzca la contrase±a:distribucion
--Conectado.
/*4. Crea la tabla “departamentos” con la siguiente especificacion*/
DROP TABLE departamentos18 CASCADE CONSTRAINTS;
CREATE TABLE departamentos18(
COD_DEPARTAMENTO INT PRIMARY KEY,
NOMBRE VARCHAR2(40) NOT NULL,
LOCALIDAD VARCHAR2(40) NOT NULL
);
/*5. Inserta los siguientes datos en la tabla departamentos*/
INSERT INTO departamentos18 VALUES (10,'CONTABILIDAD','BARCELONA');
INSERT INTO departamentos18 VALUES (20,'INVESTIGACION','VALENCIA');
INSERT INTO departamentos18 VALUES (30,'VENTAS','MADRID');
INSERT INTO departamentos18 VALUES (40,'PRODUCCION','SEVILLA');
INSERT INTO departamentos18 VALUES (50,'INFORMATICA','MADRID');
/*6. Carga el script DDL, el cual crea el resto de tablas necesarias del esquema
(DistribucionDDL.sql).*/
START "C:\Users\DAW_T\Documents\BDD\BBDD Distribucion\DistribucionDDL.sql"
/*7. Carga el script DML, el cual inserta los datos de la base de datos en las tablas
correspondientes (DistribucionDML.sql).*/
START "C:\Users\DAW_T\Documents\BDD\BBDD Distribucion\DistribucionDML.sql"

/*
A continuación, la empresa cliente necesita algunos informes sobre su base de datos, los 
cuales vamos a proceder a realizar mediante consultas (para ello usaremos SQL DEVELOPER). 
Concretamente necesitamos:
*/

/*1. Un listado que contenga el código de cliente y nombre de todos los clientes que no se 
encuentren en ‘BARCELONA’, ordenados por nombre, alfabéticamente.*/
SELECT CLIENTES18, NOMBRE
FROM CLIENTES18
WHERE LOCALIDAD != 'BARCELONA'
ORDER BY NOMBRE ASC;--AUNQ SE SUPONE Q POR DEFECTO ESTA YA ORDENADO DE FORMA ASCENDENTE Y alfabéticamente

/*2. Un listado que contenga el nombre de los departamentos que se encuentran en la siguiente 
lista (se deben utilizar listas) de ciudades: Madrid, Barcelona*/
SELECT NOMBRE 
FROM departamentos18 
WHERE LOCALIDAD IN ('MADRID', 'BARCELONA');

/*3. El salario más bajo, el más alto y la media de la tabla de empleado*/
SELECT MIN(SALARIO), MAX(SALARIO), AVG(SALARIO)
FROM EMPLEADOS18;
/*4. Un listado de productos (descripción, stock, precio) ordenados por stock de forma 
descendente y por precio de forma descendente y alfabéticamente de forma ascendente.
*/
SELECT DESCRIPCION, STOCK_DISPONIBLE, PRECIO_ACTUAL
FROM PRODUCTOS18
ORDER BY STOCK_DISPONIBLE DESC, PRECIO_ACTUAL DESC, DESCRIPCION ASC;
/*5. Un listado de apellidos y fechas de alta de vendedores que no cobren comisiones*/
SELECT APELLIDO, FECHA_ALTA
	FROM EMPLEADOS18
	WHERE COMISION IS NULL
	OR COMISION = 0;
/*6. Un listado que contenga código de producto, descripción y stock de mesas con un stock
comprendido entre 10 y 20 unidades.*/
SELECT COD_PRODUCTO, DESCRIPCION, STOCK_DISPONIBLE
	FROM PRODUCTOS18
	WHERE DESCRIPCION LIKE UPPER('mesa%')
	AND STOCK_DISPONIBLE >= 10
	AND STOCK_DISPONIBLE <= 20;
/*7. Un listado que contenga los nombres y localidades de los clientes que alguna vez han sido 
atendidos por un director*/

---------------------------------------
SELECT APELLIDO, LOCALIDAD,COD_EMPLEADO
	FROM EMPLEADOS18, CLIENTES18
	WHERE COD_VENDEDOR = COD_EMPLEADO
	AND OFICIO LIKE UPPER('director');
---------------------------------------

	--ninguna fila seleccionada -------> PUEDE SER Q NIGUN CLIENTE HAYA SIDO ATENDIDO POR UN DIRECTOR ?
	
/*8. Listado con el nombre iy localidad de los clientes que tienen pedidos con menos de 3
unidades en el mes de noviembre de 1999*/

SELECT NOMBRE, LOCALIDAD
	FROM CLIENTES18, PEDIDOS18
	WHERE CLIENTES18.CLIENTES18 = PEDIDOS18.CLIENTE18
	AND UNIDADES < 3;
	--NO FUNCIONA, ERROR CON LA IDENTIFICACION DE "CLIENTES18"
	--LA FECHAS NO VAN ?¿
	
/*9. Listado con el nombre y localidad de cliente, nombre de departamento, y apellido del
empleado que le atendió para todos aquellos clientes que fueron atendidos por un empleado
perteneciente a algún departamento de Madrid. El resultado debe mostrarse ordenado por
orden alfabético del apellido del empleado y en caso de empate, por el del nombre de
cliente, también alfabéticamente.*/

--he utilizado (NombreTabla.Campo) porq me daba un error ORA-00918: columna definida de forma ambigua, con esto ya se soluciona.
SELECT CLIENTES18.NOMBRE, departamentos18.LOCALIDAD, departamentos18.NOMBRE, EMPLEADOS18.APELLIDO
	FROM CLIENTES18, departamentos18, EMPLEADOS18
	WHERE COD_VENDEDOR = COD_EMPLEADO
	AND EMPLEADOS18.COD_DEPARTAMENTO = departamentos18.COD_DEPARTAMENTO
	AND EMPLEADOS18.COD_DEPARTAMENTO = (SELECT departamentos18.COD_DEPARTAMENTO	--sub consulta para que solo aparezcan los departamento de ventas de madrid 
												FROM departamentos18
												WHERE departamentos18.LOCALIDAD = 'MADRID'
												AND NOMBRE = 'VENTAS')
	ORDER BY EMPLEADOS18.APELLIDO ASC, CLIENTES18.NOMBRE ASC; --no hace falta porner order by porq ya se ordena alfabéticamente de froma ascendente, pero lo pongo para q se sepa


/*10. Un listado con el nombre y localidad del cliente, apellido y nombre de departamento del 
empleado que le atendió, descripción del producto que compró y fecha del pedido, de todos 
aquellos clientes que compraron una “…SILLA DIRECTOR…” en el mes de noviembre de 
1999 ordenando los resultados ascendentemente por fecha de pedido.*/

--lo de la fecha no va muy bien 

SELECT CLIENTES18.NOMBRE, CLIENTES18.LOCALIDAD, EMPLEADOS18.APELLIDO, departamentos18.NOMBRE, PRODUCTOS18.DESCRIPCION, PEDIDOS18.FECHA_PEDIDO
	FROM CLIENTES18, departamentos18, EMPLEADOS18, PEDIDOS18, PRODUCTOS18
	WHERE CLIENTES18.COD_VENDEDOR = EMPLEADOS18.COD_EMPLEADO
	AND EMPLEADOS18.COD_DEPARTAMENTO = departamentos18.COD_DEPARTAMENTO
	AND PEDIDOS18.CLIENTES18 = CLIENTES18.CLIENTES18
	AND PRODUCTOS18.COD_PRODUCTO = PEDIDOS18.COD_PRODUCTO
	AND PRODUCTOS18.DESCRIPCION LIKE UPPER('%SILLA DIRECTOR%');
	
/*Por último, el cliente nos informa de que va a necesitar algunos informes estadísticos para 
los que vamos a necesitar algunas sentencias más complejas. En concreto necesitamos*/

/*11. Un listado con el nombre de la localidad y la suma del crédito que tienen sus clientes, 
agrupado por localidad.*/

SELECT LOCALIDAD, SUM(LIMITE_CREDITO) as suma_del_credito -- "as" es para dar nombre a la columna creada de la suma
FROM CLIENTES18
GROUP BY LOCALIDAD;

/*12. Un listado que muestre nombre del departamento, oficio y media salarial, agrupado por 
departamento y oficio, que tengan asignado un salario superior a 200000 €, todo ello 
ordenado descendentemente por la media salarial.*/
SELECT NOMBRE, OFICIO, AVG(SALARIO) as salario_medio
FROM EMPLEADOS18, departamentos18
WHERE SALARIO > 200000 AND departamentos18.COD_DEPARTAMENTO = EMPLEADOS18.COD_DEPARTAMENTO
GROUP BY NOMBRE, OFICIO
ORDER BY salario_medio DESC;

/*13. Un listado que muestre los códigos de cliente y nombres de los clientes cuya suma total de 
los pedidos (también hay que mostrarla) que han realizado sea mayor que 8.000.000€, 
ordenado ascendentemente por número de código de cliente.*/


/*14. Un listado de los departamentos, su ciudad y su número de empleados, cuyo departamento 
tenga más de 2 empleados, ordenado por número de empleados ascendentemente.*/

/*15. Un listado de los nombres de departamento y el mínimo salario de los departamentos en los 
que todos sus empleados cobren más de 135.000€, ordenado por salario minimo 
descendentemente y por nombre de departamento ascendentemente*/