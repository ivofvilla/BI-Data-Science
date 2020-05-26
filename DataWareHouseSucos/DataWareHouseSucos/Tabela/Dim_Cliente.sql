CREATE TABLE [dbo].[Dim_Cliente]
(
	[Cod_Cliente] VARCHAR(50) NOT NULL PRIMARY KEY, 
    [Desc_Cliente] VARCHAR(200) NULL, 
    [Cod_Cidade] VARCHAR(50) NULL, 
    [Desc_Cidade] VARCHAR(200) NULL,
    [Cod_Estado] VARCHAR(50) NULL, 
    [Desc_Estado] VARCHAR(200) NULL,
    [Cod_Regiao] VARCHAR(50) NULL, 
    [Desc_Regiao] VARCHAR(200) NULL,
    [Cod_Segmento] VARCHAR(50) NULL, 
    [Desc_Segmento] VARCHAR(200) NULL
)
