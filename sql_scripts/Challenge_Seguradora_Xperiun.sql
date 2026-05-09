/* VALIDAÇÃO 1: Anomalias de Data (Cancelamento ANTES do Início) */
SELECT COUNT(*) AS erros_de_data
FROM f_apolice
WHERE data_cancelamento <> ''
  AND data_cancelamento < data_inicio;

/* VALIDAÇÃO 2: Valores Financeiros Negativos ou Zerados onde não deveriam */
SELECT COUNT(*) AS erros_financeiros
FROM f_apolice
WHERE premio_mensal <= 0 
   OR receita_esperada < 0;

/* VALIDAÇÃO 3: Validando o volume das tabelas auxiliares */
SELECT 
    (SELECT COUNT(cliente_id) FROM d_cliente) AS total_clientes_esperado_25000,
    (SELECT COUNT(produto_id) FROM d_produto) AS total_produtos_esperado_9,
    (SELECT COUNT(DISTINCT ramo) FROM d_produto) AS total_ramos_esperado_3,
    (SELECT COUNT(canal_id) FROM d_canal) AS total_canais_esperado_6;

/* VALIDAÇÃO 4: Validando Período, Apólices, Financeiro, Churn e Ticket Médio */
SELECT 
    MIN(data_inicio) AS data_minima_esperado_2020,
    MAX(data_inicio) AS data_maxima_esperado_2025,
    COUNT(apolice_id) AS total_apolices_esperado_120000,
    
    ROUND(SUM(receita_total), 2) AS receita_realizada_esperado_309M,
    ROUND(SUM(receita_esperada), 2) AS receita_esperada_esperado_384M,
    
    -- Perda (Diferença entre Esperada e Total nas Canceladas/Suspensas)
    ROUND(SUM(receita_esperada) - SUM(receita_total), 2) AS perda_churn_esperado_75M,
              
    -- Taxa de Churn (Canceladas / Total)
    ROUND(CAST(SUM(CASE WHEN status = 'Cancelada' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(apolice_id) * 100, 2) AS taxa_churn_esperada_18_4_pct,
    
    -- Ticket Médio Mensal
    ROUND(SUM(receita_total) / SUM(parcelas_pagas), 2) AS ticket_medio_esperado_222_65
    
FROM f_apolice;


SELECT count(DISTINCT  apolice_id) FROM f_apolice


SELECT
  (ROUND(SUM(receita_total) / count(*),2)/69) AS ticket_medio
FROM f_apolice 


SELECT min(data_inicio ),max(data_inicio )
from
f_apolice


SELECT 
    -- Somamos toda a receita (ou prêmio)
    SUM(receita_esperada) / 
    -- Dividimos pela contagem EXCLUSIVA de clientes
    COUNT(DISTINCT apolice_id) AS ticket_medio_cliente
FROM 
    vw_f_apolice


/* Não conseguimos chegar ao mesmo valor de ticket médio apresentado no documentação (R$222,65).
  
Seguindo a fórmula mais usada normalmente para o cálculo de ticket médio mensal, que seria Receita total / Qtde Distinta de Apólices / Qtde de meses o ticket médio ficaria em R$37,35.
  
 	SELECT
  	(ROUND(SUM(receita_total) / COUNT(DISTINCT apolice_id) /69) AS ticket_medio
	FROM f_apolice 
	
 O valor mais próximo que chegamos da documentção foi o valor de R$243,04 considerando a fórmula como sendo a Receita Total / Soma das Parcelas Pagas.


 */
    
   


/* =========================================================
   VALIDAÇÃO 5: Distribuição por Status
   Objetivo: Bater o volume exato de Vencidas, Canceladas, Ativas e Suspensas.
========================================================= */
SELECT 
    status,
    COUNT(apolice_id) AS quantidade_validada
FROM f_apolice
GROUP BY status
ORDER BY quantidade_validada DESC;

/* =========================================================
   VALIDAÇÃO 6: Ranking de Motivos de Churn
   Objetivo: Confirmar o volume e o % de participação de cada motivo.
========================================================= */
SELECT 
    motivo_cancelamento,
    COUNT(apolice_id) AS quantidade_validada,
    ROUND(COUNT(apolice_id) * 100.0 / (SELECT COUNT(*) FROM f_apolice WHERE status = 'Cancelada'), 1) AS participacao_pct_validada
FROM f_apolice
WHERE status = 'Cancelada'
GROUP BY motivo_cancelamento
ORDER BY quantidade_validada DESC;


/* =========================================================
   VALIDAÇÃO 7: Distribuição da Forma de Pagamento
   Objetivo: Bater os percentuais aproximados (~35%, ~30%, etc).
========================================================= */
SELECT 
    forma_pagamento,
    COUNT(apolice_id) AS total_apolices,
    ROUND(COUNT(apolice_id) * 100.0 / (SELECT COUNT(*) FROM f_apolice), 1) AS participacao_pct_validada
FROM f_apolice
GROUP BY forma_pagamento
ORDER BY participacao_pct_validada DESC;


/* VALIDAÇÃO 8: Validando a Tabela d_produto */
SELECT 
    produto_id AS ID,
    nome_produto AS Produto,
    ramo AS Ramo,
    cobertura AS Cobertura,
    premio_medio_mensal AS Premio_R$,
    franquia_media AS Franquia_R$
FROM d_produto
ORDER BY produto_id;


/* VALIDAÇÃO 9: Validando a Tabela d_canal */
SELECT 
    canal_id AS ID,
    nome_canal AS Canal,
    tipo AS Tipo,
    comissao_percentual AS Comissao_pct
FROM d_canal
ORDER BY canal_id;


/* VALIDAÇÃO 10: Validando Apólices e Churn (%) por Ramo */
SELECT 
    p.ramo AS Ramo,
    COUNT(a.apolice_id) AS Apolices,
    ROUND(CAST(SUM(CASE WHEN a.status = 'Cancelada' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(a.apolice_id) * 100, 1) AS Churn_pct
FROM f_apolice a
JOIN d_produto p ON a.produto_id = p.produto_id
GROUP BY p.ramo
ORDER BY Apolices DESC;


/* VALIDAÇÃO 11: Validando Quantidade e % de Participação de cada Status */
SELECT 
    status AS Status,
    COUNT(apolice_id) AS Quantidade,
    ROUND(COUNT(apolice_id) * 100.0 / (SELECT COUNT(*) FROM f_apolice), 1) AS Percentual_pct
FROM f_apolice
GROUP BY status
ORDER BY Quantidade DESC;


/* VALIDAÇÃO 12: Validando o Volume de Apólices vendidas em cada Canal */
SELECT 
    c.nome_canal AS Canal,
    COUNT(a.apolice_id) AS Apolices
FROM f_apolice a
JOIN d_canal c ON a.canal_id = c.canal_id
GROUP BY c.nome_canal
ORDER BY Apolices DESC;

/* =========================================================================
QUERY 1: Análise de Churn por Ramo de Seguro
Objetivo: Identificar qual linha de negócio (Automóvel, Vida ou Residencial) apresenta a maior taxa de evasão.
Justificativa de Negócios: Saber onde o sangramento é maior permite à diretoria priorizar recursos. Se o problema for "Automóvel", a estratégia de contenção é completamente diferente de "Vida".
Insight Esperado: Descobrir o "Produto Ofensor" que está puxando a média de 20% de cancelamento para cima.
========================================================================= */
SELECT
    p.ramo,
    COUNT(a.apolice_id) AS total_apolices,
    SUM(CASE WHEN a.status = 'Cancelada' THEN 1 ELSE 0 END) AS apolices_canceladas,
    ROUND(CAST(SUM(CASE WHEN a.status = 'Cancelada' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(a.apolice_id) * 100, 2) AS taxa_churn_pct
FROM f_apolice a
JOIN d_produto p ON a.produto_id = p.produto_id
GROUP BY p.ramo
ORDER BY taxa_churn_pct DESC;


/* =========================================================================
QUERY 2: Mapeamento de Causas Raiz (Motivos de Cancelamento)
Objetivo: Quantificar a representatividade de cada motivo de cancelamento registrado.
Justificativa de Negócios: O Churn é um sintoma, o motivo é a doença. Entender se o cliente sai por "Preço", "Concorrência" ou "Mau Atendimento" direciona a solução para o departamento correto, evitando "apontamento de dedos".
Insight Esperado: Descobrir o principal ofensor operacional que motiva a saída do cliente.
========================================================================= */
SELECT
    motivo_cancelamento,
    COUNT(apolice_id) AS total_cancelamentos,
    ROUND(COUNT(apolice_id) * 100.0 / (SELECT COUNT(*) FROM f_apolice WHERE status = 'Cancelada'), 2) AS representatividade_pct
FROM f_apolice
WHERE status = 'Cancelada'
GROUP BY motivo_cancelamento
ORDER BY total_cancelamentos DESC;


/* =========================================================================
QUERY 3: Curva de Sobrevivência (Churn vs. Tempo de Casa)
Objetivo: Analisar em qual momento do ciclo de vida o cliente decide cancelar a apólice.
Justificativa de Negócios: Distinguir entre Early Churn (cancelamento nos primeiros meses, indicando falha no onboarding) e Late Churn (cancelamento na renovação, indicando falta de percepção de valor a longo prazo).
Insight Esperado: Mapear o "mês crítico" onde a retenção falha.
========================================================================= */
WITH ChurnTempo AS (
    SELECT
        apolice_id,
        CAST((julianday(data_cancelamento) - julianday(data_inicio)) / 30 AS INTEGER) AS meses_ativos
    FROM f_apolice
    WHERE status = 'Cancelada'
)
SELECT
    CASE
        WHEN meses_ativos <= 3 THEN '1. Até 3 meses (Early Churn)'
        WHEN meses_ativos <= 6 THEN '2. 4 a 6 meses'
        WHEN meses_ativos <= 12 THEN '3. 7 a 12 meses'
        ELSE '4. Mais de 12 meses'
    END AS faixa_tempo,
    COUNT(apolice_id) AS total_cancelamentos
FROM ChurnTempo
GROUP BY faixa_tempo
ORDER BY faixa_tempo;


/* =========================================================================
QUERY 4: Qualidade da Aquisição (Churn por Canal de Venda)
Objetivo: Comparar a taxa de retenção entre os diferentes canais (ex: Corretor vs. Digital).
Justificativa de Negócios: Um canal pode trazer volume, mas se esses clientes cancelam rápido, o ROI é negativo. Isso ajuda a diretoria a realocar o orçamento e rever o modelo de comissionamento.
Insight Esperado: Identificar qual canal de vendas traz o cliente mais fiel e qual canal traz o cliente mais volátil.
========================================================================= */
SELECT
    c.nome_canal,
    COUNT(a.apolice_id) AS total_apolices,
    SUM(CASE WHEN a.status = 'Cancelada' THEN 1 ELSE 0 END) AS apolices_canceladas,
    ROUND(CAST(SUM(CASE WHEN a.status = 'Cancelada' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(a.apolice_id) * 100, 2) AS taxa_churn_pct
FROM f_apolice a
JOIN d_canal c ON a.canal_id = c.canal_id
GROUP BY c.nome_canal
ORDER BY taxa_churn_pct DESC;


/* =========================================================================
QUERY 5: Dimensionamento do Impacto Financeiro (Receita Perdida)
Objetivo: Calcular o valor exato em Reais (R$) da receita esperada que evaporou.
Justificativa de Negócios: Traduzir a perda para valor financeiro real (GAP Global entre Esperada e Realizada).
Insight Esperado: Revelar o tamanho exato do "rombo" financeiro total de R$ 75M.
========================================================================= */
SELECT
    SUM(receita_esperada) AS receita_total_esperada_global,
    
    -- GAP Financeiro Global (Garante os R$ 75M)
    SUM(receita_esperada) - SUM(receita_total) AS receita_perdida_total,
        
    ROUND((SUM(receita_esperada) - SUM(receita_total)) / SUM(receita_esperada) * 100, 2) AS pct_receita_perdida
FROM f_apolice;


/* =========================================================================
Criação das Views
=========================================================================*/

-- View da Fato Apólice
CREATE VIEW vw_f_apolice AS
SELECT 
    apolice_id,
    cliente_id,
    produto_id,
    canal_id,
    data_inicio,
    data_fim_prevista,
    vigencia_meses,
    premio_mensal,
    parcelas_pagas,
    receita_total,
    receita_esperada,
    comissao,
    forma_pagamento,
    status,
    data_cancelamento,
    -- Tratamento com TRIM() para limpar eventuais espaços ocultos no motivo
    CASE 
        WHEN status = 'Cancelada' AND (motivo_cancelamento IS NULL OR TRIM(motivo_cancelamento) = '') THEN 'Motivo Não Informado'
        WHEN status != 'Cancelada' THEN 'N/A (' || status || ')'
        ELSE motivo_cancelamento 
    END AS motivo_cancelamento_tratado
FROM f_apolice;
-- Sem cláusula WHERE! Deixamos os 120.000 registros passarem livres.

-- View de Clientes
CREATE VIEW vw_d_cliente AS
SELECT 
    cliente_id,
    uf,
    regiao_id,
    faixa_etaria,
    genero,
    tipo_cliente,
    tempo_cliente_meses
FROM d_cliente;

-- View de Produtos
CREATE VIEW vw_d_produto AS
SELECT 
    produto_id,
    nome_produto,
    ramo,
    cobertura,
    premio_medio_mensal,
    franquia_media
FROM d_produto;

-- View de Canais
CREATE VIEW vw_d_canal AS
SELECT 
    canal_id,
    nome_canal,
    tipo AS tipo_canal,
    comissao_percentual
FROM d_canal;

-- View de Região
CREATE VIEW vw_d_regiao AS
SELECT 
    regiao_id,
    uf,
    estado,
    regiao
FROM d_regiao;

-- View de Calendário
CREATE VIEW vw_d_calendario AS
SELECT 
    data,
    ano,
    mes,
    (ano * 100) + mes AS chave_ano_mes, -- (Chave)
    nome_mes,
    trimestre,
    semestre,
    dia_semana,
    nome_dia_semana,
    is_fim_semana,
    is_feriado
FROM d_calendario;

-- View de Metas
CREATE VIEW vw_d_meta_mensal AS
SELECT 
    meta_id,
    ano,
    mes,
    (ano * 100) + mes AS chave_ano_mes, -- Conecta direto com a vw_d_calendario
    meta_novas_apolices,
    meta_receita_premios,
    meta_taxa_churn
FROM d_meta_mensal;