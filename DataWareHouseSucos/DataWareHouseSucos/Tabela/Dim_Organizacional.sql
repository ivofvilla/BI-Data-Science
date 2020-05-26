CREATE TABLE [dbo].[Dim_Organizacional]
(
	[Cod_Filho] VARCHAR(50) NOT NULL PRIMARY KEY, 
    [Desc_Filho] VARCHAR(200) NULL, 
    [Cod_Pai] VARCHAR(50) NULL, 
    [Esquerda] INT NULL, 
    [Direita] INT NULL, 
    [Nivel] INT NULL, 
    CONSTRAINT [FK_Dim_Organizacional_Dim_Organizacional] FOREIGN KEY ([Cod_Pai]) REFERENCES [Dim_Organizacional]([Cod_Filho])
)
