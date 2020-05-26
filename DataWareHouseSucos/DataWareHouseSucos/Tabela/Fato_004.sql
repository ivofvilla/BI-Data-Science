CREATE TABLE [dbo].[Fato_004]
(
	[Cod_Cliente] VARCHAR(50) NOT NULL , 
    [Cod_Produto] VARCHAR(50) NOT NULL, 
    [Cod_Organizacional] VARCHAR(50) NOT NULL, 
    [Cod_Dia] VARCHAR(50) NOT NULL, 
    [Meta_Faturamento] FLOAT NULL, 
    PRIMARY KEY ([Cod_Cliente], [Cod_Produto], [Cod_Organizacional], [Cod_Dia]), 
    CONSTRAINT [FK_Fato_004_Dim_Cliente] FOREIGN KEY ([Cod_Cliente]) REFERENCES [Dim_Cliente]([Cod_Cliente]), 
    CONSTRAINT [FK_Fato_004_Dim_Produto] FOREIGN KEY ([Cod_Produto]) REFERENCES [Dim_Produto]([Cod_Produto]), 
    CONSTRAINT [FK_Fato_004_Dim_Organizacional] FOREIGN KEY ([Cod_Organizacional]) REFERENCES [Dim_Organizacional]([Cod_Filho]), 
    CONSTRAINT [FK_Fato_004_Dim_Dia] FOREIGN KEY ([Cod_Dia]) REFERENCES [Dim_Tempo]([Cod_Dia])
)
