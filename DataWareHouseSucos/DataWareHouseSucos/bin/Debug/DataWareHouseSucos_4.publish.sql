﻿/*
Deployment script for DW_SUCOS

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "DW_SUCOS"
:setvar DefaultFilePrefix "DW_SUCOS"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The type for column Cod_Fabrica in table [dbo].[DIm_Fabrica] is currently  NVARCHAR (50) NOT NULL but is being changed to  VARCHAR (50) NOT NULL. Data loss could occur.

The type for column Desc_Fabrica in table [dbo].[DIm_Fabrica] is currently  NVARCHAR (200) NULL but is being changed to  VARCHAR (200) NULL. Data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[DIm_Fabrica])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The type for column Cod_Marca in table [dbo].[Dim_Marca] is currently  NVARCHAR (50) NOT NULL but is being changed to  VARCHAR (50) NOT NULL. Data loss could occur.

The type for column Desc_Marca in table [dbo].[Dim_Marca] is currently  NVARCHAR (200) NULL but is being changed to  VARCHAR (200) NULL. Data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Dim_Marca])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The type for column Atr_Tamanho in table [dbo].[Dim_Produto] is currently  NVARCHAR (200) NULL but is being changed to  VARCHAR (200) NULL. Data loss could occur.

The type for column Cod_Marca in table [dbo].[Dim_Produto] is currently  NVARCHAR (50) NULL but is being changed to  VARCHAR (50) NULL. Data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Dim_Produto])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Rename refactoring operation with key 6e772f4c-9c9d-4b89-8b6b-2a9ee7e1042a is skipped, element [dbo].[Dim_Tempo].[Id] (SqlSimpleColumn) will not be renamed to Cod_Dia';


GO
PRINT N'Rename refactoring operation with key b66f274a-2cfa-43d4-adea-4114f0c4a5ca is skipped, element [dbo].[Dim_Tempo].[E_Dia_Semana] (SqlSimpleColumn) will not be renamed to Tipo_Dia';


GO
PRINT N'Rename refactoring operation with key 396d855a-2a15-42f7-8a74-fa1b55f70fec is skipped, element [dbo].[Fato_001].[Id] (SqlSimpleColumn) will not be renamed to Cod_Cliente';


GO
PRINT N'Dropping [dbo].[FK_Dim_Marca_x_Dim_Categoria]...';


GO
ALTER TABLE [dbo].[Dim_Marca] DROP CONSTRAINT [FK_Dim_Marca_x_Dim_Categoria];


GO
PRINT N'Dropping [dbo].[FK_Dim_Produto_x_Dim_Marca]...';


GO
ALTER TABLE [dbo].[Dim_Produto] DROP CONSTRAINT [FK_Dim_Produto_x_Dim_Marca];


GO
PRINT N'Starting rebuilding table [dbo].[DIm_Fabrica]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_DIm_Fabrica] (
    [Cod_Fabrica]  VARCHAR (50)  NOT NULL,
    [Desc_Fabrica] VARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([Cod_Fabrica] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[DIm_Fabrica])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_DIm_Fabrica] ([Cod_Fabrica], [Desc_Fabrica])
        SELECT   [Cod_Fabrica],
                 [Desc_Fabrica]
        FROM     [dbo].[DIm_Fabrica]
        ORDER BY [Cod_Fabrica] ASC;
    END

DROP TABLE [dbo].[DIm_Fabrica];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_DIm_Fabrica]', N'DIm_Fabrica';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Dim_Marca]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Dim_Marca] (
    [Cod_Marca]     VARCHAR (50)  NOT NULL,
    [Desc_Marca]    VARCHAR (200) NULL,
    [Cod_Categoria] VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([Cod_Marca] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Dim_Marca])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Dim_Marca] ([Cod_Marca], [Desc_Marca], [Cod_Categoria])
        SELECT   [Cod_Marca],
                 [Desc_Marca],
                 [Cod_Categoria]
        FROM     [dbo].[Dim_Marca]
        ORDER BY [Cod_Marca] ASC;
    END

DROP TABLE [dbo].[Dim_Marca];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Dim_Marca]', N'Dim_Marca';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Altering [dbo].[Dim_Produto]...';


GO
ALTER TABLE [dbo].[Dim_Produto] ALTER COLUMN [Atr_Tamanho] VARCHAR (200) NULL;

ALTER TABLE [dbo].[Dim_Produto] ALTER COLUMN [Cod_Marca] VARCHAR (50) NULL;


GO
PRINT N'Creating [dbo].[Dim_Tempo]...';


GO
CREATE TABLE [dbo].[Dim_Tempo] (
    [Cod_Dia]            VARCHAR (50) NOT NULL,
    [Data]               DATE         NULL,
    [Cod_Semana]         INT          NULL,
    [Nome_Dia_Semana]    VARCHAR (50) NULL,
    [Cod_Mes]            INT          NULL,
    [Nome_Mes]           VARCHAR (50) NULL,
    [Cod_Mes_Ano]        VARCHAR (50) NULL,
    [Nome_Mes_Ano]       VARCHAR (50) NULL,
    [Cod_Trimestre]      INT          NULL,
    [Nome_Trimestre]     VARCHAR (50) NULL,
    [Cod_Trimestre_Ano]  VARCHAR (50) NULL,
    [Nome_Trimestre_Ano] VARCHAR (50) NULL,
    [Cod_Semestre]       INT          NULL,
    [Nome_Semestre]      VARCHAR (50) NULL,
    [Cod_Semestre_Ano]   VARCHAR (50) NULL,
    [Nome_Semestre_Ano]  VARCHAR (50) NULL,
    [Ano]                VARCHAR (50) NULL,
    [Tipo_Dia]           VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Cod_Dia] ASC)
);


GO
PRINT N'Creating [dbo].[Fato_001]...';


GO
CREATE TABLE [dbo].[Fato_001] (
    [Cod_Cliente]        VARCHAR (50) NOT NULL,
    [Cod_Produto]        VARCHAR (50) NOT NULL,
    [Cod_Organizacional] VARCHAR (50) NOT NULL,
    [Cod_Fabrica]        VARCHAR (50) NOT NULL,
    [Cod_Dia]            VARCHAR (50) NOT NULL,
    [Faturamento]        FLOAT (53)   NULL,
    [Imposto]            FLOAT (53)   NULL,
    [Custo_Variavel]     FLOAT (53)   NULL,
    [Quantidade ]        FLOAT (53)   NULL,
    [Unidade_Vendidada]  FLOAT (53)   NULL,
    PRIMARY KEY CLUSTERED ([Cod_Cliente] ASC, [Cod_Produto] ASC, [Cod_Organizacional] ASC, [Cod_Fabrica] ASC, [Cod_Dia] ASC)
);


GO
PRINT N'Creating [dbo].[Fato_002]...';


GO
CREATE TABLE [dbo].[Fato_002] (
    [Cod_Cliente] VARCHAR (50) NOT NULL,
    [Cod_Produto] VARCHAR (50) NOT NULL,
    [Cod_Fabrica] VARCHAR (50) NOT NULL,
    [Cod_Dia]     VARCHAR (50) NOT NULL,
    [Frete]       FLOAT (53)   NULL,
    PRIMARY KEY CLUSTERED ([Cod_Cliente] ASC, [Cod_Produto] ASC, [Cod_Fabrica] ASC, [Cod_Dia] ASC)
);


GO
PRINT N'Creating [dbo].[Fato_003]...';


GO
CREATE TABLE [dbo].[Fato_003] (
    [Cod_Fabrica] VARCHAR (50) NOT NULL,
    [Cod_Dia]     VARCHAR (50) NOT NULL,
    [Custo_Fixo]  FLOAT (53)   NULL,
    PRIMARY KEY CLUSTERED ([Cod_Fabrica] ASC, [Cod_Dia] ASC)
);


GO
PRINT N'Creating [dbo].[Fato_004]...';


GO
CREATE TABLE [dbo].[Fato_004] (
    [Cod_Cliente]        VARCHAR (50) NOT NULL,
    [Cod_Produto]        VARCHAR (50) NOT NULL,
    [Cod_Organizacional] VARCHAR (50) NOT NULL,
    [Cod_Dia]            VARCHAR (50) NOT NULL,
    [Meta_Faturamento]   FLOAT (53)   NULL,
    PRIMARY KEY CLUSTERED ([Cod_Cliente] ASC, [Cod_Produto] ASC, [Cod_Organizacional] ASC, [Cod_Dia] ASC)
);


GO
PRINT N'Creating [dbo].[Fato_005]...';


GO
CREATE TABLE [dbo].[Fato_005] (
    [Cod_Produto] VARCHAR (50) NOT NULL,
    [Cod_Fabrica] VARCHAR (50) NOT NULL,
    [Cod_Dia]     VARCHAR (50) NOT NULL,
    [Meta_Custo]  FLOAT (53)   NULL,
    PRIMARY KEY CLUSTERED ([Cod_Produto] ASC, [Cod_Fabrica] ASC, [Cod_Dia] ASC)
);


GO
PRINT N'Creating [dbo].[FK_Dim_Marca_x_Dim_Categoria]...';


GO
ALTER TABLE [dbo].[Dim_Marca] WITH NOCHECK
    ADD CONSTRAINT [FK_Dim_Marca_x_Dim_Categoria] FOREIGN KEY ([Cod_Categoria]) REFERENCES [dbo].[Dim_Categoria] ([Cod_Categoria]);


GO
PRINT N'Creating [dbo].[FK_Dim_Produto_x_Dim_Marca]...';


GO
ALTER TABLE [dbo].[Dim_Produto] WITH NOCHECK
    ADD CONSTRAINT [FK_Dim_Produto_x_Dim_Marca] FOREIGN KEY ([Cod_Marca]) REFERENCES [dbo].[Dim_Marca] ([Cod_Marca]);


GO
PRINT N'Creating [dbo].[FK_Fato_001_Dim_Cliente]...';


GO
ALTER TABLE [dbo].[Fato_001] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_001_Dim_Cliente] FOREIGN KEY ([Cod_Cliente]) REFERENCES [dbo].[Dim_Cliente] ([Cod_Cliente]);


GO
PRINT N'Creating [dbo].[FK_Fato_001_Dim_Produto]...';


GO
ALTER TABLE [dbo].[Fato_001] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_001_Dim_Produto] FOREIGN KEY ([Cod_Produto]) REFERENCES [dbo].[Dim_Produto] ([Cod_Produto]);


GO
PRINT N'Creating [dbo].[FK_Fato_001_Dim_Organizacional]...';


GO
ALTER TABLE [dbo].[Fato_001] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_001_Dim_Organizacional] FOREIGN KEY ([Cod_Organizacional]) REFERENCES [dbo].[Dim_Organizacional] ([Cod_Filho]);


GO
PRINT N'Creating [dbo].[FK_Fato_001_Dim_Fabrica]...';


GO
ALTER TABLE [dbo].[Fato_001] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_001_Dim_Fabrica] FOREIGN KEY ([Cod_Fabrica]) REFERENCES [dbo].[DIm_Fabrica] ([Cod_Fabrica]);


GO
PRINT N'Creating [dbo].[FK_Fato_001_Dim_Dia]...';


GO
ALTER TABLE [dbo].[Fato_001] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_001_Dim_Dia] FOREIGN KEY ([Cod_Dia]) REFERENCES [dbo].[Dim_Tempo] ([Cod_Dia]);


GO
PRINT N'Creating [dbo].[FK_Fato_002_Dim_Cliente]...';


GO
ALTER TABLE [dbo].[Fato_002] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_002_Dim_Cliente] FOREIGN KEY ([Cod_Cliente]) REFERENCES [dbo].[Dim_Cliente] ([Cod_Cliente]);


GO
PRINT N'Creating [dbo].[FK_Fato_002_Dim_Produto]...';


GO
ALTER TABLE [dbo].[Fato_002] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_002_Dim_Produto] FOREIGN KEY ([Cod_Produto]) REFERENCES [dbo].[Dim_Produto] ([Cod_Produto]);


GO
PRINT N'Creating [dbo].[FK_Fato_002_Dim_Fabrica]...';


GO
ALTER TABLE [dbo].[Fato_002] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_002_Dim_Fabrica] FOREIGN KEY ([Cod_Fabrica]) REFERENCES [dbo].[DIm_Fabrica] ([Cod_Fabrica]);


GO
PRINT N'Creating [dbo].[FK_Fato_002_Dim_Dia]...';


GO
ALTER TABLE [dbo].[Fato_002] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_002_Dim_Dia] FOREIGN KEY ([Cod_Dia]) REFERENCES [dbo].[Dim_Tempo] ([Cod_Dia]);


GO
PRINT N'Creating [dbo].[FK_Fato_003_Dim_Fabrica]...';


GO
ALTER TABLE [dbo].[Fato_003] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_003_Dim_Fabrica] FOREIGN KEY ([Cod_Fabrica]) REFERENCES [dbo].[DIm_Fabrica] ([Cod_Fabrica]);


GO
PRINT N'Creating [dbo].[FK_Fato_003_Dim_Dia]...';


GO
ALTER TABLE [dbo].[Fato_003] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_003_Dim_Dia] FOREIGN KEY ([Cod_Dia]) REFERENCES [dbo].[Dim_Tempo] ([Cod_Dia]);


GO
PRINT N'Creating [dbo].[FK_Fato_004_Dim_Cliente]...';


GO
ALTER TABLE [dbo].[Fato_004] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_004_Dim_Cliente] FOREIGN KEY ([Cod_Cliente]) REFERENCES [dbo].[Dim_Cliente] ([Cod_Cliente]);


GO
PRINT N'Creating [dbo].[FK_Fato_004_Dim_Produto]...';


GO
ALTER TABLE [dbo].[Fato_004] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_004_Dim_Produto] FOREIGN KEY ([Cod_Produto]) REFERENCES [dbo].[Dim_Produto] ([Cod_Produto]);


GO
PRINT N'Creating [dbo].[FK_Fato_004_Dim_Organizacional]...';


GO
ALTER TABLE [dbo].[Fato_004] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_004_Dim_Organizacional] FOREIGN KEY ([Cod_Organizacional]) REFERENCES [dbo].[Dim_Organizacional] ([Cod_Filho]);


GO
PRINT N'Creating [dbo].[FK_Fato_004_Dim_Dia]...';


GO
ALTER TABLE [dbo].[Fato_004] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_004_Dim_Dia] FOREIGN KEY ([Cod_Dia]) REFERENCES [dbo].[Dim_Tempo] ([Cod_Dia]);


GO
PRINT N'Creating [dbo].[FK_Fato_005_Dim_Produto]...';


GO
ALTER TABLE [dbo].[Fato_005] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_005_Dim_Produto] FOREIGN KEY ([Cod_Produto]) REFERENCES [dbo].[Dim_Produto] ([Cod_Produto]);


GO
PRINT N'Creating [dbo].[FK_Fato_005_Dim_Fabrica]...';


GO
ALTER TABLE [dbo].[Fato_005] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_005_Dim_Fabrica] FOREIGN KEY ([Cod_Fabrica]) REFERENCES [dbo].[DIm_Fabrica] ([Cod_Fabrica]);


GO
PRINT N'Creating [dbo].[FK_Fato_005_Dim_Tempo]...';


GO
ALTER TABLE [dbo].[Fato_005] WITH NOCHECK
    ADD CONSTRAINT [FK_Fato_005_Dim_Tempo] FOREIGN KEY ([Cod_Dia]) REFERENCES [dbo].[Dim_Tempo] ([Cod_Dia]);


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '6e772f4c-9c9d-4b89-8b6b-2a9ee7e1042a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('6e772f4c-9c9d-4b89-8b6b-2a9ee7e1042a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b66f274a-2cfa-43d4-adea-4114f0c4a5ca')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b66f274a-2cfa-43d4-adea-4114f0c4a5ca')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '396d855a-2a15-42f7-8a74-fa1b55f70fec')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('396d855a-2a15-42f7-8a74-fa1b55f70fec')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Dim_Marca] WITH CHECK CHECK CONSTRAINT [FK_Dim_Marca_x_Dim_Categoria];

ALTER TABLE [dbo].[Dim_Produto] WITH CHECK CHECK CONSTRAINT [FK_Dim_Produto_x_Dim_Marca];

ALTER TABLE [dbo].[Fato_001] WITH CHECK CHECK CONSTRAINT [FK_Fato_001_Dim_Cliente];

ALTER TABLE [dbo].[Fato_001] WITH CHECK CHECK CONSTRAINT [FK_Fato_001_Dim_Produto];

ALTER TABLE [dbo].[Fato_001] WITH CHECK CHECK CONSTRAINT [FK_Fato_001_Dim_Organizacional];

ALTER TABLE [dbo].[Fato_001] WITH CHECK CHECK CONSTRAINT [FK_Fato_001_Dim_Fabrica];

ALTER TABLE [dbo].[Fato_001] WITH CHECK CHECK CONSTRAINT [FK_Fato_001_Dim_Dia];

ALTER TABLE [dbo].[Fato_002] WITH CHECK CHECK CONSTRAINT [FK_Fato_002_Dim_Cliente];

ALTER TABLE [dbo].[Fato_002] WITH CHECK CHECK CONSTRAINT [FK_Fato_002_Dim_Produto];

ALTER TABLE [dbo].[Fato_002] WITH CHECK CHECK CONSTRAINT [FK_Fato_002_Dim_Fabrica];

ALTER TABLE [dbo].[Fato_002] WITH CHECK CHECK CONSTRAINT [FK_Fato_002_Dim_Dia];

ALTER TABLE [dbo].[Fato_003] WITH CHECK CHECK CONSTRAINT [FK_Fato_003_Dim_Fabrica];

ALTER TABLE [dbo].[Fato_003] WITH CHECK CHECK CONSTRAINT [FK_Fato_003_Dim_Dia];

ALTER TABLE [dbo].[Fato_004] WITH CHECK CHECK CONSTRAINT [FK_Fato_004_Dim_Cliente];

ALTER TABLE [dbo].[Fato_004] WITH CHECK CHECK CONSTRAINT [FK_Fato_004_Dim_Produto];

ALTER TABLE [dbo].[Fato_004] WITH CHECK CHECK CONSTRAINT [FK_Fato_004_Dim_Organizacional];

ALTER TABLE [dbo].[Fato_004] WITH CHECK CHECK CONSTRAINT [FK_Fato_004_Dim_Dia];

ALTER TABLE [dbo].[Fato_005] WITH CHECK CHECK CONSTRAINT [FK_Fato_005_Dim_Produto];

ALTER TABLE [dbo].[Fato_005] WITH CHECK CHECK CONSTRAINT [FK_Fato_005_Dim_Fabrica];

ALTER TABLE [dbo].[Fato_005] WITH CHECK CHECK CONSTRAINT [FK_Fato_005_Dim_Tempo];


GO
PRINT N'Update complete.';


GO
