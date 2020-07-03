# TCE MG
Processamento de dados obtidos do TCE-MG para projeto Tá de Pé - Merenda, da Transparência Brasil

## Objetivos
Esse repositório visa auxiliar o trabalho de expansão do projeto Tá de Pé - Merenda (TDPM) , processando os dados e indicando como encontrar as informações para alimentar o sistema.

Ele é dividido em duas etapas:
1. O script ```cria_arquivos.R``` , que unifica em um RData as diferentes tabelas de informações de cada um dos municípios registrados pelo TCE-MG
2. O RMD ```análise.RMD``` que trabalha com os Rdatas resultantes e indica onde estão cada um dos itens necessários para alimentação do repositório TDPM.

**Importante**: o ```cria_arquivos.R``` foi desenvolvido para minha máquina local, portanto, deve-se ajustar os diretórios. Ele também está um pouco comprido devido a bugs na hora de importar as planilhas em loop. Não tive tempo de achar a solução mais eficiente, apenas fui resolvendo o problema para conseguir importar todos os arquivos e fazer a análise. Os arquivos utilizados estão disponíveis em https://dadosabertos.tce.mg.gov.br/view/xhtml/paginas/downloadArquivos.xhtml , e foram coletados em 29/06/2020 . Foram utilizados aqui apenas os arquivos do ano de 2020.
