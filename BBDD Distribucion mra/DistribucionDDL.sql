DROP TABLE PEDIDOS18;
DROP TABLE CLIENTES18;
DROP TABLE PRODUCTOS18;
DROP TABLE EMPLEADOS18;

CREATE TABLE EMPLEADOS18 (
    COD_EMPLEADO	INT             PRIMARY KEY,
    APELLIDO            VARCHAR2(40)    NOT NULL,
    OFICIO              VARCHAR2(40)    NOT NULL,
    DIRECTOR            INT,
    FECHA_ALTA          DATE            NOT NULL,
    SALARIO             INT,
    COMISION            INT,
    COD_DEPARTAMENTO    INT             NOT NULL
);

CREATE TABLE CLIENTES18 (
    CLIENTES18	        INT             PRIMARY KEY,
    NOMBRE              VARCHAR2(40)    NOT NULL,
    LOCALIDAD           VARCHAR2(40)    NOT NULL,
    COD_VENDEDOR        INT             NOT NULL,
    DEBE                INT             NOT NULL,
    LIMITE_CREDITO      INT             NOT NULL
);

CREATE TABLE PRODUCTOS18 (
    COD_PRODUCTO	INT             PRIMARY KEY,
    DESCRIPCION         VARCHAR2(50)    NOT NULL,
    PRECIO_ACTUAL       INT,
    STOCK_DISPONIBLE    INT             NOT NULL
);

CREATE TABLE PEDIDOS18 (
    cod_PEDIDO 	        INT             PRIMARY KEY,
    COD_PRODUCTO	INT,
    CLIENTES18         INT,
    UNIDADES            INT             NOT NULL,
    FECHA_PEDIDO        DATE            NOT NULL   
);


ALTER TABLE EMPLEADOS18   ADD CONSTRAINT FK_EMPLEADOS18_EMPLEADOS18       FOREIGN KEY (DIRECTOR)          REFERENCES EMPLEADOS18 (COD_EMPLEADO);
ALTER TABLE EMPLEADOS18   ADD CONSTRAINT FK_EMPLEADOS18_DEPARTAMENTOS   FOREIGN KEY (COD_DEPARTAMENTO)  REFERENCES DEPARTAMENTOS18 (COD_DEPARTAMENTO);
ALTER TABLE CLIENTES18    ADD CONSTRAINT FK_CLIENTES18_EMPLEADOS18        FOREIGN KEY (COD_VENDEDOR)      REFERENCES EMPLEADOS18 (COD_EMPLEADO);
	
ALTER TABLE PEDIDOS18	ADD CONSTRAINT FK_PEDIDOS18_CLIENTES18    	    FOREIGN KEY (CLIENTES18)       REFERENCES CLIENTES18 (CLIENTES18);
ALTER TABLE PEDIDOS18	ADD CONSTRAINT FK_PEDIDOS18_PRODUCTOS18         FOREIGN KEY (COD_PRODUCTO)      REFERENCES PRODUCTOS18 (COD_PRODUCTO);

COMMIT WORK;
  