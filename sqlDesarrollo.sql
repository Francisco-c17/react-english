--Crear una DB
Create database Empresa
on Primary 
(name=EmpresaPrimary, filename='C:\Data\Empresa.mdf', size=50MB, filegrowth=25%)
log on
(name=EmpresaLog, filename='C:\Data\EmpresaLog.ldf', size=25MB, filegrowth=25%)
GO

Alter Database Empresa
add filegroup Produccion
GO

Alter database Empresa
add file
(name=EmpresaProduccion, filename='C:\Data\EmpresaProduccion.ndf', size=50MB, filegrowth=25%)
to filegroup Produccion
GO

--Alter database Empresa
--modify filegroup [Produccion] default
--GO

Use Empresa 
GO

--Crear tabla
Create Table cliente(
codigocliente int identity(1,1) not null primary key,
nombre char(150) null, --unique
direccion char(300) not null,
telefono char(20),-- default ('733-141-366')
email char(40),
fechadenacimiento date
)
GO

Select * from cliente

--Agregar columna
alter table cliente
add categoria int not null
Go

--Eliminar tabla
Drop table cliente
GO

--Conversion de datos
--ast, convert, Parse, try_cast, try_convert, try_parse,

Create Table cliente(
codigocliente int identity(1,1) not null primary key,
nombre char(150) null, --unique
direccion char(300) not null,
telefono char(20) default ('733-141-366'),
email char(40),
edad int,
constraint ck_edad check(edad>=18)
)
GO

insert into cliente(nombre, direccion, email, edad) values
--('jose Francisco','Iguala de la Independencia', 'francisco-c@hotmail.com',12) ERROR
('jose Francisco','Iguala de la Independencia', 'francisco-c@hotmail.com',25)

select * from cliente

--***Esquemas dbo por default
--Crear un login
use master
go
create login UserFrancisco with password = 'P@ssword'

--Crear un user para el login
use Empresa
create user UserFrancisco for login UserFrancisco
with default_schema = Informatica
go

--Crear el esquema asociado al user
use Empresa
go
create schema Curso authorization Userfrancisco
go
create schema Informatica authorization Userfrancisco
go

--Dar permiso de creacion de tabla al user
grant create table to UserFrancisco
go

--Revisar usuario actual
select user

execute as user = 'UserFrancisco'
go

create table Empleado(
codigo int primary key not null,
nombre char(100)
)
go

--Revertir usuario
revert 
go

--Columna calculada
use Empresa
go
create table OrdenDetalle(
OrdenDetalleId int not null primary key,
ordenId int not null,
ProductoId int not null,
precio Decimal(7,2),
cantidad int,
Parcial as precio * cantidad Persisted)--Persisted se crea el campo si no es solo virtual
go
insert into OrdenDetalle(OrdenDetalleId, ordenId, ProductoId, precio, cantidad)
values(1, 22, 7, 56.70, 7) 
go

select * from OrdenDetalle

alter table OrdenDetalle
add virtual_parcial as precio * cantidad 

--Restricciones(constraints) y relacion de tablas
use Empresa
go

create table Category(
CategoryId int identity(1,1) not null primary key,
CategoryName char(200) not null unique,
Descriptions char(500)
)
go

create table Products(
ProductID int identity(1,1) not null,
ProductName char(40) not null,
SupplierID int null,
CategoryID int null,
QuantityPerUnit char(20) null,
UnitPrice money null constraint DF_Products_UnitPrice default(0),
UnitsInStock smallint null constraint DF_Products_UnitsInStock default(0),
UnitsOnOrder smallint null constraint DF_Products_UnitsOnOrder default(0),
ReorderLevel smallint null constraint DF_Products_ReorderLevel default(0),
constraint PK_Products primary key clustered (ProductID),
constraint FK_Products_Categories foreign key (CategoryID)
references dbo.Category(CategoryId) on update cascade, -- on delete on cascade,  on delete no action
constraint CK_Products_UnitPrice check (UnitPrice>=0),
constraint CK_ReorderLevel check (ReorderLevel >=0),
constraint CK_UnitsInStock check (UnitsInStock >=0),
constraint CK_UnitsOnOrder check (UnitsOnOrder >=0)
)
GO

