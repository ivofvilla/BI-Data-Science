CREATE TABLE [dbo].[Dim_Produto]
(
	[Cod_Produto] VARCHAR(50) NOT NULL PRIMARY KEY, 
    [Desc_Produto] VARCHAR(200) NULL, 
    [Atr_Tamanho] VARCHAR(200) NULL, 
    [Atr_Sabor] VARCHAR(200) NULL, 
    [Cod_Marca] VARCHAR(50) NULL, 
    CONSTRAINT [FK_Dim_Produto_x_Dim_Marca] FOREIGN KEY ([Cod_Marca]) REFERENCES [Dim_Marca]([Cod_Marca])
)
