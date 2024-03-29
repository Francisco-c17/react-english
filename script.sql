USE [master]
GO
/****** Object:  Database [Empresa]    Script Date: 20/06/2019 12:16:51 p.m. ******/
CREATE DATABASE [Empresa]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EmpresaPrimary', FILENAME = N'C:\Data\Empresa.mdf' , SIZE = 51200KB , MAXSIZE = UNLIMITED, FILEGROWTH = 25%), 
 FILEGROUP [GrupoParti1] 
( NAME = N'empresav1', FILENAME = N'C:\Data\EmpresaV1.ndf' , SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 25%), 
 FILEGROUP [GrupoParti2] 
( NAME = N'empresav2', FILENAME = N'C:\Data\EmpresaV2.ndf' , SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 25%), 
 FILEGROUP [GrupoParti3] 
( NAME = N'empresav3', FILENAME = N'C:\Data\EmpresaV3.ndf' , SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 25%), 
 FILEGROUP [Produccion] 
( NAME = N'EmpresaProduccion', FILENAME = N'C:\Data\EmpresaProduccion.ndf' , SIZE = 51200KB , MAXSIZE = UNLIMITED, FILEGROWTH = 25%)
 LOG ON 
( NAME = N'EmpresaLog', FILENAME = N'C:\Data\EmpresaLog.ldf' , SIZE = 25600KB , MAXSIZE = 2048GB , FILEGROWTH = 25%)
GO
ALTER DATABASE [Empresa] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Empresa].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Empresa] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Empresa] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Empresa] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Empresa] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Empresa] SET ARITHABORT OFF 
GO
ALTER DATABASE [Empresa] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Empresa] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Empresa] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Empresa] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Empresa] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Empresa] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Empresa] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Empresa] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Empresa] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Empresa] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Empresa] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Empresa] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Empresa] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Empresa] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Empresa] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Empresa] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Empresa] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Empresa] SET RECOVERY FULL 
GO
ALTER DATABASE [Empresa] SET  MULTI_USER 
GO
ALTER DATABASE [Empresa] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Empresa] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Empresa] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Empresa] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Empresa] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Empresa', N'ON'
GO
USE [Empresa]
GO
/****** Object:  User [UserFrancisco]    Script Date: 20/06/2019 12:16:51 p.m. ******/
CREATE USER [UserFrancisco] FOR LOGIN [UserFrancisco] WITH DEFAULT_SCHEMA=[Informatica]
GO
/****** Object:  Schema [Informatica]    Script Date: 20/06/2019 12:16:52 p.m. ******/
CREATE SCHEMA [Informatica]
GO
/****** Object:  PartitionFunction [funciondeparticion]    Script Date: 20/06/2019 12:16:52 p.m. ******/
CREATE PARTITION FUNCTION [funciondeparticion](char(150)) AS RANGE RIGHT FOR VALUES (N'I                                                                                                                                                     ', N'P                                                                                                                                                     ')
GO
/****** Object:  PartitionScheme [SchemaPartition]    Script Date: 20/06/2019 12:16:52 p.m. ******/
CREATE PARTITION SCHEME [SchemaPartition] AS PARTITION [funciondeparticion] TO ([GrupoParti1], [GrupoParti2], [GrupoParti3])
GO
/****** Object:  Table [dbo].[Category]    Script Date: 20/06/2019 12:16:52 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [char](200) NOT NULL,
	[Descriptions] [char](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CategoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cliente]    Script Date: 20/06/2019 12:16:52 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cliente](
	[codigocliente] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [char](150) NULL,
	[direccion] [char](300) NOT NULL,
	[telefono] [char](20) NULL,
	[email] [char](40) NULL,
	[edad] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[codigocliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenDetalle]    Script Date: 20/06/2019 12:16:52 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenDetalle](
	[OrdenDetalleId] [int] NOT NULL,
	[ordenId] [int] NOT NULL,
	[ProductoId] [int] NOT NULL,
	[precio] [decimal](7, 2) NULL,
	[cantidad] [int] NULL,
	[Parcial]  AS ([precio]*[cantidad]) PERSISTED,
	[virtual_parcial]  AS ([precio]*[cantidad]),
PRIMARY KEY CLUSTERED 
(
	[OrdenDetalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personas]    Script Date: 20/06/2019 12:16:52 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personas](
	[numeroOrden] [char](10) NULL,
	[numeroregistro] [bigint] NULL,
	[nombre1] [char](150) NULL,
	[apellido1] [char](150) NULL
) ON [SchemaPartition]([apellido1])
GO
/****** Object:  Table [dbo].[Products]    Script Date: 20/06/2019 12:16:52 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [char](40) NOT NULL,
	[SupplierID] [int] NULL,
	[CategoryID] [int] NULL,
	[QuantityPerUnit] [char](20) NULL,
	[UnitPrice] [money] NULL,
	[UnitsInStock] [smallint] NULL,
	[UnitsOnOrder] [smallint] NULL,
	[ReorderLevel] [smallint] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Informatica].[Empleado]    Script Date: 20/06/2019 12:16:52 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Informatica].[Empleado](
	[codigo] [int] NOT NULL,
	[nombre] [char](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cliente] ADD  DEFAULT ('733-141-366') FOR [telefono]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_ProductsProductName]  DEFAULT ('*****') FOR [ProductName]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_UnitPrice]  DEFAULT ((0)) FOR [UnitPrice]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_UnitsInStock]  DEFAULT ((0)) FOR [UnitsInStock]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_UnitsOnOrder]  DEFAULT ((0)) FOR [UnitsOnOrder]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_ReorderLevel]  DEFAULT ((0)) FOR [ReorderLevel]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryId])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories]
GO
ALTER TABLE [dbo].[cliente]  WITH CHECK ADD  CONSTRAINT [ck_edad] CHECK  (([edad]>=(18)))
GO
ALTER TABLE [dbo].[cliente] CHECK CONSTRAINT [ck_edad]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [CK_Products_UnitPrice] CHECK  (([UnitPrice]>=(0)))
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [CK_Products_UnitPrice]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [CK_ReorderLevel] CHECK  (([ReorderLevel]>=(0)))
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [CK_ReorderLevel]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [CK_UnitsInStock] CHECK  (([UnitsInStock]>=(0)))
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [CK_UnitsInStock]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [CK_UnitsOnOrder] CHECK  (([UnitsOnOrder]>=(0)))
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [CK_UnitsOnOrder]
GO
USE [master]
GO
ALTER DATABASE [Empresa] SET  READ_WRITE 
GO