--Agregar cosntraint modificando la tabla
alter table Products
add constraint DF_ProductsProductName default('*****') for ProductName
go

--Deshabilitar y habilitar restriccion
alter table Products
nocheck constraint CK_ReorderLevel

alter table Products
check constraint CK_ReorderLevel	

--Agregar restriccion sin comprobar los datos existentes
alter table Products
with nocheck
add constraint CK_UnitsOnOrder check (UnitsOnOrder>=0)
go

--Tabla Particionada
alter database Empresa
add filegroup GrupoParti1
go
alter database Empresa
add filegroup GrupoParti2
go
alter database Empresa
add filegroup GrupoParti3
go

alter database Empresa 
add file (name=empresav1, filename='C:\Data\EmpresaV1.ndf', size=15MB, filegrowth=25%) to filegroup GrupoParti1
go
alter database Empresa 
add file (name=empresav2, filename='C:\Data\EmpresaV2.ndf', size=15MB, filegrowth=25%) to filegroup GrupoParti2
go
alter database Empresa 
add file (name=empresav3, filename='C:\Data\EmpresaV3.ndf', size=15MB, filegrowth=25%) to filegroup GrupoParti3
go

--Crear particiones
create partition function funciondeparticion(char(150))
as range right
for values ('I','P')
go

create partition scheme SchemaPartition as partition funciondeparticion
to (GrupoParti1, GrupoParti2, GrupoParti3)
go

--Crear tabla aprticionada
create table Personas(
	numeroOrden char(10),
	numeroRegistro bigint,
	nombre1 char(150),
	apellido1 char(150)
) on SchemaPartition(Apellido1)
go

insert into Personas(numeroOrden, numeroRegistro, nombre1, apellido1)
values('1', '77', 'Jose', 'Pineda')

--Verificar los datos en que particion estan
select Apellido1, $partition.funciondeparticion(Apellido1) as partition from Personas
go

--Tabla temporal (versionada)
create table individuos(
numeroRegistro bigint identity(1,1) primary key,
nombre1 char(150),
nombre2 char(150),
apellido1 char(150),
apellido2 char(150),
SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NUL,
SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime)    
) WITH (SYSTEM_VERSIONING = ON)  
GO
--select history
--Tablas Emporales

--Compresion de datos
execute sp_estimate_data_compression_savings
'dbo','Personas', null, null, page;--row
go
sp_helpindex[Personas]

alter table dbo.[Personas] rebuild partition= all
with (data_compression = page)--page, row
go

--Tabla partionada con indices particionados
use master
go

create database Corporation
on primary
(name=CorporacionData, filename='C:\data\CorporacionData.mdf', size= 50mb, filegrowth=25%)
log on
(name=CorporacionLog, filename='C:\data\CorporacionLog.mdf', size= 25mb, filegrowth=25%)
go
--Filegroups
alter database Corporation
add filegroup CorpoParte1
go
alter database Corporation
add filegroup CorpoParte2
go
alter database Corporation
add filegroup CorpoParte3
go

--Agregar archivos al filegroup
alter database Corporation
add file (name=Corporacion1, filename='C:\Data\Corporacion1.ndf', size=50mb, filegrowth=25%)
to filegroup CorpoParte1
go
alter database Corporation
add file (name=Corporacion2, filename='C:\Data\Corporacion2.ndf', size=50mb, filegrowth=25%)
to filegroup CorpoParte2
go
alter database Corporation
add file (name=Corporacion3, filename='C:\Data\Corporacion3.ndf', size=50mb, filegrowth=25%)
to filegroup CorpoParte3
go

--Crear tablas particionadas: funcion de particion y esquema de particion
use Corporation
GO
create partition function funciondeparticion (bigint)
as range left for values(500,1000) --datos de 0 a 500, 500 a 1000, range puede ser left<= o right<
go

