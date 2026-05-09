# 🛡️ Seguradora Xperiun | Churn Prediction & Retention Analytics

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-00A4EF?style=for-the-badge&logo=microsoft&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)

> **Business Intelligence solution developed to predict customer churn, simulate retention ROI, and provide actionable insights for an insurance company.**

---

## 📌 Contexto e Objetivos (Business Problem)
No setor segurador, o custo de aquisição de um novo cliente é significativamente superior ao de retenção. A **Seguradora Xperiun** enfrentava uma lacuna de visibilidade sobre as causas reais de cancelamento de apólices e o impacto financeiro futuro dessas perdas, necessitando de uma *Single Source of Truth* (Fonte Única da Verdade) para guiar a operação.

O objetivo deste projeto foi desenvolver um Produto de Dados preditivo e tático, estruturado em três pilares:
1. **Visão Executiva (Performance):** Acompanhamento financeiro (Receita Realizada, Esperada e Perdida via *Waterfall*).
2. **Visão Diagnóstica (Raio-X):** Mapeamento de causa-raiz da evasão através da aplicação do Princípio de Pareto.
3. **Visão Preditiva (Simulador):** Ferramenta de ROI baseada no LTV vs. Probabilidade de Churn, orientando ações de recuperação.

---

## ⚙️ Arquitetura da Solução (Architecture)
O projeto foi desenvolvido cobrindo o ciclo de engenharia e visualização de dados:

1. **Camada de Dados (Database):** Banco de dados relacional para estruturação do histórico de apólices e clientes.
2. **Camada Semântica (SQL/ETL):** Criação de *Views* para centralização de regras de negócio, tratamento de ruídos operacionais e preparação da base analítica.
3. **Modelagem (Power BI):** Construção de um *Star Schema* otimizado para suportar simulações paramétricas complexas (*What-If*).
4. **Governança e UX/UI:** * Injeção de códigos **HTML e CSS** nativos no DAX para renderizar um Dicionário de Dados interativo.
   * Criação de *Smart Cards* (Tooltips) programados com gráficos em **SVG**.
   * Desenvolvimento de parâmetros dinâmicos para transição de tema (*Dark/Light Mode*).

---

## 📊 Destaques Visuais (Dashboard Previews)

### 1. Visão Executiva (Dark Mode UI)
<img src="./assets/01-Visao-Executiva.png" width="800">

### 2. Simulador Preditivo de Retenção
<img src="./assets/02-Simulador-Retencao.png" width="800">

---

## 💡 Principais Insights Gerados (Key Findings)

* **Vulnerabilidade em Canais Digitais:** O mapeamento por canal de aquisição revelou que as vendas digitais (Site e Aplicação) apresentam as maiores taxas de Churn, exigindo planos agressivos de fidelização no pós-venda.
* **Engenharia de Ticket Médio e ROI:** A análise determinou um Prémio Mensal Médio de aproximadamente **R$ 243,00** por apólice. Este indicador foi vital para calibrar o simulador, demonstrando que uma melhoria de apenas 5% a 10% na retenção representa milhões de reais em receita salva.
* **Foco no 80/20 (Causa-Raiz):** Através do Gráfico de Pareto, descobriu-se que o "Preço Alto" e a "Concorrência" não eram ruídos, mas os grandes impulsionadores da evasão, direcionando a necessidade de campanhas de *downgrade* assistido.

---

## 📁 Estrutura do Repositório

```text
📦 bi-seguradora-xperiun-churn
 ┣ 📂 assets/                 # Imagens, logos e GIFs utilizados no README
 ┣ 📂 docs/                   # Documentação, Apresentação Executiva e PDFs
 ┣ 📂 power_bi/               # Arquivo principal do Dashboard (.pbix)
 ┣ 📂 sql_scripts/            # Queries e criação de Views para a camada semântica
 ┗ 📜 README.md               # Apresentação do projeto
```
👨‍💻 Autor
Wilderson "Will" Pinto | Business Intelligence & Data Analytics

💼 [Meu Portfólio Notion](https://wise-whippet-9ea.notion.site/Engenharia-de-Dados-e-BI-Transformando-dados-complexos-em-decis-es-de-neg-cios-eaaa0811698d416ea465b87115d2f9ff?pvs=143)

🔗 [Meu LinkedIn](https://www.linkedin.com/in/will-mp)
