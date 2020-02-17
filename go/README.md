# Teste de Back-end Bcredi

## Como executar
```
  make test
  make run path=../test/input/input001.txt
```

## Observações
  A regra sobre os estados _(As garantias de imóvel dos estados PR, SC e RS não são aceitas)_ não ficou claro se era para cancelar toda a proposta ou se deveria ignorar somente o imovel conflitante. Sendo assim apliquei a regra apenas ignorando o imovel não apto e trabalhando com os demais, uma vez que eu posso ter mais de uma garantia de imovel em estados diferentes, como ocorre no input009.