create partition scheme schemaParticion as partition funciondeparticion
to(CorpoParte1, CorpoParte2, CorpoParte3)
go

--Crear table
create table Cliente(
Codigo bigint not null primary key,
nombre char(200),
apellido char(200)
) on schemaParticion(Codigo)
go
--insertar datos
insert into Cliente(Codigo, nombre, apellido)values
(91,'Jose','Pineda'), (92,'Francisco','Ramirez'),
(401,'Marco','Casillas'), (402,'Antonio','Pineda'),
(901,'Manuel','Moyao'), (902,'Manuel','Pineda')
go
--Verificar las particiones
select Codigo, nombre, apellido, $partition.funciondeparticion(Codigo) as partition from Cliente

--Indice particionado
create nonclustered index Idx_apellido
on Cliente(apellido)
on schemaParticion(Codigo)
go

insert into Cliente(Codigo, nombre, apellido)values
(1001,'Jose','Pineda'), (1002,'Francisco','Ramirez'),
(2501,'Marco','Casillas'), (2502,'Antonio','Pineda'),
(3001,'Manuel','Moyao'), (3002,'Manuel','Pineda')
go

select * from Cliente

--Crear una nueva particion
alter database Corporation
add filegroup CorpoParte4
go
--Agregar archivos al filegroup
alter database Corporation
add file (name=Corporacion4, filename='C:\Data\Corporacion4.ndf', size=50mb, filegrowth=25%)
to filegroup CorpoParte4
go

--Modificar funcion y esquema de la aprticion
alter partition scheme schemaParticion next used CorpoParte4
go
alter partition function funciondeparticion() split range (2000)
go
--Unir particiones(eliminar el groupParte4)
alter partition function funciondeparticion() merge range (2000)
go

--Restricciones
Use Empresa

create table Student(
StudentId bigint not null primary key,
socialsecuritynumber bigint,
firstname char(150),
lastname char(150),
[address] char(150) default('Ciudad'),
birthdate date
)
go

--Otra manera de crear restriccion default
alter table Student
add constraint Df_address Default ('Valor por default') for [address]
go

insert into Student (StudentId, socialsecuritynumber, firstname, lastname, birthdate)--[aaddress]
values (20595, 02258, 'Francisco', 'Pineda', '01-01-1993')--Default
go

Select * from Student;

--resticcion check
alter table Student
add constraint ck_birthdate check (datediff(year, birthdate, getdate())>=18)
go

--insertar datos
insert into Student (StudentId, socialsecuritynumber, firstname, lastname, birthdate, [address])
values (302595, 02258, 'jose', 'Pineda', '01-01-1992',Default)--No acepta birthdate 2009 etc.
go
--Borrar datos
delete Student
--Restriccion unique
alter table Student
add constraint U_socialsecuritynumber unique(socialsecuritynumber)
go

--Crear tabla asignacion
create table ClassAssign(
ClassId bigint not null primary key,
StudentId bigint,
classname char(150)
)
--Crear restriccion llave foranea
alter table ClassAssign
add constraint Fk_Studentclass foreign key (StudentId) references
Student (StudentId) on update Cascade on delete no action
go

--Comprobar
select * from Student
go 

insert into ClassAssign(ClassId, StudentId, Classname) values
--(1,30591,'Algebra Lineal') --Error por que no existe el StudentId = 30591
(1,30595,'Algebra Lineal')

--Deshabilitar Restricciones
--Deshabilitando la restriccion check en birthdate
alter table Student 
nocheck--Para volver a habiltiar solo cambiar nocheck pro check
constraint ck_birthdate
go

insert into Student (StudentId, socialsecuritynumber, firstname, lastname, birthdate, [address])
values (308995, 02958, 'jose', 'Pineda', '01-01-2009',Default)--No acepta birthdate 2009 etc.
go

--destruir restriccion check
alter table Student
drop constraint ck_birthdate
go

--consultar constraint
sp_helpconstraint Student

