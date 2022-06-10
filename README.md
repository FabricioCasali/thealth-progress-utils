#thealth-progress-utils

Repositório central com bibliotecas criadas e mantidas pela equipe da THEALTH Ltda, empresa especializada em desenvolvimento e consultoria de software, focada (mas não limitada) em sistemas de saúde.  

Diversos dos sistemas que trabalhamos são escritos em OpenEdge Progress (https://www.progress.com/openedge), então acabamos desenvolvendo estas  funções para facilitar o desenvolvimento de customizações para estes produtos.

# thealth/libs 

Dentro das libs, existem diversas bibliotecas, para diversos fins.


## thealth/libs/api-mantem-parametro.p

Permite criar, buscar e remover parametros de forma fácil, utilizando uma tabela genérica.
Para criar a tabela, o arquivo thealth/libs/api-mantem-parametros.df possui a definição da estrutura da tabela (basta ajustar os campos. 

> Este programa compila mesmo que a tabela não exista, então pode ser adicionado um ***no-error*** na chamada da rotina para não gerar *exception*. Útil para criar comportamentos opcionais para um programa

### MÉTODOS

> buscarParametro -busca um parâmetro

> removerParametro - remove um parâmetro caso exista

> salvarParametro - criar ou atualiza um parâmetro
    

Para usar a api, segue exemplo abaixo:

```
define variable hd-api-config               as   handle     no-undo.

run thealth/libs/api-mantem-parametros.p persistent set hd-api-config.
                                                              
run buscarParametro in hd-api-config 
    (input  "th-gps-param",             // nome da tabela onde os parametros estão salvos
     input  "reajuste-plano-consultar", // nome do programa ou processo relacionado aos parametros
     input  v_cod_usuar_corren,         // nome do usuário relacionado ao parâmetro. Caso seja uma parâmetro global, usar ?
     input  "layout.browse",            // chave do parametro
     output lo-configuracao-browse)     // longchar contendo o valor salvo. caso não exista parametro, retorna ?
     no-error.  
```

## thealth/libs/gerar-arquivo.w

Exibe um frame simples para informar o nome caminho e nome de um arquivo, permitindo que o usuário escolha o diretório e ajuste o nome do arquivo.

```
...
run thealth/libs/gerar-arquivo.w 
    (input  session:temp-directory, // diretório inicial para salvar o arquivo
     input  ch-nome-arquivo,        // sugestão de nome do arquivo 
     input  yes,                    // indica se o usuario pode ou não alterar o nome do arquivo
     output lg-confirmou,           // indica se o usuario confirmou a geração do arquivo, ou optou por cancelar
     output ch-caminho-completo).   // retorna o caminho completo para o arquivo 
                   
if not lg-confirmou
then return.
...
```

## thealth/libs/exportar-excel.p

Permite exportar os dados de uma temp-table para uma planilha Excel (XSLX), utilizando a interface COM do Excel. Óbviamente, é necessário que o Excel esteja instalado na máquina.
A API publica um evento para cada linha registrada no Excel

### MÉTODOS

* exportarExcel - Exporta os dados para o Excel sem aplicar nenhuma regra de formatação especial. Será utilizado o label definido nas colunas da temp-table para definir o título da coluna no excel, bem como o formato
* exportarExcelEspecial - Exporta os dados para o Excel permitindo personalizar algumas informações sobre cada coluna


```
// solicita caminho + nome do arquivo
run thealth/libs/gerar-arquivo.w 
    (input  session:temp-directory,
     input  ch-nome-arquivo,     
     input  yes,  
     output lg-confirmou,
     output ch-caminho-completo).        
                   
if not lg-confirmou
then return.         

// cria a janela de acompanhamento do processamento
run thealth/libs/status-processamento.w persistent set hd-status (input  "Exportando", no).

// persiste a api
run thealth/libs/exportar-excel.p persistent set hd-exportar.

// assina o evento publicado pela API para atualizar o frame de status do processamento.
subscribe to EV_EXPORTAR_EXCEL_LINHA in hd-exportar run-procedure 'eventoExportar'.
               
// chama a api
run exportarExcel in hd-exportar (input  ch-caminho-completo,
                                  input  buffer temp-exportar:handle).
```