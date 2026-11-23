# Quanto os atributos disponíveis separam registros com e sem AVC?

Projeto prático de classificação da disciplina **CIN0209 — Aprendizado de Máquina 1**, Bacharelado em Inteligência Artificial, CIn/UFPE, 2026.2.

**Autores:** Joaquim Veras e Luiz Henrique Falcão

---

## A pergunta

Atributos clínicos e demográficos de registro simples separam pacientes com histórico de AVC dos demais, e a que custo de falsos positivos?

A aplicação imaginada é uma **triagem de risco** — indicar quem encaminhar para avaliação clínica — e não um diagnóstico. Essa finalidade define a assimetria dos erros: deixar de identificar um caso custa mais do que um exame desnecessário.

## Os dados

[Brain Stroke Dataset](https://www.kaggle.com/datasets/jillanisofttech/brain-stroke-dataset) (Kaggle), 4.981 registros, 10 atributos preditores e alvo binário, sem valores faltantes.

O alvo é fortemente desbalanceado: **248 casos de AVC, 4,98% da base**. Um classificador que preveja sempre "sem AVC" alcança 95,02% de acurácia e não identifica paciente algum — por isso a métrica principal é a **acurácia balanceada**.

## Protocolo

| | |
|---|---|
| Divisão | 2.988 treino / 996 validação / 997 teste, semente 10 |
| Desenvolvimento | treino + validação = 3.984 registros, 198 positivos |
| Busca | validação cruzada estratificada, k = 5, 309 combinações |
| Pré-processamento | dentro de um `Pipeline`, reajustado em cada fold |
| Métrica | acurácia balanceada |
| Teste | aberto **uma única vez**, após a declaração dos campeões |

Seis famílias comparadas: árvore de decisão, kNN, Naive Bayes, regressão logística, Perceptron e MLP.

## Resultados

Validação cruzada, em acurácia balanceada:

| Família | CV | EP | Treino | Lacuna |
|---|---:|---:|---:|---:|
| **Regressão logística** | **0,7757** | 0,0109 | 0,7764 | 0,0007 |
| Árvore de decisão | 0,7567 | 0,0120 | 0,7860 | 0,0294 |
| Naive Bayes | 0,6796 | 0,0133 | 0,6929 | 0,0133 |
| Perceptron | 0,6680 | 0,0384 | 0,6683 | 0,0003 |
| MLP | 0,5451 | 0,0097 | 0,8404 | 0,2953 |
| kNN | 0,5421 | 0,0116 | 1,0000 | 0,4579 |

No teste, o campeão obteve **0,7565 de acurácia balanceada** e **0,841 de AUC**, encontrando 38 dos 50 casos de AVC ao custo de 234 falsos positivos entre 947 pacientes saudáveis.

## Conclusão

Os atributos separam parcialmente. **O limite não é o algoritmo:** seis famílias de capacidades muito diferentes convergem para a mesma faixa, e a mais simples delas vence. A MLP, que é um aproximador universal, não encontrou estrutura adicional — apenas memorizou o treino. Uma árvore de profundidade 1, um único corte, já alcança 98% do desempenho máximo da sua família.

A precisão de 0,1397 na classe de interesse é consequência da prevalência de 5%, não da escolha de pesos: nenhuma das seis famílias superou 0,164.

## Estrutura do repositório

```
notebooks/
  entrega1_exploracao_e_baselines.ipynb    exploração, preparação, árvore, kNN e LVQ
  entrega2_comparacao_seis_familias.ipynb  protocolo de CV, seis famílias, teste único
data/
  brain_stroke.csv                         base original
docs/
  relatorio_tecnico.pdf                    relatório completo do projeto
  slides_seminario.pdf                     slides do seminário final
```

## Reprodução

Os notebooks foram executados no Google Colab. Ambiente registrado:

```
python 3.13.16 · numpy 2.1.3 · pandas 2.2.3 · scikit-learn 1.6.1
```

O notebook da Entrega 2 implementa controle de integridade: um hash do protocolo cobre dados, semente, divisão, grades e versões de biblioteca, e uma trava de arquivo impede que o conjunto de teste seja reavaliado. Alterar a configuração muda o hash e bloqueia a execução.

## Limitações declaradas

- 198 casos positivos no desenvolvimento; uma única semente e uma única divisão.
- Naive Bayes e Perceptron terminaram com o ótimo na borda da grade mesmo após extensão.
- O conjunto de teste foi consultado na Entrega 1 como diagnóstico preliminar; nenhuma decisão da Entrega 2 se apoiou nesses resultados.
- 30,1% dos registros têm tabagismo `Unknown`, mantido como categoria própria.
- A comparação não estabelece causalidade nem validade clínica.

## Uso de IA

Assistentes de IA foram usados para revisão de estrutura, depuração de código, organização das buscas e apoio à redação. As decisões metodológicas, a interpretação dos resultados e as conclusões são dos autores. As implementações autorais do Perceptron e da MLP foram escritas em NumPy, sem bibliotecas de aprendizado. Detalhamento na Seção 7 do relatório técnico.

## Licença dos dados

Base sob Open Database License; conteúdo sob Database Contents License.