--colver a crear cosntraint, pero con datos previamente agregados que no cumplen la restriccion
alter table Student
with nocheck --Para ignorar lso datos que no cumplen la restriccion
add constraint ck_birthdate check (datediff(year, birthdate, getdate())>=18)
go

--deshabilitando la restriccion de llave foranea
select * from Student
Select * from ClassAssign
--deshabilitar constraint
sp_helpconstraint ClassAssign
go
Alter table ClassAssign
nocheck
constraint Fk_Studentclass
go
--comprobar que se deshabilito
insert into ClassAssign(ClassId, StudentId, Classname) values
(3,30591,'Algebra Lineal') --Acepta aunque no existe el StudentId = 30591

--Desactivar identity
--Crear tabla de prueba
create table class(
ClassId int primary key not null identity(1,1),
Name char(200)
)
--comprobar
--Wrong
insert into class(ClassId, Name) 
values(1,'Vision')
go
--Ok
insert into class(Name) 
values('Vision')
go
select * from class
go
--deshabilitar el identity temporalmente
set identity_insert dbo.class Off -- habilitarlo = Off, Deshabilitarlo = On
insert into class(ClassId, Name) 
values(5,'Control Inteligente')
go


--Definicion de indices agrupados y no agrupados: solo se puede crear un indice agrupado por tabla
--Borrar memoria cache y buffer
DBCC FREEPROCCACHE WITH NO_INFOMSGS;
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS;
--Consultar index
sp_helpindex tabla;
--Crear un indice agrupado
create clustered index cl_nombre on tabla(columna)
--Crear un indice no agrupado
create nonclustered index cl_columnan on tabla(columna1,columna2)
--Ver Informacion de los indices
DBCC SHOWCOUNTING ('dbo.tabla')
--Reorganizar indices
alter index index_nombre on nombre_tabla reorganize;
--Reconstruir un index
alter index index_nombre on nombre_tabla rebuild; --with(fillfactor=80, pad_index=on) -> sirve para dejar espacio 20% para nuevas inserciones

--Indices Columnares --- column store index
create clustered columnstore index nombre_index on Nombre_tabla;--with(DROP_EXISTING=on, maxdop=#Procesadores)//Si existen indices los eliminaa

--Eliminar indices
drop index nombre_indice on nombre_tabla

--Implementacion de vistas
--¡Que es una vista?
--Es una expresion de consulta almacenada (instruccion select almacenada)
--Tipos de vistas
--Vistas definidas por el usuario, vistsa del sistema
--Ventaja de las vistas
--simplifica las relaciones de tablas, proporciona seguridad de datos
--Vistas de gestion dinamica
--Otras vists del sistema
use Empresa
select * from class 
go
select * from ClassAssign
go
select * from Student
go

create view vista_ejemplo
as
select s.firstname, s.address, a.StudentId, c.ClassId * 3 as ID
from class as c
inner join ClassAssign as a on c.ClassId=a.ClassId
inner join Student as s on s.StudentId=a.StudentId
where s.StudentId=30595
go

select * from vista_ejemplo
--Modificar vista.. y agregar alias
alter view vista_ejemplo (nombre, Ciuidad,ID_del_estudiante,Id_de_laclase)
with encryption, -- Para encriptar y no mostrar el script
schemabinding, -- Vincualr tablas para que no sean borradas
view_metadata-- Se meustre en forma de tabla
as
select s.firstname, s.address, a.StudentId, c.ClassId * 3 as ID
from dbo.class as c
inner join dbo.ClassAssign as a on c.ClassId=a.ClassId
inner join dbo.Student as s on s.StudentId=a.StudentId
where s.StudentId=30595
go
--comprobarsi se pueden elimnar tablas (SCHEMABINDING)
drop table class
go
--Mostrar el script que origina una vista
SP_HELPTEXT vista_ejemplo

-- Uso de with check option
create view vista_check
as
select ClassId, Name
from class
where ClassId=1
go

select * from vista_check
go

insert into vista_check( Name)
values('Logica Difusa 2')
go

select * from class
go
--Agregar restriccion
alter view vista_check
as
select ClassId, Name
from class
where Name='Vision'
with check option
go

-- Comprobar que no acepta datos diferentes de Name=Vision
insert into vista_check( Name)
values('Vision')--values('Otro nombre')
go
--Vistas aprticionadas
create view vista_union
as
select ClassId
from class
union all-- union all: muestra todos lso campos aunque repetidos
select ClassId
from ClassAssign
go

drop view vista_union
select * from vista_union
go
--Crear vistas con vistas
create view vista_union2
as
select distinct * from vista_union
go
select* from vista_union2
go

--SP
create procedure numeros
as
declare @valor int =0;
while(@valor <=10)
begin
if(@valor % 2=0)
	begin
	print cast(@valor as char(10)) + 'el numero es par'
	end
else
	begin
	print cast(@valor as char(10)) + 'el numero es impar'
	end
	set @valor = @valor +1
end
go
--Eliminar un sp
drop procedure numeros
go
--ejecutar un sp
exec numeros
go
--Consultar los procedimientos existentes
select * from sys.procedures

create procedure inserte_valores(@StudentId int, @socialsecuritynumber int,
@firstname char(50), @lastname char(50))
with encryption, -- Para encriptar y no mostrar el script
as
insert into Student(StudentId, socialsecuritynumber, firstname, lastname)
values(@StudentId, @socialsecuritynumber, @firstname, @lastname)
go
--Ejecutar SP
exec inserte_valores 5,2727, 'Rodriguez', 'Roberto'
--Consultar fuente del script de un SP
SP_HELPTEXT inserte_valores

select * from Student
--devolver parametros de salida en un SP
create procedure eliminacion_estudiante(@firstname char(50),@filas int output)
as
delete from Student where firstname = @firstname
set @filas = @@ROWCOUNT
go
--Ejecutar Sp con salida
declare @datos int
exec eliminacion_estudiante 'jose',@datos output
--with recompile....sirver para recompilar el SP
select @datos
--Funciones hibrido entre una vista y un SP()
--Funcion escalar: devuelve un dato unico
Use northwind
go
Create function iva(@monto money)
returns money
as
begin
	declare @impuesto money
	set @impuesto =@monto * .12
	return(@impuesto)
end
go

select productName, unitprice, dbo.iva(unitprice) as iva from Products
go
--Creando funcion
create function comision (@monto money)		
returns money
as 
begin
declare @resultado money
if @monto>= 250
	begin
	set @resultado = @monto * .10
	end
else
	begin
	set @resultado = 0
	end
return(@resultado)
end
go
--utilizando funcion
select orderid, productid, unitprice, quantity, unitprice * quantity as partial, dbo.comision(unitprice*quantity) as comision
from [order Details]
go
--Funcioens con valores de tabla con multiples instrucciones
create function fn_listarpaises (@pais char(160))
returns @cliente table(customerid char(5),
companyname char(160), contactname char(160), country char(160))
as
begin
insert @cliente select customerid, companyname, contactname, country from customers where country = @pais
return
end
go
--Comprobando
select * from fn_listarpaises('argentina')
--funcion cn valores de tabla en linea
create function fn_ordenesfecha (@fechainicial date, @fechafinal date)
returns table
as
return(
select o.orderid, o.orderdate, p.productid, d.unitprice, d.quantity, d.unitprice * d.quantity as parcial
from orders as o inner join [Order Details] as d on o.orderid = d.orderid
inner join products as p on p.ProductID=d.ProductID
where o.orderdate between @fechainicial and @fechafinal
)
go
--Eliminar function
drop function fn_ordenesfecha
go
--Comprobando
select * from fn_ordenesfecha('1998-01-01','1998-12-31')
go
--Tiggers*************
Use northwind
go
--Trigger DML(Data Manipulation language)insert, update o delete
--Trigger after: insert, update o delete
create table HistorialBorrado(
fecha date,
descripcion char(100),
usuario char(30)
)
go
--Trigger instead of: cancela la accion desencadenadora
create trigger tg_DeleteCustomers
on Customers
after delete 
as
insert into HistorialBorrado(fecha, descripcion, usuario)
values(getDate(),'Se ha eliminado un cliente',user)
go
--Info del trigger
sp_helptrigger tg_DeleteCustomers 
go
--Comprobar Trigger
delete customers where customerid='ABCD1'
go
select * from HistorialBorrado
go
--Borrar trigger
drip trigger tg_DeleteCustomers
go
--Crear una tabla apartir de lso datos de customers
select * into deletecustomers from customers
go
--Eliminar datos de tabla
delete deletecustomers
go
--Consultar
select * from deletecustomers
go
--Crear un trigger utilizando la tabla deleted
create trigger tr_borradocliente
on customers
after delete
as insert into deletecustomers select * from deleted
--Comprobacion
select * from deletecustomers
go
delete customers where customerid = 'paris'
go
--Crear un trigger utilizando la tabla inserted
select * from [Order Details]
select * from products
go
--Crear trigger que actualice precio
create trigger tr_insertdetail
on [order details]
for insert
as
update d set d.unitprice = p.unitprice
from [Order Details] as d inner join inserted as i on i.OrderID=d.OrderID
and i.ProductID= d.ProductID
inner join Products as p on p.ProductID=i.ProductID
go
--Comrobacion
select * from [Order Details]
go
insert into [Order Details] (orderid, productid, unitprice, quantity, discount)
values(10248,30,0,10,0)
go
delete from [order Details] where orderid=10248 and productid=30
select * from [Order Details] where orderid=10248
go
--Crear trigger para debitar a inventario
create trigger debitar_inventario
on [Order Details]
for insert 
as 
update p set p.unitsinstock = p.unitsinstock - d.quantity
from products as p inner join inserted as d on d.productid = p.ProductID
go
--Crear trigger para cargar inventario
create trigger cargar_inventario
on [Order Details]
for delete 
as 
update p set p.unitsinstock = p.unitsinstock + d.quantity
from products as p inner join deleted as d on d.productid = p.ProductID
go

--Comprobar trigger
select * from products
go
select * from products where productid=32
go
insert into [Order Details] (orderid, productid, unitprice, quantity, discount)
values(10248,33,0,5,0)
go
delete from [order Details] where orderid=10248 and productid=33
go
--Actualziar 
create trigger actualizar_inventario
on[Order Details]
for update
as
update p set p.unitsinstock = p.unitsinstock + d.quantity
from products as p inner join deleted as d on d.productid = p.ProductID
update p set p.unitsinstock = p.unitsinstock - d.quantity
from products as p inner join inserted as d on d.productid = p.ProductID
go
--Comprobar
update [Order Details] set quantity=8 where orderid=10248 and productid=32
--Trigger instead of
create view catalogo
with schemabinding
as 
select CompanyName, ContactName, ContactTitle, Country, 'Customers' as [Type]
from dbo.customers
union
select CompanyName, ContactName, ContactTitle, Country, 'Supplier' as [Type]
from dbo.Suppliers
go
--Comprobar
select * from catalogo
go
--Crear trigger
create trigger insertar_catalogo
on catalogo
instead of insert
as 
insert customers(customerid, companyname, contactname, contacttitle,country)
select substring(CompanyName,1,5), CompanyName, ContactName, ContactTitle, Country from inserted
where [type]='Customers'
insert suppliers(companyname, contactname, contacttitle,country)
select CompanyName, ContactName, ContactTitle, Country from inserted
where [type]='Suppliers'
go
--Comprobar
insert into [catalogo](companyName, ContactName, ContactTitle, Country, Type)
values('Visoal','Jose Francisco Pienda','Ing.','Mexico','customers')
select * from suppliers
select * from customers
--Trigger DDL(Data Definition language)create, altre o drop
create trigger proteger
on database
for drop_table, alter_table
as
print 'Usted no puede eliminar o modificar una tabla, consulte a su adminsitrador'
rollback





